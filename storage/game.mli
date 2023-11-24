type id

val gen_id: unit -> id
val id_of_string: string -> id
val string_of_id: id -> string

type t = {
  id: id;
  black: Player.t option;
  white: Player.t option;
  result: string;
}

val string_of_t: t -> string

val get: id -> t option
val get_all: unit -> t list
val insert: t -> t option
val update: t -> t option