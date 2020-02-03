open Bistro

class type twobit = object
  method format : [`twobit]
  inherit binary_file
end

class type chrom_sizes = object
  inherit tsv
  method header : [`no]
  method f1 : string
  method f2 : int
end

class type bigBed = object
  method format : [`bigBed]
  inherit binary_file
end

class type bedGraph = object
  inherit bed3
  method f4 : float
end

class type wig = object
  method format : [`wig]
  inherit text_file
end

class type bigWig = object
  method format : [`bigWig]
  inherit binary_file
end

type genome = [ `dm3 | `droSim1 | `hg18 | `hg19 | `hg38 | `mm8 | `mm9 | `mm10 | `sacCer2 ]
val string_of_genome : [< genome] -> string
val genome_of_string : string -> genome option

(** {4 Dealing with genome sequences} *)
class type chromosome_sequences = object
  inherit directory
  method contents : [`ucsc_chromosome_sequences]
end

val chromosome_sequence :
  [< genome] ->
  string ->
  fasta pworkflow
val chromosome_sequences : [< genome] -> chromosome_sequences pworkflow
val genome_sequence : [< genome] -> fasta pworkflow
val genome_2bit_sequence : [< genome] -> twobit pworkflow
val twoBitToFa : twobit pworkflow -> #bed4 pworkflow -> fasta pworkflow


(** {4 Chromosome size and clipping} *)
val fetchChromSizes : [< genome] -> chrom_sizes pworkflow
val bedClip : chrom_sizes pworkflow -> (#bed3 as 'a) pworkflow -> 'a pworkflow


(** {4 Conversion between annotation file formats} *)
(* val wig_of_bigWig : bigWig file -> wig file *)
(* val bigWig_of_wig : ?clip:bool -> [< genome] -> wig file -> bigWig file *)
val bedGraphToBigWig : [< genome] -> bedGraph pworkflow -> bigWig pworkflow

val bedToBigBed :
  [< genome] ->
  [ `bed3 of bed3 pworkflow | `bed5 of bed5 pworkflow ] ->
  bigBed pworkflow
(** bedToBigBed utility. Fails when given an empty BED file on
    input. Note that the underlying bedToBigBed expects BED
    files with {i exactly} 3 or 5 columns. *)

val bedToBigBed_failsafe :
  [< genome] ->
  [ `bed3 of bed3 pworkflow | `bed5 of bed5 pworkflow ] ->
  bigBed pworkflow
(** sam  as {! Ucsc_gb.bedToBigBed} but produces an empty file when
    given an empty BED on input. *)


(* val wg_encode_crg_mappability_36  : [`mm9 | `hg18 | `hg19] -> bigWig file *)
(* val wg_encode_crg_mappability_40  : [`mm9 | `hg18 | `hg19] -> bigWig file *)
(* val wg_encode_crg_mappability_50  : [`mm9 | `hg18 | `hg19] -> bigWig file *)
(* val wg_encode_crg_mappability_75  : [`mm9 | `hg18 | `hg19] -> bigWig file *)
(* val wg_encode_crg_mappability_100 : [`mm9 | `hg18 | `hg19] -> bigWig file *)


module Lift_over : sig
  class type chain_file = object
    inherit file
    method format : [`lift_over_chain_file]
  end
  class type ['a] output = object
    inherit directory
    method format : [`ucsc_lift_over of 'a]
  end

  val chain_file :
    org_from:[< genome] ->
    org_to:[< genome] ->
    chain_file pworkflow

  val bed :
    org_from:[< genome] ->
    org_to:[< genome] ->
    (* chain_file pworkflow -> *)
    (#bed3 as 'a) pworkflow ->
    'a output pworkflow

  val mapped : 'a output pworkflow -> 'a pworkflow
  val unmapped : 'a output pworkflow -> 'a pworkflow
end
