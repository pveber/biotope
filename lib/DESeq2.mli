open Bistro

val img : Shell_dsl.container_image list

class type table = object
  inherit tsv
  method header : [`yes]
end

type output =
  <
    comparison_summary : table pworkflow ;
    comparisons : ((string * string * string) * table pworkflow) list ;
    effect_table : table pworkflow ;
    normalized_counts : table pworkflow ;
    sample_clustering : svg pworkflow ;
    sample_pca : svg pworkflow ;
    directory : directory pworkflow
  >

val main_effects :
  string list ->
  (string list * #Htseq.count_tsv pworkflow) list ->
  output
