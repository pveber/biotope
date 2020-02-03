open Bistro

val meme :
  ?nmotifs:int ->
  ?minw:int ->
  ?maxw:int ->
  ?revcomp:bool ->
  ?maxsize:int ->
  ?alphabet:[`dna | `rna | `protein] ->
  (* ?threads:int -> *)
  fasta pworkflow ->
  [`meme] dworkflow

val meme_logo :
  [`meme] dworkflow ->
  ?rc:bool ->
  int ->
  png pworkflow

val meme_chip :
  ?meme_nmotifs:int ->
  ?meme_minw:int ->
  ?meme_maxw:int ->
  (* ?np:int -> *)
  fasta pworkflow ->
  [`meme_chip] dworkflow

(** http://meme-suite.org/doc/fimo.html?man_type=web *)
val fimo :
  ?alpha: float ->
  ?bgfile:text_file pworkflow ->
  ?max_stored_scores: int ->
  ?max_strand:bool ->
  ?motif:string ->
  ?motif_pseudo:float ->
  ?no_qvalue:bool ->
  ?norc:bool ->
  ?parse_genomic_coord:bool ->
  ?prior_dist:text_file pworkflow ->
  ?psp:text_file pworkflow ->
  ?qv_thresh:bool ->
  ?thresh: float ->
  [`meme] dworkflow ->
  fasta pworkflow ->
  directory pworkflow
