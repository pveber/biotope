open Bistro

val spades :
  ?single_cell:bool ->
  ?iontorrent:bool ->
  ?pe:fastq file list * fastq file list ->
  ?threads:int ->
  ?memory:int ->
  unit ->
  [`spades] directory

val contigs : [`spades] directory -> fasta file
val scaffolds : [`spades] directory -> fasta file
