open Bistro

class type index = object
  method contents : [`bowtie_index]
  inherit directory
end

val bowtie_build :
  ?packed:bool ->
  ?color:bool  ->
  fasta pworkflow -> index pworkflow

val bowtie :
  ?l:int -> ?e:int -> ?m:int ->
  ?fastq_format:Fastq.format ->
  ?n:int -> ?v:int ->
  ?maxins:int ->
  index pworkflow ->
  #fastq pworkflow list SE_or_PE.t ->
  sam pworkflow
