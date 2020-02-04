open Bistro
open Biotope

module Data = struct
  type t = [
    | `ES_WT_ChIP_Nanog_Chen2008
    | `ES_WT_ChIP_Pou5f1_Chen2008
    | `ES_WT_ChIP_Sox2_Chen2008
    | `ES_WT_ChIP_Essrb_Chen2008
  ]
  [@@deriving enumerate]

  let string_of_sample = function
    | `ES_WT_ChIP_Nanog_Chen2008 -> "ES_WT_ChIP_Nanog_Chen2008"
    | `ES_WT_ChIP_Pou5f1_Chen2008 -> "ES_WT_ChIP_Pou5f1_Chen2008"
    | `ES_WT_ChIP_Sox2_Chen2008 -> "ES_WT_ChIP_Sox2_Chen2008"
    | `ES_WT_ChIP_Essrb_Chen2008 -> "ES_WT_ChIP_Essrb_Chen2008"

  let base_url = "ftp://ftp.ncbi.nlm.nih.gov/pub/geo/DATA/supplementary/samples/GSM288nnn/"

  let published_peaks_url_suffix = function
    | `ES_WT_ChIP_Nanog_Chen2008 -> "GSM288345/GSM288345_ES_Nanog.txt.gz"
    | `ES_WT_ChIP_Pou5f1_Chen2008 -> "GSM288346/GSM288346_ES_Oct4.txt.gz"
    | `ES_WT_ChIP_Sox2_Chen2008 -> "GSM288347/GSM288347_ES_Sox2.txt.gz"
    | `ES_WT_ChIP_Essrb_Chen2008 -> "GSM288355/GSM288355%5FES%5FEsrrb%2Etxt%2Egz"

  let published_peaks x : text_file pworkflow =
    let url = base_url ^ published_peaks_url_suffix x in
    Bistro_unix.(wget url |> gunzip |> crlf2lf)

  let srr_ids = function
    | `ES_WT_ChIP_Nanog_Chen2008 -> ["SRR002004";"SRR002005";"SRR002006";"SRR002007";"SRR002008";"SRR002009";"SRR002010";"SRR002011"]
    | `ES_WT_ChIP_Pou5f1_Chen2008 -> ["SRR002012";"SRR002013";"SRR002014";"SRR002015"]
    | `ES_WT_ChIP_Sox2_Chen2008 -> ["SRR002023";"SRR002024";"SRR002025";"SRR002026"]
    | `ES_WT_ChIP_Essrb_Chen2008 -> ["SRR001992";"SRR001993";"SRR001994";"SRR001995"]

  let source x = Fastq_dataset.SRA_dataset { srr_ids = srr_ids x ; library_type = `single_end }
end

module Fastq_dataset = Fastq_dataset.Make(Data)
