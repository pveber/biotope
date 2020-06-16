open Core_kernel
open Bistro
open Bistro.Shell_dsl

let img = [ docker_image ~account:"pveber" ~name:"macs2" ~tag:"2.1.1" () ]

let macs2 subcmd opts =
  cmd "macs2" (string subcmd :: opts)

let pileup ?extsize ?both_direction bam =
  Workflow.shell ~descr:"macs2.pileup" ~img [
    macs2 "pileup" [
      opt "-i" dep bam ;
      opt "-o" Fn.id dest ;
      option (flag string "-B") both_direction ;
      option (opt "--extsize" int) extsize ;
    ]
  ]

type _ format =
  | Sam
  | Bam
  | BamPE

let sam = Sam
let bam = Bam
let bampe = BamPE

let opt_of_format = function
  | Sam -> "SAM"
  | Bam -> "BAM"
  | BamPE -> "BAMPE"

type gsize = [`hs | `mm | `ce | `dm | `gsize of int]

let gsize_expr = function
  | `hs -> string "hs"
  | `mm -> string "mm"
  | `dm -> string "dm"
  | `ce -> string "ce"
  | `gsize n -> int n

let name = "macs2"

type keep_dup = [ `all | `auto | `int of int ]

let keep_dup_expr = function
  | `all -> string "all"
  | `auto -> string "auto"
  | `int n -> int n

let callpeak_gen
    ?broad ?pvalue ?qvalue ?gsize ?call_summits
    ?fix_bimodal ?mfold ?extsize ?nomodel ?bdg ?control ?keep_dup format treatment =
  Workflow.shell ~descr:"macs2.callpeak" ~img [
    macs2 "callpeak" [
      option (flag string "--broad") broad ;
      opt "--outdir" Fn.id dest ;
      opt "--name" string name ;
      opt "--format" (fun x -> x |> opt_of_format |> string) format ;
      option (opt "--pvalue" float) pvalue ;
      option (opt "--qvalue" float) qvalue ;
      option (opt "--gsize" gsize_expr) gsize ;
      option (flag string "--bdg") bdg ;
      option (flag string "--call-summits") call_summits ;
      option (opt "--mfold" (fun (i, j) -> seq ~sep:" " [int i ; int j])) mfold ;
      option (opt "--extsize" int) extsize ;
      option (flag string "--nomodel") nomodel ;
      option (flag string "--fix-bimodal") fix_bimodal ;
      option (opt "--keep-dup" keep_dup_expr) keep_dup ;
      option (opt "--control" (list ~sep:" " dep)) control ;
      opt "--treatment" (list ~sep:" " dep) treatment ;
    ]
  ]

let callpeak
    ?pvalue ?qvalue ?gsize ?call_summits
    ?fix_bimodal ?mfold ?extsize ?nomodel ?bdg ?control ?keep_dup format treatment
  =
  callpeak_gen ~broad:false ?pvalue ?qvalue ?gsize ?call_summits
    ?fix_bimodal ?mfold ?extsize ?nomodel ?bdg ?control ?keep_dup format treatment


class type peaks_xls = object
  inherit bed3
  method f4 : int
  method f5 : int
  method f6 : int
  method f7 : float
  method f8 : float
  method f9 : float
end

let peaks_xls x = Workflow.select x [ name ^ "_peaks.xls" ]

class type narrow_peaks = object
  inherit bed5
  method f6 : string
  method f7 : float
  method f8 : float
  method f9 : float
  method f10 : int
end

let narrow_peaks x =
  Workflow.select x [ name ^ "_peaks.narrowPeak" ]

class type peak_summits = object
  inherit bed4
  method f5 : float
end

let peak_summits x = Workflow.select x [ name ^ "_summits.bed" ]

let callpeak_broad
    ?pvalue ?qvalue ?gsize ?call_summits
    ?fix_bimodal ?mfold ?extsize ?nomodel ?bdg ?control ?keep_dup format treatment
  =
  callpeak_gen ~broad:true ?pvalue ?qvalue ?gsize ?call_summits
    ?fix_bimodal ?mfold ?extsize ?nomodel ?bdg ?control ?keep_dup format treatment

class type broad_peaks = object
  inherit bed5
  method f6 : string
  method f7 : float
  method f8 : float
  method f9 : float
end

let broad_peaks x =
  Workflow.select x [ name ^ "_peaks.broadPeak" ]
