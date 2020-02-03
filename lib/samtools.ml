open Core_kernel
open Bistro
open Bistro.Shell_dsl

type 'a format = Bam | Sam

let bam = Bam
let sam = Sam


let img = [ docker_image ~account:"pveber" ~name:"samtools" ~tag:"1.3.1" () ]

let samtools subcmd args =
  cmd "samtools" ~img (string subcmd :: args)

let sam_of_bam bam =
  Workflow.shell ~descr:"samtools.sam_of_bam" [
    samtools "view" [
      opt "-o" Fn.id dest ;
      dep bam ;
    ]
  ]

let bam_of_sam sam =
  Workflow.shell ~descr:"samtools.bam_of_sam" [
    samtools "view" [
      string "-S -b" ;
      opt "-o" Fn.id dest ;
      dep sam ;
    ]
  ]

let indexed_bam_of_sam sam =
  Workflow.shell ~descr:"samtools.indexed_bam_of_sam" [
    mkdir_p dest ;
    samtools "view" [
      string "-S -b" ;
      opt "-o" (fun () -> dest // "temp.bam") () ;
      dep sam ;
    ] ;
    samtools "sort" [
      dest // "temp.bam" ;
      opt "-o" Fn.id (dest // "reads.bam") ;
    ] ;
    samtools "index" [ dest // "reads.bam" ] ;
    rm_rf (dest // "temp.bam") ;
  ]

let sort ?on:order bam =
  Workflow.shell ~descr:"samtools.sort" [
    samtools "sort" [
      option (fun o -> flag string "-n" Poly.(o = `name)) order ;
      dep bam ;
      opt "-o" Fn.id dest ;
    ] ;
  ]

let indexed_bam_of_bam bam =
  Workflow.shell ~descr:"samtools.indexed_bam_of_bam" [
    mkdir_p dest ;
    samtools "sort" [
      dep bam ;
      opt "-o" Fn.id (dest // "reads.bam") ;
    ] ;
    samtools "index" [ dest // "reads.bam" ] ;
  ]

let indexed_bam_to_bam x = Workflow.select x ["reads.bam"]

let output_format_expr = function
  | Bam -> string "-b"
  | Sam -> string ""


let view ~output (* ?_1 ?u *) ?h ?_H (* ?c ?_L *) ?q (* ?m ?f ?_F ?_B ?s *) file =
  Workflow.shell ~descr:"samtools.view" [
    cmd "samtools view" ~img [
      output_format_expr output ;
      (* option (flag string "-1") _1 ; *)
      (* option (flag string "-u") u ; *)
      option (flag string "-h") h ;
      option (flag string "-H") _H ;
      (* option (flag string "-c") c ; *)
      (* option (opt "-L" dep) _L ; *)
      option (opt "-q" int) q ;
      (* option (opt "-m" int) m ; *)
      (* option (opt "-f" int) f ; *)
      (* option (opt "-F" int) _F ; *)
      (* option (flag string "-B") _B ; *)
      (* option (opt "-s" float) s ; *)
      dep file ;
      opt "-o" Fn.id dest ;
    ]
  ]

let faidx fa =
  Workflow.shell ~descr:"samtools.faidx" [
    mkdir_p dest ;
    cmd "cp" [ dep fa ; dest // "sequences.fa" ] ;
    samtools "faidx" [ dest // "sequences.fa" ] ;
  ]

let fasta_of_indexed_fasta dir = Workflow.select dir ["sequences.fa"]
