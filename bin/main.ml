open Storage
open Jingoo

let base_dir = "/users/peterpuha/code/ml/ml-htmx/ml_htmx"

let get_games request =
  let open Jg_types in
  let player_id =
    match Dream.session_field request "id" with
    | Some id -> id |> Uuidm.of_string |> Option.value ~default:Uuidm.nil
    | None ->
        let id = Uuidm.v `V4 in
        let _ = Player.insert { id=id } in
        id
  in
  let player = Player.get player_id |> Option.get in
  let games = Game.get_all () in
  let tmpl = 
    Jg_template.from_file
      (base_dir ^ "/templates/index.html")
      ~models: [
        ("player", Conv.jg_of_player player);
        ("games", Tlist (List.map Conv.jg_of_game games))
      ]
  in
  let%lwt _ = Dream.set_session_field request "id" (player_id |> Uuidm.to_string) in
  tmpl |> Dream.html

let new_game request = 
  let player_id = 
    match Dream.session_field request "id" with
    | Some id -> id |> Uuidm.of_string |> Option.value ~default:Uuidm.nil
    | None -> failwith ("player is not logged in")
  in
  let player = Player.get player_id |> Option.get in
  let game = {
    Game.id = Uuidm.v `V4;
    black = Some player;
    white = None;
    result = "created";
  }
  in 
  let _ = Game.insert game in
  let games = Game.get_all () in
  let tmpl = 
    Jg_template.from_file
      (base_dir ^ "/templates/partials/games.html")
      ~models: [
        ("games", Tlist (List.map Conv.jg_of_game games))
      ]
  in
  tmpl |> Dream.html

let accept_game request =
  let player_id = 
    match Dream.session_field request "id" with
    | Some id -> id |> Uuidm.of_string |> Option.value ~default:Uuidm.nil
    | None -> failwith ("player is not logged in")
  in
  let player = Player.get player_id |> Option.get in
  let%lwt game_id =
    match%lwt Dream.form ~csrf:false request with
    | `Ok ["game_id", game_id] -> game_id |> Lwt.return
    | _ -> failwith "unexpected form"
  in
  let game = Game.get (Uuidm.of_string game_id |> Option.get) |> Option.get in
  let game' = { game with white = Some player; result = "in progress" } in
  let _ = Game.update game' in
  let games = Game.get_all () in
  let tmpl = 
    Jg_template.from_file
      (base_dir ^ "/templates/partials/games.html")
      ~models: [
        ("games", Tlist (List.map Conv.jg_of_game games))
      ]
  in
  tmpl |> Dream.html


let () =
  Dream.router [
    Dream.get "/" get_games;
    Dream.post "/new-game" new_game;
    Dream.post "/accept-game" accept_game
  ]
  |> Dream.cookie_sessions
  |> Dream.logger
  |> Dream.run ~port: 7300
