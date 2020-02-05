open Bistro

module Make(P : sig val np : int val mem : int end)() : sig
  val eval : 'a workflow -> 'a
  val path : _ file -> string
  val file : _ file -> unit
  val ls : _ file -> unit
  val less : #text file -> unit
  val firefox : _ file -> unit
  val evince : pdf file -> unit
  val wc : #text file -> unit
  val rm : _ file -> unit
  val seaview : fasta file -> unit
end
