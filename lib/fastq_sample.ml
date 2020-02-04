open Core_kernel
open Bistro

type t =
  | Fq of fastq pworkflow list SE_or_PE.t
  | Fq_gz of fastq gz pworkflow list SE_or_PE.t

let is_single_end = function
  | Fq (Single_end _)
  | Fq_gz (Single_end _ ) -> true
  | Fq (Paired_end _)
  | Fq_gz (Paired_end _) -> false

let dep = function
  | Fq se_or_pe -> SE_or_PE.map se_or_pe ~f:(List.map ~f:Shell_dsl.dep)
  | Fq_gz se_or_pe -> SE_or_PE.map se_or_pe ~f:(List.map ~f:Bistro_unix.Cmd.gzdep)


type source =
  | Fastq_url of string list SE_or_PE.t
  | Fastq_gz_url of string list SE_or_PE.t
  | SRA_dataset of { srr_ids : string list ;
                     library_type : [`single_end | `paired_end] }

module type Data = sig
  type t
  val source : t -> source
end

module Make(Data : Data) = struct
  let unsafe_file_of_url url : 'a pworkflow =
    if String.is_prefix ~prefix:"http://" url || String.is_prefix ~prefix:"ftp://" url
    then Bistro_unix.wget url
    else Workflow.input url

  let rec fastq_gz x =
    match Data.source x with
    | Fastq_url _ ->
      SE_or_PE.map (fastq x) ~f:(List.map ~f:Bistro_unix.gzip)
    | Fastq_gz_url uris ->
      SE_or_PE.map uris ~f:(List.map ~f:unsafe_file_of_url)
    | SRA_dataset { srr_ids ; library_type } ->
      match library_type with
      | `paired_end ->
        let r1, r2 =
          srr_ids
          |> List.map ~f:(fun id -> Sra_toolkit.fastq_dump_pe_gz (`id id))
          |> List.unzip
        in
        Paired_end (r1, r2)
      | `single_end ->
        Single_end (List.map srr_ids ~f:(fun id -> Sra_toolkit.fastq_dump_gz (`id id)))

  and fastq x =
    match Data.source x with
    | Fastq_url uris ->
      SE_or_PE.map uris ~f:(List.map ~f:unsafe_file_of_url)
    | Fastq_gz_url _
    | SRA_dataset _ ->
      SE_or_PE.map ~f:(List.map ~f:Bistro_unix.gunzip) (fastq_gz x)

  let fastq_sample x =
    match Data.source x with
    | Fastq_url _ -> Fq (fastq x)
    | SRA_dataset _
    | Fastq_gz_url _ -> Fq_gz (fastq_gz x)

  let fastqc x =
    SE_or_PE.map (fastq_gz x) ~f:(List.map ~f:FastQC.fastqc_gz)
end
