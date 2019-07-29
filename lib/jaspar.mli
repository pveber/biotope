open Bistro

class type jaspar_db = object
  inherit directory
  method contents : [`jaspar_matrix] list
end

val core_vertebrates_non_redundant : jaspar_db pworkflow

val motif_list : jaspar_db pworkflow -> Gzt.Jaspar.matrix list workflow
