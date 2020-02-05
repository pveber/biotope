open Bistro

val bowtie_build :
  ?packed:bool ->
  ?color:bool  ->
  fasta file -> [`bowtie_index] directory

val bowtie :
  ?l:int -> ?e:int -> ?m:int ->
  ?fastq_format:Fastq.format ->
  ?n:int -> ?v:int ->
  ?maxins:int ->
  [`bowtie_index] directory ->
  #fastq file list SE_or_PE.t ->
  sam file
