open Core_kernel
open Bistro
open Bistro.Shell_dsl

class type index = object
  method contents : [`bowtie_index]
  inherit directory
end

let img = [ docker_image ~account:"pveber" ~name:"bowtie" ~tag:"1.1.2" () ]

(* memory bound correspond to storing a human index in memory, following bowtie manual *)
let bowtie_build ?packed ?color fa =
  Workflow.shell ~descr:"bowtie_build" ~mem:(Workflow.int (3 * 1024)) [
    mkdir_p dest ;
    cmd "bowtie-build" ~img [
      option (flag string "-a -p") packed ;
      option (flag string "--color") color ;
      opt "-f" dep fa ;
      seq [ dest ; string "/index" ]
    ]
  ]

let bowtie ?l ?e ?m ?fastq_format ?n ?v ?maxins index fastq_files =
  let args = match fastq_files with
    | SE_or_PE.Single_end fqs -> list dep ~sep:"," fqs
    | Paired_end (fqs1, fqs2) ->
      seq [
        opt "-1" (list dep ~sep:",") fqs1 ;
        string " " ;
        opt "-2" (list dep ~sep:",") fqs2
      ]
  in
  Workflow.shell ~descr:"bowtie" ~mem:(Workflow.int (3 * 1024)) ~np:8 [
    cmd "bowtie" ~img [
      string "-S" ;
      option (opt "-n" int) n ;
      option (opt "-l" int) l ;
      option (opt "-e" int) e ;
      option (opt "-m" int) m ;
      option (opt "-v" int) v ;
      option (opt "-q" (Bowtie2.qual_option % string)) fastq_format ;
      opt "-p" Fn.id np ;
      option (opt "--maxins" int) maxins ;
      seq [dep index ; string "/index"] ;
      args ;
      dest ;
    ]
  ]
