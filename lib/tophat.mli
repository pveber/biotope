open Bistro

class type output = object
  inherit directory
  method contents : [`tophat]
end

val tophat1 :
  ?color:bool ->
  Bowtie.index pworkflow ->
  #fastq pworkflow list SE_or_PE.t ->
  output pworkflow

val tophat2 :
  Bowtie2.index pworkflow ->
  #fastq pworkflow list SE_or_PE.t ->
  output pworkflow

val accepted_hits : output pworkflow -> bam pworkflow
val junctions : output pworkflow -> bed6 pworkflow
