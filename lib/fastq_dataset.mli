open Bistro

type source =
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
  val fastqc : Data.t -> FastQC.report pworkflow list SE_or_PE.t
end
