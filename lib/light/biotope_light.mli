val configure :
  ?np:int ->
  ?mem:int ->
  unit ->
  unit

module Text : sig
  type t
  val eval : t -> string
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

module Fasta : sig
  type t
  val input : ?gziped:bool -> string -> t
  val concat : t list -> t
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

module Ensembl : sig
  type species
  val mus_musculus : species

  val dna :
    release:int ->
    species:species ->
    Fasta.t
end

module Sra_toolkit : sig
  val fastq_dump : id:string -> paired:bool -> Fastq.t
end

module FastQC : sig
  type t
  val fastqc : Fastq.t -> t
  val html_report : t -> Html.t * Html.t option
end

module Kallisto : sig
  type index
  type abundance_table

  val index : Fasta.t -> index
  val quant :
    ?bias:bool ->
    ?bootstrap_samples:int ->
    ?fr_stranded:bool ->
    ?rf_stranded:bool ->
    ?threads:int ->
    ?fragment_length:float ->
    ?sd:float ->
    index ->
    Fastq.t ->
    abundance_table
end
