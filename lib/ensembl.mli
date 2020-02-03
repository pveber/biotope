open Bistro

type species = [
  | `homo_sapiens
  | `mus_musculus
]

val ucsc_reference_genome : release:int -> species:species -> Ucsc_gb.genome

val gff : ?chr_name : [`ensembl | `ucsc] -> release:int -> species:species -> gff pworkflow
val gtf : ?chr_name : [`ensembl | `ucsc] -> release:int -> species:species -> gff pworkflow

val cdna : release:int -> species:species -> fasta gz pworkflow
