open Jingoo.Jg_types
open Storage

let jg_of_player player =
  let open Player in
  Tstr (player.id |> Uuidm.to_string)

let jg_of_game game =
  let open Game in
  Tobj [
    ("id", Tstr (game.id |> Uuidm.to_string));
    ("black", Tstr (game.black |> Option.map Player.string_of_t |> Option.value ~default:""));
    ("white", Tstr (game.white |> Option.map Player.string_of_t |> Option.value ~default:""));
    ("result", Tstr game.result)
  ]