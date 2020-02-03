open Bistro

type 'a format

val bam : bam format
val sam : sam format

val sort :
  ?on:[`name | `position] ->
  bam pworkflow -> bam pworkflow
val indexed_bam_of_sam : sam pworkflow -> indexed_bam pworkflow
val indexed_bam_of_bam : bam pworkflow -> indexed_bam pworkflow
val indexed_bam_to_bam : indexed_bam pworkflow -> bam pworkflow
val bam_of_sam : sam pworkflow -> bam pworkflow
val sam_of_bam : bam pworkflow -> sam pworkflow

(* val rmdup : ?single_end_mode:bool -> bam pworkflow -> bam pworkflow *)

val view :
  output:'o format ->
  (* ?_1:bool ->
   * ?u:bool -> *)
  ?h:bool ->
  ?_H:bool ->
  (* ?c:bool -> *)
  (* ?_L: #bed3 pworkflow -> *)
  ?q:int ->
  (* ?m:int ->
   * ?f:int ->
   * ?_F:int ->
   * ?_B:bool ->
   * ?s:float -> *)
  < file_kind : [`regular] ;
    format : [< `bam | `sam] ; .. > pworkflow ->
  'o pworkflow

val faidx :
  fasta pworkflow -> indexed_fasta pworkflow

val fasta_of_indexed_fasta :
  indexed_fasta pworkflow -> fasta pworkflow
