open Core_kernel
open Bistro

let fetch_pwm_archive : directory pworkflow =
  Bistro_unix.wget Gzt.Cisbp.pwm_archive_url
  |> Bistro_unix.unzip
  |> Fn.flip Workflow.select ["pwms"]

let fetch_tf_information : tsv pworkflow =
  Bistro_unix.wget Gzt.Cisbp.tf_information_archive_url
  |> Bistro_unix.unzip
  |> Fn.flip Workflow.select ["TF_Information_all_motifs.txt"]

let%workflow annotated_motifs =
  let motifs =
    Gzt.Cisbp.Motif.read_all_in_dir [%path fetch_pwm_archive]
  in
  let motif_info =
    Gzt.Cisbp.TF_information.from_file [%path fetch_tf_information]
    |> List.filter_map ~f:(fun mi ->
        Option.map mi.motif_id ~f:(fun id -> id, mi)
      )
    |> String.Map.of_alist_multi
  in
  List.map motifs ~f:(fun (label, motif) ->
      let id = Filename.chop_extension label in
      motif, Option.value ~default:[] (String.Map.find motif_info id)
    )
