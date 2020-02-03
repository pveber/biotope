(** http://subread.sourceforge.net/ *)
open Bistro

class type count_table = object
  inherit tsv
  method header : [`no]
  method f1 : string
  method f2 : string
  method f3 : int
  method f4 : int
  method f5 : [`Plus | `Minus]
  method f6 : int
  method f7 : int
end

val featureCounts :
  ?feature_type:string ->
  ?attribute_type:string ->
  ?strandness:[`Unstranded | `Stranded | `Reversely_stranded] ->
  ?q:int ->
  ?nthreads:int ->
  gff pworkflow ->
  < format : [< `bam | `sam] ; .. > pworkflow -> (*FIXME: handle paired-hand, just add other file next to the other*)
  [`featureCounts] dworkflow

val featureCounts_tsv : [`featureCounts] dworkflow -> count_table pworkflow
val featureCounts_htseq_tsv : [`featureCounts] dworkflow -> Htseq.count_tsv pworkflow
val featureCounts_summary : [`featureCounts] dworkflow -> text_file pworkflow
