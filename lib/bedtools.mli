open Bistro

val img : Shell_dsl.container_image list

type 'a input

val bed : #bed3 input
val gff : gff input


module Cmd : sig
  val slop :
    ?strand:bool ->
    ?header:bool ->
    mode:[
      | `both of int
      | `left of int
      | `right of int
      | `both_pct of float
      | `left_pct of float
      | `right_pct of float
    ] ->
    'a pworkflow ->
    Ucsc_gb.chrom_sizes pworkflow ->
    Bistro.Shell_dsl.command
end


val slop :
  ?strand:bool ->
  ?header:bool ->
  mode:[
    | `both of int
    | `left of int
    | `right of int
    | `both_pct of float
    | `left_pct of float
    | `right_pct of float
  ] ->
  'a input ->
  'a pworkflow ->
  Ucsc_gb.chrom_sizes pworkflow ->
  'a pworkflow


val intersect :
  ?ubam:bool ->
  ?wa:bool ->
  ?wb:bool ->
  ?loj:bool ->
  ?wo:bool ->
  ?wao:bool ->
  ?u:bool ->
  ?c:bool ->
  ?v:bool ->
  ?f:float ->
  ?_F:float ->
  ?r:bool ->
  ?e:bool ->
  ?s:bool ->
  ?_S:bool ->
  ?split:bool ->
  ?sorted:bool ->
  ?g:Ucsc_gb.chrom_sizes pworkflow ->
  ?header:bool ->
  ?filenames:bool ->
  ?sortout:bool ->
  'a input ->
  'a pworkflow ->
  #bed3 pworkflow list ->
  'a pworkflow

val bamtobed :
  ?bed12:bool ->
  ?split:bool ->
  ?splitD:bool ->
  ?ed:bool ->
  ?tag:bool ->
  ?cigar:bool ->
  bam pworkflow ->
  #bed6 pworkflow

val closest :
  ?strand:[`same | `opposite] ->
  ?io:bool ->
  ?iu:bool ->
  ?id:bool ->
  ?fu:bool ->
  ?fd:bool ->
  ?ties:[`all | `first | `last] ->
  ?mdb:[`each | `all] ->
  ?k:int ->
  ?header:bool ->
  'a input ->
  'a pworkflow ->
  #bed3 pworkflow list ->
  'a pworkflow
