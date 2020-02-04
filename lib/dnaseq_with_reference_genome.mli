open Bistro

type reference_genome =
  | Ucsc_gb of Ucsc_gb.genome
  | Fasta of { name : string ; sequence : fasta pworkflow }

module type Sample = sig
  type t
  val reference_genome : t -> reference_genome
  val all : t list
  val to_string : t -> string
  val fastq_sample : t -> Fastq_sample.t
end

module Make(S : Sample) : sig
  val mapped_reads : S.t -> sam pworkflow
  val mapped_reads_indexed_bam : S.t -> indexed_bam pworkflow
  val mapped_reads_bam : S.t -> bam pworkflow
  val mapped_reads_nodup : S.t -> bam pworkflow
  val mapped_reads_nodup_indexed : S.t -> indexed_bam pworkflow
  val coverage : S.t -> Ucsc_gb.bigWig pworkflow
  val counts :
    no_dups:bool ->
    feature_type:string ->
    attribute_type:string ->
    gff:gff pworkflow ->
    S.t ->
    [`featureCounts] dworkflow
  val fastq_screen :
    possible_contaminants:(string * fasta pworkflow) list ->
    S.t ->
    html pworkflow
  val bamstats : S.t -> text_file pworkflow
  val bamstats' : S.t -> Biocaml_ez.Bamstats.t workflow
  val chrstats : S.t -> text_file pworkflow
  val alignment_summary : html pworkflow
end
