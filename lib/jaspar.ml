open Core_kernel
open Bistro

class type jaspar_db = object
  inherit directory
  method contents : [`jaspar_matrix] list
end

let core_vertebrates_non_redundant =
  Bistro_unix.wget
    ~user_agent:{|"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.22 (KHTML, like Gecko) Ubuntu Chromium/25.0.1364.160 Chrome/25.0.1364.160 Safari/537.22"|}
    "http://jaspar.genereg.net/download/CORE/JASPAR2018_CORE_vertebrates_non-redundant_pfms_jaspar.zip"
  |> Bistro_unix.unzip

let%workflow motif_list db =
  let db_dir = [%path db] in
  let motifs =
    Sys.readdir db_dir
    |> Array.to_list
    |> List.filter ~f:(function
        | "." | ".." -> false
        | _ -> true
      )
    |> List.map ~f:(fun fn -> Gzt.Jaspar.of_file (Filename.concat db_dir fn))
    |> Result.all
  in
  match motifs with
  | Ok xs -> xs
  | Error msg -> failwith msg
