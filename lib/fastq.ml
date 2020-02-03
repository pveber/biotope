open Core_kernel
open Bistro
open Bistro.Shell_dsl

type format =
  | Sanger
  | Solexa
  | Phred64

let concat = function
  | [] -> raise (Invalid_argument "fastq concat: empty list")
  | x :: [] -> x
  | fqs ->
    Workflow.shell ~descr:"fastq.concat" [
      cmd "cat" ~stdout:dest [ list dep ~sep:" " fqs ]
    ]

let head n fq =
  Workflow.shell ~descr:"fastq.head" [
    cmd "head" ~stdout:dest [
      opt "-n" int (n * 4) ;
      dep fq ;
    ]
  ]
