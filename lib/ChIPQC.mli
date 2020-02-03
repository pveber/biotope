open Bistro

type 'a sample = {
  id : string ;
  tissue : string ;
  factor : string ;
  replicate : string ;
  bam : indexed_bam pworkflow ;
  peaks : (#bed3 as 'a) pworkflow ;
}

class type output = object
  inherit directory
  method contents : [`ChIPQC]
end

val run : 'a sample list -> output pworkflow
(** Beware: doesn't work with only one sample (see
    https://support.bioconductor.org/p/84754/) *)
