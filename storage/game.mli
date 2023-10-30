type t = {
  id: Uuidm.t;
  black: Player.t option;
  white: Player.t option;
  result: string;
}

val string_of_t: t -> string

val get: Uuidm.t -> t option
val get_all: unit -> t list
val insert: t -> t option
val update: t -> t option