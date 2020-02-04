open Bistro

class type index = object
  inherit binary_file
  method format : [`kallisto_index]
end

class type abundance_table = object
  inherit tsv
  method f1 : [`target_id] * string
  method f2 : [`length] * int
  method f3 : [`eff_length] * int
  method f4 : [`est_counts] * float
  method f5 : [`tpm] * float
end

val img : Shell_dsl.container_image list
val index : fasta pworkflow list -> index pworkflow
val quant :
  ?bias:bool ->
  ?bootstrap_samples:int ->
  ?fr_stranded:bool ->
  ?rf_stranded:bool ->
  ?threads:int ->
  ?fragment_length:float ->
  ?sd:float ->
  index pworkflow ->
  fq1:[`fq of fastq pworkflow | `fq_gz of fastq gz pworkflow] ->
  ?fq2:[`fq of fastq pworkflow | `fq_gz of fastq gz pworkflow] ->
  unit ->
  [`kallisto_output] dworkflow

val abundance : [`kallisto_output] dworkflow -> abundance_table pworkflow

val merge_eff_counts :
  sample_ids:string list ->
  kallisto_outputs:abundance_table pworkflow list ->
  tsv pworkflow

val merge_tpms :
  sample_ids:string list ->
  kallisto_outputs:abundance_table pworkflow list ->
  tsv pworkflow
