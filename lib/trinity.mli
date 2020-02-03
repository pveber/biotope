open Bistro

val img : Shell_dsl.container_image list

val trinity :
  ?mem:int ->
  ?no_normalize_reads:bool ->
  ?run_as_paired:bool ->
  sanger_fastq pworkflow list SE_or_PE.t ->
  fasta pworkflow

val prepare_fastq :
  int ->
  sanger_fastq pworkflow ->
  sanger_fastq pworkflow

val uniq_count_stats :
  sam pworkflow -> text_file pworkflow

val insilico_read_normalization :
  ?mem:int ->
  ?pairs_together:bool ->
  ?parallel_stats:bool ->
  max_cov:int ->
  sanger_fastq pworkflow SE_or_PE.t ->
  sanger_fastq pworkflow SE_or_PE.t

val get_Trinity_gene_to_trans_map :
  fasta pworkflow ->
  text_file pworkflow
