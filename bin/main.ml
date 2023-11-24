open Storage

let index request =
  let player_id =
    match Dream.session_field request "id" with
    | Some id -> id |> Player.id_of_string
    | None ->
        let id = Player.gen_id () in
        let _ = Player.insert { id=id } in
        id
  in
  let player = Player.get player_id |> Option.get in
  let models = [
    ("player", Conv.jg_of_player player);
  ] in
  let%lwt _ = 
    Dream.set_session_field 
      request 
      "id" (player_id |> Player.string_of_id) 
  in
  Render.render "index" models

let get_games _ =
  let open Jingoo.Jg_types in
  let games = Game.get_all () in
  let models = [
    ("games", Tlist (List.map Conv.jg_of_game games))
  ] in
  Render.render "partials/games" models

let new_game request = 
  let player_id = 
    match Dream.session_field request "id" with
    | Some id -> id |> Player.id_of_string
    | None -> failwith ("player is not logged in")
  in
  let player = Player.get player_id |> Option.get in
  let game = {
    Game.id = Game.gen_id ();
    black = Some player;
    white = None;
    result = "created";
  }
  in 
  let _ = Game.insert game in
  Dream.redirect request "/games"

let accept_game request =
  let player_id = 
    match Dream.session_field request "id" with
    | Some id -> id |> Player.id_of_string
    | None -> failwith ("player is not logged in")
  in
  let player = Player.get player_id |> Option.get in
  let%lwt game_id =
    match%lwt Dream.form ~csrf:false request with
    | `Ok ["game_id", game_id] -> game_id |> Lwt.return
    | _ -> failwith "unexpected form"
  in
  let game = Game.get (Game.id_of_string game_id) |> Option.get in
  let game' = { game with white = Some player; result = "in progress" } in
  let _ = Game.update game' in
  Dream.redirect request "/games"

let () =
  Dream.router [
    Dream.get "/" index;
    Dream.get "/games" get_games;
    Dream.post "/new-game" new_game;
    Dream.post "/accept-game" accept_game
  ]
  |> Dream.cookie_sessions
  |> Dream.logger
  |> Dream.run ~port: 7300
