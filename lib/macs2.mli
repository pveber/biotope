open Bistro

val pileup :
  ?extsize:int ->
  ?both_direction:bool ->
  bam pworkflow -> Ucsc_gb.bedGraph pworkflow

type gsize = [`hs | `mm | `ce | `dm | `gsize of int]
type keep_dup = [ `all | `auto | `int of int ]

type _ format

val sam : sam format
val bam : bam format

class type output = object
  inherit directory
  method contents : [`macs2]
end

class type narrow_output = object
  inherit output
  method peak_type : [`narrow]
end

class type broad_output = object
  inherit output
  method peak_type : [`broad]
end

val callpeak :
  ?pvalue:float ->
  ?qvalue:float ->
  ?gsize:gsize ->
  ?call_summits:bool ->
  ?fix_bimodal:bool ->
  ?mfold:int * int ->
  ?extsize:int ->
  ?nomodel:bool ->
  ?bdg:bool ->
  ?control:'a pworkflow list ->
  ?keep_dup:keep_dup ->
  'a format ->
  'a pworkflow list ->
  narrow_output pworkflow

class type peaks_xls = object
  inherit bed3
  method f4 : int
  method f5 : int
  method f6 : int
  method f7 : float
  method f8 : float
  method f9 : float
end

val peaks_xls : #output pworkflow -> peaks_xls pworkflow

class type narrow_peaks = object
  inherit bed5
  method f6 : string
  method f7 : float
  method f8 : float
  method f9 : float
  method f10 : int
end

val narrow_peaks : narrow_output pworkflow -> narrow_peaks pworkflow

class type peak_summits = object
  inherit bed4
  method f5 : float
end

val peak_summits : #output pworkflow -> peak_summits pworkflow

val callpeak_broad :
  ?pvalue:float ->
  ?qvalue:float ->
  ?gsize:gsize ->
  ?call_summits:bool ->
  ?fix_bimodal:bool ->
  ?mfold:int * int ->
  ?extsize:int ->
  ?nomodel:bool ->
  ?bdg:bool ->
  ?control:'a pworkflow list ->
  ?keep_dup:keep_dup ->
  'a format ->
  'a pworkflow list ->
  broad_output pworkflow

class type broad_peaks = object
  inherit bed5
  method f6 : string
  method f7 : float
  method f8 : float
  method f9 : float
end

val broad_peaks : broad_output pworkflow -> broad_peaks pworkflow
