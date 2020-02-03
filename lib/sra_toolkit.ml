open Core_kernel
open Bistro
open Bistro.Shell_dsl

let img = [ docker_image ~account:"pveber" ~name:"sra-toolkit" ~tag:"2.8.0" () ]

let sra_of_input = function
  | `id id -> string id
  | `idw w -> string_dep w
  | `file w -> dep w

let fastq_dump sra =
  Workflow.shell ~descr:"sratoolkit.fastq_dump" [
    cmd ~img "fastq-dump" [ string "-Z" ; sra_of_input sra ] ~stdout:dest
  ]

let fastq_dump_gz input =
  let sra = sra_of_input input in
  Workflow.shell ~descr:"sratoolkit.fastq_dump" [
    cmd ~img "fastq-dump" [ string "--gzip" ; string "-Z" ; sra ] ~stdout:dest
  ]

let fastq_dump_pe sra =
  let dir =
    Workflow.shell ~descr:"sratoolkit.fastq_dump" [
      mkdir_p dest ;
      cmd ~img "fastq-dump" [
        opt "-O" Fn.id dest ;
        string "--split-files" ;
        dep sra
      ] ;
      mv (dest // "*_1.fastq") (dest // "reads_1.fastq") ;
      mv (dest // "*_2.fastq") (dest // "reads_2.fastq") ;
    ]
  in
  Workflow.select dir ["reads_1.fastq"],
  Workflow.select dir ["reads_2.fastq"]


let fastq_dump_pe_gz input =
  let sra = sra_of_input input in
  let dir =
    Workflow.shell ~descr:"sratoolkit.fastq_dump" [
      mkdir_p dest ;
      cmd ~img "fastq-dump" [
        opt "-O" Fn.id dest ;
        string "--split-files" ;
        string "--gzip" ;
        sra ;
      ] ;
      mv (dest // "*_1.fastq*") (dest // "reads_1.fq.gz") ;
      mv (dest // "*_2.fastq*") (dest // "reads_2.fq.gz") ;
    ]
  in
  Workflow.select dir ["reads_1.fq.gz"],
  Workflow.select dir ["reads_2.fq.gz"]

let fastq_dump_to_fasta sra =
  Workflow.shell ~descr:"sratoolkit.fastq_dump" [
    cmd ~img "fastq-dump" [
      string "-Z" ;
      string "--fasta" ;
      dep sra
    ] ~stdout:dest
  ]
