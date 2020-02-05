open Core_kernel
open Bistro

let select_refseq_genomes ~pattern = [%workflow
  let re = Re.Glob.glob [%param pattern] |> Re.compile in
  Biotk.Ncbi_genome.Assembly_summary.csv_load [%path Ncbi_genome.assembly_summary]
  |> List.filter ~f:(fun it -> Re.execp re it.organism_name)
  (* |> List.map ~f:(fun it ->
   *
   *   ) *)
]

let url_of_summary x =
  [%workflow
    [%eval x].Biotk.Ncbi_genome.Assembly_summary.assembly_accession]

let fetch_refseq_genomes ~pattern =
  select_refseq_genomes ~pattern
  |> Workflow.spawn ~f:url_of_summary
  |> Workflow.spawn ~f:Bistro_unix.wget_dyn
