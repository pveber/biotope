open Bistro

val run_gen_cmd :
  ?mlst_db:fasta pworkflow ->
  ?mlst_delimiter:string ->
  ?mlst_definitions:fasta pworkflow ->
  ?mlst_max_mismatch:int ->
  ?gene_db:fasta pworkflow list ->
  ?no_gene_details:bool ->
  ?gene_max_mismatch:int ->
  ?min_coverage:int ->
  ?max_divergence:int ->
  ?min_depth:int ->
  ?min_edge_depth:int ->
  ?prob_err:float ->
  ?truncation_score_tolerance:int ->
  ?other:string ->
  ?max_unaligned_overlap:int ->
  ?mapq:int ->
  ?baseq:int ->
  ?samtools_args:string ->
  ?report_new_consensus:bool ->
  ?report_all_consensus:bool ->
  string ->
  Shell_dsl.template list ->
  Shell_dsl.command


val run_se :
  ?mlst_db:fasta pworkflow ->
  ?mlst_delimiter:string ->
  ?mlst_definitions:fasta pworkflow ->
  ?mlst_max_mismatch:int ->
  ?gene_db:fasta pworkflow list ->
  ?no_gene_details:bool ->
  ?gene_max_mismatch:int ->
  ?min_coverage:int ->
  ?max_divergence:int ->
  ?min_depth:int ->
  ?min_edge_depth:int ->
  ?prob_err:float ->
  ?truncation_score_tolerance:int ->
  ?other:string ->
  ?max_unaligned_overlap:int ->
  ?mapq:int ->
  ?baseq:int ->
  ?samtools_args:string ->
  ?report_new_consensus:bool ->
  ?report_all_consensus:bool ->
  ?threads:int ->
  #fastq pworkflow list ->
  directory pworkflow


val run_pe :
  ?mlst_db:fasta pworkflow ->
  ?mlst_delimiter:string ->
  ?mlst_definitions:fasta pworkflow ->
  ?mlst_max_mismatch:int ->
  ?gene_db:fasta pworkflow list ->
  ?no_gene_details:bool ->
  ?gene_max_mismatch:int ->
  ?min_coverage:int ->
  ?max_divergence:int ->
  ?min_depth:int ->
  ?min_edge_depth:int ->
  ?prob_err:float ->
  ?truncation_score_tolerance:int ->
  ?other:string ->
  ?max_unaligned_overlap:int ->
  ?mapq:int ->
  ?baseq:int ->
  ?samtools_args:string ->
  ?report_new_consensus:bool ->
  ?report_all_consensus:bool ->
  ?threads:int ->
  #fastq pworkflow list ->
  directory pworkflow
