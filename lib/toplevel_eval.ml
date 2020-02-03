open Core_kernel

module Make(P : sig
    val np : int
    val mem : int
  end)() =
struct
  include Bistro_utils.Toplevel_eval.Make(P)()

  let seaview w =
    (Sys.command (sprintf "seaview %s" (path w)) : int)
    |> ignore
end
