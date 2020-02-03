open Bistro

val merge :
  ?min_length:int ->
  (string * fasta pworkflow) list -> fasta pworkflow

val cisa :
  genome_size:int ->
  fasta pworkflow ->
  fasta pworkflow
