open Bistro

type format =
  | Sanger
  | Solexa
  | Phred64

val concat : (#fastq as 'a) pworkflow list -> 'a pworkflow
val head : int -> (#fastq as 'a) pworkflow -> 'a pworkflow
