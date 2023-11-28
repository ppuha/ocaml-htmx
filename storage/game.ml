type id = Uuidm.t

let gen_id () = Uuidm.v `V4
let id_of_string str = Uuidm.of_string str |> Option.value ~default:Uuidm.nil
let string_of_id id = Uuidm.to_string id

type t = {
  id: id;
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

let sort_games () = 
  games := 
    !games
    |> List.sort 
      (fun (id0, _) (id1, _) -> 
        Uuidm.compare id0 id1) 

let get id = 
  List.find_opt (fun (i, _) -> Uuidm.equal i id) !games
  |> Option.map snd

let get_all () = !games |> List.map snd

let insert game = 
  games := List.concat [!games; [(game.id, game)]];
  sort_games ();
  Some game

let update game =
  games :=
    (game.id, game) ::
    List.filter (fun (id, _) -> not (Uuidm.equal id game.id)) !games;
  sort_games ();
  Some game