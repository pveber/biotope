open Core_kernel
open Bistro
open Bistro.Shell_dsl

let img = [ docker_image ~account:"pegi3s" ~name:"sratoolkit" ~tag:"2.10.0" () ]

type 'a output =
  | Fasta
  | Fastq
  | Fastq_gz

type library_type = SE | PE

let fasta = Fasta
let fastq = Fastq
let fastq_gz = Fastq_gz

let sra_of_input = function
  | `id id -> string id
  | `idw w -> string_dep w
  | `file w -> dep w

(*let q s = quote ~using:'\"' (string s)*)

let protect s = quote ~using:'\"' (string (Str.global_replace (Str.regexp_string "$") "\\$" s))

let call ?minReadLen ?defline_seq ?defline_qual ?_N_ ?_X_ se_or_pe output input =
  let stdout = match se_or_pe with
    | SE -> Some dest
    | PE -> None
  in
  let _O_ = match se_or_pe with
    | SE -> None
    | PE -> Some dest
  in
  cmd "fastq-dump" ?stdout [
    option (opt "-M" int) minReadLen ;
    option (opt "--defline-seq" protect) defline_seq ;
    option (opt "--defline-qual" protect) defline_qual ;
    option (opt "-N" int) _N_ ;
    option (opt "-X" int) _X_ ;
    option (opt "-O" Fn.id) _O_ ;
    option string (
      match se_or_pe with
      | SE -> Some "-Z"
      | PE -> None
    ) ;
    option string (
      match output with
      | Fasta -> Some "--fasta"
      | Fastq | Fastq_gz -> None
    ) ;
    option string (
      match se_or_pe with
      | SE -> None
      | PE -> Some "--split-files"
    ) ;
    option string (
      match output with
      | Fastq_gz -> Some "--gzip"
      | Fasta | Fastq -> None
    ) ;
    sra_of_input input ;
  ]

let fastq_dump ?minReadLen ?_N_ ?_X_ ?defline_qual ?defline_seq output input =
  let fastq_dump_call = call ?minReadLen ?_N_ ?_X_ ?defline_seq ?defline_qual in
  let descr = "sratoolkit.fastq_dump" in
  Workflow.shell ~descr ~img [ fastq_dump_call SE output input ]

let ext_output = function
  | Fasta -> "fasta"
  | Fastq -> "fastq"
  | Fastq_gz -> "fastq.gz"

let fastq_dump_pe ?minReadLen ?_N_ ?_X_ ?defline_qual ?defline_seq output input =
  let fastq_dump_call = call ?minReadLen ?_N_ ?_X_ ?defline_seq ?defline_qual in
  let ext = ext_output output in
  let descr = "sratoolkit.fastq_dump" in
  let dir =
    Workflow.shell ~descr ~img [
      mkdir_p dest ;
      fastq_dump_call PE output input ;
      mv (dest // ("*_1."^ext)) (dest // ("reads_1."^ext)) ;
      mv (dest // ("*_2."^ext)) (dest // ("reads_2."^ext)) ;
    ]
  in
  Workflow.select dir ["reads_1."^ext],
  Workflow.select dir ["reads_2."^ext]
