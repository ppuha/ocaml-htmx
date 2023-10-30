type t = {
  id: Uuidm.t;
  black: Player.t option;
  white: Player.t option;
  result: string;
}

let string_of_t game =
  Printf.sprintf "%s: %s - %s: %s"
  (game.id |> Uuidm.to_string)
  (game.black |> Option.map Player.string_of_t |> Option.value ~default:"")
  (game.white |> Option.map Player.string_of_t |> Option.value ~default:"")
  game.result

let games = ref []

let get id = 
  List.find_opt (fun (i, _) -> Uuidm.equal i id) !games
  |> Option.map snd

let get_all () = !games |> List.map snd

let insert game = 
  games := List.concat [!games; [(game.id, game)]];
  Some game

let update game =
  games :=
    (game.id, game) ::
    List.filter (fun (id, _) -> not (Uuidm.equal id game.id)) !games;
  Some game