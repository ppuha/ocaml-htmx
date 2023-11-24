type id = Uuidm.t

let gen_id () = Uuidm.v `V4

let id_of_string str = Uuidm.of_string str |> Option.value ~default:Uuidm.nil
let string_of_id id = Uuidm.to_string id

type t = {
  id: id;
}

let string_of_t t = t.id |> Uuidm.to_string

let players = ref []

let get id = 
  List.find_opt (fun p -> Uuidm.equal p.id id) !players

let insert player =
  players := List.concat [!players; [player]];
  Some player