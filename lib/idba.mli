open Bistro

val fq2fa :
  ?filter:bool ->
  [ `Se of fastq pworkflow
  | `Pe_merge of fastq pworkflow * fastq pworkflow
  | `Pe_paired of fastq pworkflow ] ->
  fasta pworkflow

val idba_ud : ?mem_spec:int -> fasta pworkflow -> [`idba] dworkflow

val idba_ud_contigs : [`idba] dworkflow -> fasta pworkflow
val idba_ud_scaffolds : [`idba] dworkflow -> fasta pworkflow
