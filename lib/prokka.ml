open Core_kernel
open Bistro
open Bistro.Shell_dsl

let img = [ docker_image ~account:"pveber" ~name:"prokka" ~tag:"1.12" () ]

let gram_expr = function
  | `Plus -> string "+"
  | `Minus -> string "-"

let run ?prefix ?addgenes ?locustag ?increment ?gffver ?compliant
    ?centre ?genus ?species ?strain ?plasmid ?kingdom ?gcode ?gram
    ?usegenus ?proteins ?hmms ?metagenome ?rawproduct ?fast ?(threads = 1)
    ?mincontiglen ?evalue ?rfam ?norrna ?notrna ?rnammer fa =
  Workflow.shell ~descr:"prokka" ~img ~np:threads ~mem:(Workflow.int (3 * 1024)) [
    mkdir_p dest ;
    cmd "prokka" [
      string "--force" ;
      option (opt "--prefix" string) prefix ;
      option (flag string "--addgenes") addgenes ;
      option (opt "--locustag" string) locustag ;
      option (opt "--increment" int) increment ;
      option (opt "--gffver" string) gffver ;
      option (flag string "--compliant") compliant ;
      option (opt "--centre" string) centre ;
      option (opt "--genus" string) genus ;
      option (opt "--species" string) species ;
      option (opt "--strain" string) strain ;
      option (opt "--plasmid" string) plasmid ;
      option (opt "--kingdom" string) kingdom ;
      option (opt "--gcode" int) gcode ;
      option (opt "--gram" gram_expr) gram ;
      option (flag string "--usegenus") usegenus ;
      option (opt "--proteins" string) proteins ;
      option (opt "--hmms" string) hmms ;
      option (flag string "--metagenome") metagenome ;
      option (flag string "--rawproduct") rawproduct ;
      option (flag string "--fast") fast ;
      opt "--cpus" Fn.id np ;
      option (opt "--mincontiglen" int) mincontiglen ;
      option (opt "--evalue" float) evalue ;
      option (flag string "--rfam") rfam ;
      option (flag string "--norrna") norrna ;
      option (flag string "--notrna") notrna ;
      option (flag string "--rnammer") rnammer ;
      opt "--outdir" Fn.id dest ;
      dep fa ;
    ] ;
  ]
