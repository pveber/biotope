(** {{http://cab.spbu.ru/files/release3.14.0/manual.html}SPADES assembler} *)

open Bistro

val spades :
  ?single_cell:bool ->
  ?iontorrent:bool ->
  ?pe:fastq gz file list * fastq gz file list ->
  ?threads:int ->
  ?memory:int ->
  unit ->
  [`spades] directory

val contigs : [`spades] directory -> fasta file
val scaffolds : [`spades] directory -> fasta file

val rnaspades :
  ?pe:fastq gz file list * fastq gz file list ->
  ?threads:int ->
  ?memory:int ->
  unit ->
  [`rnaspades] directory

val transcripts : [`rnaspades] directory -> fasta file
val hard_filtered_transcripts : [`rnaspades] directory -> fasta file
val soft_filtered_transcripts : [`rnaspades] directory -> fasta file
