open Core_kernel
open Bistro
open Bistro_engine

let np = ref 4
let mem = ref 4

let with_workflow w ~f =
  let open Scheduler in
  let db = Db.init_exn "_bistro" in
  let loggers = [ Bistro_utils.Console_logger.create () ] in
  let sched = create ~np:!np ~mem:(`GB !mem) ~loggers db in
  let thread = eval_exn sched w in
  start sched ;
  try
    Lwt_main.run thread
    |> f
  with Failure msg as e -> print_endline msg ; raise e

let with_pworkflow w ~f = with_workflow (Workflow.eval_path w) ~f

let eval w =
  with_workflow w ~f:Fn.id

let path w =
  with_pworkflow w ~f:Fn.id

let sh fmt =
  Printf.ksprintf (fun s -> ignore (Sys.command s)) fmt

let evince w =
  with_pworkflow w ~f:(sh "evince %s")

let file (w : _ pworkflow) =
  with_pworkflow w ~f:(sh "file %s")

let firefox w =
  with_pworkflow w ~f:(sh "firefox --no-remote %s")

let less w =
  with_pworkflow w ~f:(sh "less %s")

let ls w =
  with_pworkflow w ~f:(sh "ls %s")

let rm w =
  with_pworkflow w ~f:(sh "rm %s")

let seaview w =
  Sys.command (sprintf "seaview %s" (path w))
  |> ignore

let wc (w : #text_file pworkflow) =
  with_pworkflow w ~f:(sh "wc %s")
