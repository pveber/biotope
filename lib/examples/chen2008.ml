open Bistro
open Biotope

module Data = struct
  type t = [
    | `ES_WT_ChIP_Nanog_Chen2008_1
    | `ES_WT_ChIP_Nanog_Chen2008_2
    | `ES_WT_ChIP_Nanog_Chen2008_3
    | `ES_WT_ChIP_Nanog_Chen2008_4
    | `ES_WT_ChIP_Nanog_Chen2008_5
    | `ES_WT_ChIP_Nanog_Chen2008_6
    | `ES_WT_ChIP_Nanog_Chen2008_7
    | `ES_WT_ChIP_Nanog_Chen2008_8
    | `ES_WT_ChIP_Pou5f1_Chen2008_1
    | `ES_WT_ChIP_Pou5f1_Chen2008_2
    | `ES_WT_ChIP_Pou5f1_Chen2008_3
    | `ES_WT_ChIP_Pou5f1_Chen2008_4
    | `ES_WT_ChIP_Sox2_Chen2008_1
    | `ES_WT_ChIP_Sox2_Chen2008_2
    | `ES_WT_ChIP_Sox2_Chen2008_3
    | `ES_WT_ChIP_Sox2_Chen2008_4
    | `ES_WT_ChIP_Essrb_Chen2008_1
    | `ES_WT_ChIP_Essrb_Chen2008_2
    | `ES_WT_ChIP_Essrb_Chen2008_3
    | `ES_WT_ChIP_Essrb_Chen2008_4
  ]
  [@@deriving show,enumerate]

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

  let published_peaks x : text file =
    let url = base_url ^ published_peaks_url_suffix x in
    Bistro_unix.(wget url |> gunzip |> crlf2lf)

  let srr_id = function
    | `ES_WT_ChIP_Nanog_Chen2008_1 -> "SRR002004"
    | `ES_WT_ChIP_Nanog_Chen2008_2 -> "SRR002005"
    | `ES_WT_ChIP_Nanog_Chen2008_3 -> "SRR002006"
    | `ES_WT_ChIP_Nanog_Chen2008_4 -> "SRR002007"
    | `ES_WT_ChIP_Nanog_Chen2008_5 -> "SRR002008"
    | `ES_WT_ChIP_Nanog_Chen2008_6 -> "SRR002009"
    | `ES_WT_ChIP_Nanog_Chen2008_7 -> "SRR002010"
    | `ES_WT_ChIP_Nanog_Chen2008_8 -> "SRR002011"
    | `ES_WT_ChIP_Pou5f1_Chen2008_1 -> "SRR002012"
    | `ES_WT_ChIP_Pou5f1_Chen2008_2 -> "SRR002013"
    | `ES_WT_ChIP_Pou5f1_Chen2008_3 -> "SRR002014"
    | `ES_WT_ChIP_Pou5f1_Chen2008_4 -> "SRR002015"
    | `ES_WT_ChIP_Sox2_Chen2008_1 -> "SRR002023"
    | `ES_WT_ChIP_Sox2_Chen2008_2 -> "SRR002024"
    | `ES_WT_ChIP_Sox2_Chen2008_3 -> "SRR002025"
    | `ES_WT_ChIP_Sox2_Chen2008_4 -> "SRR002026"
    | `ES_WT_ChIP_Essrb_Chen2008_1 -> "SRR001992"
    | `ES_WT_ChIP_Essrb_Chen2008_2 -> "SRR001993"
    | `ES_WT_ChIP_Essrb_Chen2008_3 -> "SRR001994"
    | `ES_WT_ChIP_Essrb_Chen2008_4 -> "SRR001995"

  let source x = Fastq_sample.SRA_dataset { srr_id = srr_id x ; library_type = `single_end }

  let to_string x = show x

  let reference_genome _ = Dnaseq_with_reference_genome.Ucsc_gb `mm10
end

module Fastq_dataset = Fastq_sample.Make(Data)
module Dnaseq = Dnaseq_with_reference_genome.Make(struct
    include Data
    include Fastq_dataset
  end)
