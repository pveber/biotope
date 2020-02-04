open Bistro
open Bistro.Shell_dsl

let img = [ docker_image ~account:"pveber" ~name:"fastqc" ~tag:"0.11.8" () ]

class type report = object
  inherit directory
  method contents : [`fastQC_report]
end

module Cmd = struct
  let fastqc x = [
    mkdir_p dest ;
    cmd "fastqc" ~img [
      seq ~sep:"" [ string "--outdir=" ; dest ] ;
      (
        match x with
        | `fq fq -> dep fq
        | `fq_gz fq_gz -> gzdep fq_gz
      )
    ] ;
    and_list [
      cd dest ;
      cmd "unzip" [ string "*_fastqc.zip" ] ;
      cmd "mv" [ string "*_fastqc/*" ; string "." ]
    ] ;
  ]
end

let fastqc fq = Workflow.shell ~descr:"fastQC" (Cmd.fastqc (`fq fq))

let fastqc_gz fq_gz = Workflow.shell ~descr:"fastQC" (Cmd.fastqc (`fq_gz fq_gz))

let html_report x = Workflow.select x ["fastqc_report.html"]

let per_base_quality x =
  Workflow.select x ["Images" ; "per_base_quality.png"]

let per_base_sequence_content x =
  Workflow.select x ["Images" ; "per_base_sequence_content.png"]
