open Bistro

val img : Shell_dsl.container_image list

val fastq_dump :
  ?minReadLen:int ->
  [`id of string | `idw of string workflow | `file of sra file] ->
  fastq file

val fastq_dump_gz :
  ?minReadLen:int ->
  [`id of string | `file of sra file] ->
  fastq gz file

val fastq_dump_pe :
  ?minReadLen:int ->
  sra file ->
  fastq file * fastq file

val fastq_dump_pe_gz :
  ?minReadLen:int ->
  [`id of string | `file of sra file] ->
  fastq gz file * fastq gz file

val fastq_dump_to_fasta :
  ?minReadLen:int ->
  sra file -> fasta file
