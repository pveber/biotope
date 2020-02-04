open Bistro

type t =
  | Fq of fastq pworkflow list SE_or_PE.t
  | Fq_gz of fastq gz pworkflow list SE_or_PE.t

val is_single_end : t -> bool

val dep : t -> Shell_dsl.template list SE_or_PE.t

type source =
  | Fastq_url of string list SE_or_PE.t
  | Fastq_gz_url of string list SE_or_PE.t
  | SRA_dataset of { srr_ids : string list ;
                     library_type : [`single_end | `paired_end] }

module type Data = sig
  type t
  val source : t -> source
end

module Make(Data : Data) : sig
  val fastq : Data.t -> fastq pworkflow list SE_or_PE.t
  val fastq_gz : Data.t -> fastq gz pworkflow list SE_or_PE.t
  val fastq_sample : Data.t -> t
  val fastqc : Data.t -> FastQC.report pworkflow list SE_or_PE.t
end
