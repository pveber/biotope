open Core_kernel
open Bistro
open Bistro.Shell_dsl

let img = [ docker_image ~account:"pveber" ~name:"spades" ~tag:"3.14.0" () ]

(* spades insists on reading file extensions~ *)
let renamings (ones, twos) =
  let f side i x =
    let id = sprintf "pe%d-%d" (i + 1) side in
    let new_name = seq ~sep:"/" [ tmp ; string (id ^ ".fq") ] in
    let opt = opt (sprintf "--pe%d-%d" (i + 1) side) Fn.id new_name in
    let cmd = cmd "ln" [ string "-s" ; dep x ; new_name ] in
    opt, cmd
  in
  let r = List.mapi ones ~f:(f 1) @ List.mapi twos ~f:(f 2) in
  let args = seq ~sep:" " (List.map r ~f:fst) in
  let cmds = List.map r ~f:snd in
  Some args, cmds

let spades
    ?single_cell ?iontorrent
    ?pe
    ?(threads = 4)
    ?(memory = 10)
    ()
  =
  let pe_args, ln_commands = match pe with
    | None -> None, []
    | Some files -> renamings files
  in
  Workflow.shell ~np:threads ~mem:(Workflow.int (memory * 1024)) ~descr:"spades" [
    mkdir_p tmp ;
    mkdir_p dest ;
    within_container img (
      and_list (
        ln_commands @ [
          cmd "spades.py" ~img [
            option (flag string "--sc") single_cell ;
            option (flag string "--iontorrent") iontorrent ;
            opt "--threads" Fn.id np ;
            opt "--memory" Fn.id (seq [ string "$((" ; mem ; string " / 1024))" ]) ;
            option Fn.id pe_args ;
            opt "-o" Fn.id dest ;
          ]
        ]
      )
    )
  ]

let contigs x = Workflow.select x ["contigs.fasta"]
let scaffolds x = Workflow.select x ["scaffolds.fasta"]

let strandness = function
  | `rf -> string "rf"
  | `fr -> string "fr"

let rnaspades
    ?pe ?(threads = 4) ?(memory = 10) ?ss
    ()
  =
  let pe_args, ln_commands = match pe with
    | None -> None, []
    | Some files -> renamings files
  in
  Workflow.shell ~np:threads ~mem:(Workflow.int (memory * 1024)) ~descr:"rnaspades" [
    mkdir_p tmp ;
    mkdir_p dest ;
    within_container img (
      and_list (
        ln_commands @ [
          cmd "rnaspades.py" ~img [
            opt "--threads" Fn.id np ;
            opt "--memory" Fn.id (seq [ string "$((" ; mem ; string " / 1024))" ]) ;
            option (opt "--ss" strandness) ss ;
            option Fn.id pe_args ;
            opt "-o" Fn.id dest ;
          ]
        ]
      )
    )
  ]

let transcripts x = Workflow.select x ["transcripts.fasta"]
let hard_filtered_transcripts x = Workflow.select x ["hard_filtered_transcripts.fasta"]
let soft_filtered_transcripts x = Workflow.select x ["soft_filtered_transcripts.fasta"]
