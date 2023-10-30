type t = {
  id: Uuidm.t
}

val string_of_t: t -> string

val get: Uuidm.t -> t option
val insert: t -> t option