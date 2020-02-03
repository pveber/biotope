open Bistro

val spades :
  ?single_cell:bool ->
  ?iontorrent:bool ->
  ?pe:sanger_fastq pworkflow list * sanger_fastq pworkflow list ->
  ?threads:int ->
  ?memory:int ->
  unit ->
  [`spades] dworkflow

val contigs : [`spades] dworkflow -> fasta pworkflow
val scaffolds : [`spades] dworkflow -> fasta pworkflow
