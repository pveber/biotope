module Text : sig
  type t
end

module File : sig
  type t
  val input : string -> t
  val summary : t -> Text.t
end

module Svg : sig
  type t
end

module Html : sig
  type t
  type elt
  val make :
    title:string ->
    elt list ->
    t
  val h1 : string -> elt
  val text : string -> elt
  val svg : Svg.t -> elt
end

module Markdown : sig
  type t
  type item
  val make : item list -> t
  val h1 : string -> item
  val text : string -> item
  (* val render : t -> Html.t *)
end

module Fastq : sig
  type t
  val single_end_input :
    gziped:bool ->
    string ->
    t
  val paired_end_input :
    gziped:bool ->
    r1:string ->
    r2:string ->
    t
  val summary : t -> Text.t
end

module Sra_toolkit : sig
  val fastq_dump : id:string -> paired:bool -> Fastq.t
end

module FastQC : sig
  type t
  val fastqc : Fastq.t -> t
  val html_report : t -> Html.t * Html.t option
end

val set_np : int -> unit
val set_mem : int -> unit

val eval_text : Text.t -> string
val browse_html : Html.t -> unit
