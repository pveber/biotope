open Core_kernel
open Bistro
open Biotope

module type Toplevel = sig
  val eval : 'a workflow -> 'a
end

let toplevel_np = ref 1
let toplevel_mem = ref 1

let toplevel : (module Toplevel) option ref = ref None

let init_module () =
  let module E = Bistro_utils.Toplevel_eval.Make(struct
                     let np = !toplevel_np
                     let mem = !toplevel_mem
                   end)()
  in
  toplevel := Some (module E : Toplevel) ;
  (module E : Toplevel)

let configure ?np ?mem () =
  Option.iter np ~f:(( := ) toplevel_np) ;
  Option.iter mem ~f:(( := ) toplevel_mem) ;
  ignore (init_module () : (module Toplevel))

let eval w =
  let (module E) =
    match !toplevel with
    | None -> init_module ()
    | Some m -> m
  in
  E.eval w

let unsafe_file_of_url url : 'a file =
  if    String.is_prefix ~prefix:"http://" url
     || String.is_prefix ~prefix:"ftp://" url
  then Bistro_unix.wget url
  else Workflow.input url

module Text = struct
  type t = string workflow

  let eval = eval
end

module File = struct
  type t = regular_file_t file
  let input x = unsafe_file_of_url x

  module Summary = struct
    type t = {
      size : int ;
    }
    let make fn =
      let size = (Unix.stat fn).st_size in
      { size }
    let to_string s =
      sprintf "Size: %d" s.size
  end

  let summary file = [%workflow
    Summary.make [%path file]
    |> Summary.to_string
  ]
end

module Svg = struct
  type t = svg file
end

module Html = struct
  type elt =
    | H1 of string
    | Text of string
    | Svg of svg file

  type t =
    | Workflow of html file
    | Elements of string * elt list

  let make ~title xs = Elements (title, xs)

  let h1 s = H1 s
  let text s = Text s
  let svg x = Svg x

  let render = function
    | Workflow w -> w
    | Elements (title, elts) ->
      let open Bistro_utils.Html_report in
      List.map elts ~f:(function
          | H1 s -> section s
          | Text s -> text s
          | Svg x -> svg x
        )
      |> make ~title
      |> render
end

module Markdown = struct
  type t =
    | Item_list of item list
  and item =
    | H1 of string
    | Text of string

  let make xs = Item_list xs

  let h1 x = H1 x
  let text x = Text x
end

module Fastq = struct
  type t =
    | Plain  of fastq file SE_or_PE.t
    | Gziped of fastq gz file SE_or_PE.t

  let se_or_pe_input x =
    SE_or_PE.map x ~f:unsafe_file_of_url

  let input gziped path =
    if gziped then Gziped (se_or_pe_input path)
    else Plain (se_or_pe_input path)

  let single_end_input ~gziped fq =
    SE_or_PE.Single_end fq
    |> input gziped

  let paired_end_input ~gziped ~r1 ~r2 =
    SE_or_PE.Paired_end (r1, r2)
    |> input gziped

  (* FIXME: move this into biotope *)
  let%workflow fastq_stats fq =
    Biotk.Fastq.Stats.of_file [%path fq]
    |> ok_exn

  let workflow_se_or_pe =
    let open Workflow in
    let open SE_or_PE in
    function
    | Single_end x ->
      app (fun%workflow x -> Single_end x) x
    | Paired_end (x, y) ->
      app
        (fun%workflow (x, y) -> Paired_end (x, y))
        (both x y)

  let summary x =
    let summaries = match x with
      | Plain se_or_pe ->
        SE_or_PE.map se_or_pe ~f:fastq_stats
        |> workflow_se_or_pe
      | Gziped se_or_pe ->
        SE_or_PE.map se_or_pe ~f:(fun fq_gz ->
            (fastq_stats (Bistro_unix.gunzip fq_gz))
          )
        |> workflow_se_or_pe
    in
    [%workflow
      match ([%eval summaries] : Biotk.Fastq.Stats.t SE_or_PE.t) with
      | Single_end stats ->
        sprintf "Single-end; number_of_reads: %d" stats.nb_reads
      | Paired_end (r1, r2) ->
        sprintf "Paired-end; %s" (
          if r1.nb_reads = r2.nb_reads then
            sprintf "number_of_reads: %d" r1.nb_reads
          else
            sprintf "number_of_reads differ in R1 and R2: %d, %d" r1.nb_reads r2.nb_reads
        )]

end

module Sra_toolkit = struct
  let fastq_dump ~id ~paired =
    if paired then
      let r1, r2 = Sra_toolkit.(fastq_dump_pe fastq_gz) (`id id) in
      Fastq.Gziped (SE_or_PE.Paired_end (r1, r2))
    else
      Fastq.Gziped (SE_or_PE.Single_end (Sra_toolkit.(fastq_dump fastq_gz) (`id id)))
end

module FastQC = struct
  type t = FastQC.report SE_or_PE.t
  let fastqc (x : Fastq.t) =
    match x with
    | Plain x -> SE_or_PE.map x ~f:FastQC.fastqc
    | Gziped x ->
      SE_or_PE.map x ~f:(fun x -> FastQC.fastqc (Bistro_unix.gunzip x))
  let html_report (x : t) = match x with
    | Single_end d ->
      Html.Workflow (FastQC.html_report d), None
    | Paired_end (r1, r2) ->
      Html.Workflow (FastQC.html_report r1),
      Some (Html.Workflow (FastQC.html_report r2))
end

let np = ref 1
let mem = ref 1

let set_np i = np := i
let set_mem m = mem := m

let eval w =
  let module E = Bistro_utils.Toplevel_eval.Make(struct
      let np = !np
      let mem = !mem
    end)()
  in
  E.eval w

let firefox w =
  let module E = Bistro_utils.Toplevel_eval.Make(struct
      let np = !np
      let mem = !mem
    end)()
  in
  E.firefox w

let eval_text = eval
let browse_html x = firefox (Html.render x)
