open Bistro

val spades :
  ?single_cell:bool ->
  ?iontorrent:bool ->
  ?pe:fastq pworkflow list * fastq pworkflow list ->
  ?threads:int ->
  ?memory:int ->
  unit ->
  [`spades] dworkflow

val contigs : [`spades] dworkflow -> fasta pworkflow
val scaffolds : [`spades] dworkflow -> fasta pworkflow
