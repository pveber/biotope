open Bistro

class type output = object
  inherit directory
  method contents : [`fastq_screen]
end

val fastq_screen :
  ?bowtie2_opts:string ->
  ?filter: [ `Not_map | `Uniquely | `Multi_maps | `Maps | `Not_map_or_Uniquely | `Not_map_or_Multi_maps | `Ignore ] list ->
  ?illumina:bool ->
  ?nohits:bool ->
  ?pass:int ->
  ?subset:int ->
  ?tag:bool ->
  ?threads:int ->
  ?top: [ `top1 of int | `top2 of int * int ] ->
  ?lightweight:bool ->
  Fastq_sample.t ->
  (string * fasta pworkflow) list ->
  output pworkflow

val html_report : output pworkflow -> html pworkflow
