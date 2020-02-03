open Bistro

val assembly_summary : tsv pworkflow

val fetch_assembly :
  genome_id:string ->
  assembly_id:string ->
  fasta gz pworkflow
