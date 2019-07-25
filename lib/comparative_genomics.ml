open Core_kernel

let select_refseq_genomes ~pattern = [%workflow
  let re = Re.Glob.glob [%param pattern] |> Re.compile in
  Gzt.Ncbi_genome.Assembly_summary.csv_load [%path Ncbi_genome.assembly_summary]
  |> List.filter ~f:(fun it -> Re.execp re it.organism_name)
  (* |> List.map ~f:(fun it ->
   *     
   *   ) *)
]
  
let fetch_refseq_genomes ~pattern =
  select_refseq_genomes ~pattern
  |> Bistro.Workflow.spawn
