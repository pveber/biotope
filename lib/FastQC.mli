open Bistro

class type report = object
  inherit directory
  method contents : [`fastQC_report]
end

val fastqc : #fastq pworkflow -> report pworkflow
val fastqc_gz : #fastq gz pworkflow -> report pworkflow
val html_report : report pworkflow -> html pworkflow
val per_base_quality : report pworkflow -> png pworkflow
val per_base_sequence_content : report pworkflow -> png pworkflow
