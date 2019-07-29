open Bistro
open Bistro_bioinfo

val eval : 'a workflow -> 'a
val path : _ pworkflow -> string

val evince : pdf pworkflow -> unit
val file : _ pworkflow -> unit
val firefox : _ pworkflow -> unit
val ls : _ pworkflow -> unit
val less : #text_file pworkflow -> unit
val rm : _ pworkflow -> unit
val seaview : fasta pworkflow -> unit
val wc : #text_file pworkflow -> unit
