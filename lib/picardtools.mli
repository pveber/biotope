open Bistro

val img : Shell_dsl.container_image list

val markduplicates :
  ?remove_duplicates:bool ->
  [`indexed_bam] dworkflow ->
  [`picard_markduplicates] dworkflow

val reads :
  [`picard_markduplicates] dworkflow ->
  bam pworkflow

val sort_bam_by_name :
  bam pworkflow ->
  bam pworkflow
