open Bistro

val img : Shell_dsl.container_image list

val fastq_dump :
  [`id of string | `idw of string workflow | `file of sra pworkflow] ->
  fastq pworkflow

val fastq_dump_gz :
  [`id of string | `file of sra pworkflow] ->
  fastq gz pworkflow

val fastq_dump_pe : sra pworkflow -> fastq pworkflow * fastq pworkflow

val fastq_dump_pe_gz :
  [`id of string | `file of sra pworkflow] ->
  fastq gz pworkflow * fastq gz pworkflow

val fastq_dump_to_fasta : sra pworkflow -> fasta pworkflow
