open Bistro

val bamstats : bam pworkflow -> text_file pworkflow
val fragment_length_stats : bam pworkflow -> text_file pworkflow
val chrstats : bam pworkflow -> text_file pworkflow
val summary :
  sample_name:('a -> string) ->
  mapped_reads:('a -> bam pworkflow) ->
  'a list ->
  html pworkflow
