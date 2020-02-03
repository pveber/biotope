open Bistro
open Bistro.Shell_dsl

let img = [ docker_image ~account:"pveber" ~name:"fastqc" ~tag:"0.11.5" () ]

class type report = object
  inherit directory
  method contents : [`fastQC_report]
end

let run fq = Workflow.shell ~descr:"fastQC" [
    mkdir_p dest ;
    cmd "fastqc" ~img [
      seq ~sep:"" [ string "--outdir=" ; dest ] ;
      dep fq ;
    ] ;
    and_list [
      cd dest ;
      cmd "unzip" [ string "*_fastqc.zip" ] ;
      cmd "mv" [ string "*_fastqc/*" ; string "." ]
    ] ;
  ]

let html_report x = Workflow.select x ["fastqc_report.html"]

let per_base_quality x =
  Workflow.select x ["Images" ; "per_base_quality.png"]

let per_base_sequence_content x =
  Workflow.select x ["Images" ; "per_base_sequence_content.png"]
