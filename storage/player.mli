type id

val gen_id: unit -> id
val id_of_string: string -> id
val string_of_id: id -> string

type t = {
  id: id
}

val string_of_t: t -> string

val get: id -> t option
val insert: t -> t option