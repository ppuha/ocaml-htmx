type t = {
  id: Uuidm.t
}

let string_of_t t = t.id |> Uuidm.to_string

let players = ref []

let get id = 
  List.find_opt (fun p -> Uuidm.equal p.id id) !players

let insert player =
  players := List.concat [!players; [player]];
  Some player