open Bistro

val genomeGenerate : fasta pworkflow -> [`star_index] dworkflow

val alignReads :
  ?max_mem:[`GB of int] ->
  ?outFilterMismatchNmax:int ->
  ?outFilterMultimapNmax:int ->
  ?outSAMstrandField:[`None | `intronMotif] ->
  ?alignIntronMax:int ->
  [`star_index] dworkflow ->
  fastq pworkflow SE_or_PE.t ->
  bam pworkflow
