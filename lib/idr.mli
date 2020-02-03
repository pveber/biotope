open Bistro

type 'a format

val narrowPeak : Macs2.narrow_peaks format
val broadPeak : Macs2.broad_peaks format
val bed : bed3 format
val gff : gff format

type 'a output = [`idr_output of 'a]

val idr :
  input_file_type:'a format ->
  ?idr_threshold:float ->
  ?soft_idr_threshold:float ->
  ?peak_merge_method:[ `sum | `avg | `min | `max] ->
  ?rank:[ `signal | `pvalue | `qvalue ] ->
  ?random_seed:int ->
  ?peak_list:'a pworkflow ->
  'a pworkflow ->
  'a pworkflow ->
  'a output dworkflow

val items : 'a output dworkflow -> 'a pworkflow
val figure : _ output dworkflow -> png pworkflow
