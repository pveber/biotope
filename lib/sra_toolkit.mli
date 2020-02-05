open Bistro

val img : Shell_dsl.container_image list

val fastq_dump :
  [`id of string | `idw of string workflow | `file of sra file] ->
  fastq file

val fastq_dump_gz :
  [`id of string | `file of sra file] ->
  fastq gz file

val fastq_dump_pe : sra file -> fastq file * fastq file

val fastq_dump_pe_gz :
  [`id of string | `file of sra file] ->
  fastq gz file * fastq gz file

val fastq_dump_to_fasta : sra file -> fasta file
