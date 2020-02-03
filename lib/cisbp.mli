open Bistro

val fetch_pwm_archive : directory pworkflow

val fetch_tf_information : tsv pworkflow

type annotated_motif = {
  id : string ;
  tf_name : string ;
  pwm : Gzt.Pwm.t ;
  rc_pwm : Gzt.Pwm.t ;
  threshold : float ;
  infos : Gzt.Cisbp.TF_information.item list ;
}

val annotated_motifs : annotated_motif list workflow
