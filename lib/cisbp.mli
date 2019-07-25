open Bistro

val fetch_pwm_archive : directory pworkflow

val fetch_tf_information : tsv pworkflow

val annotated_motifs : (Gzt.Cisbp.Motif.t * Gzt.Cisbp.TF_information.item list) list workflow
