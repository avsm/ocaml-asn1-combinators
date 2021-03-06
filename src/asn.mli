
(* XXX BOILERPLATE *)

module OID : sig
  type t
  val (<|)      : t -> int -> t
  val (<||)     : t -> int list -> t
  val base      : int -> int -> t
  val to_list   : t -> int list
  val to_string : t -> string
  val of_string : string -> t
end

type oid = OID.t

module Time : sig
  type t = {
    date : (int * int * int) ;
    time : (int * int * int * float) ;
    tz   : (int * int * [ `W | `E ]) option ;
  }
end

type time = Time.t


(* /XXX *)

exception Parse_error of string
exception End_of_input
exception Ambiguous_grammar

val parse_error : string -> 'a

type 'a t
type 'a sequence
type 'a element

type tag_class = [ `Universal | `Application | `Private ]

val fix : ('a t -> 'a t) -> 'a t

val map : ('a -> 'b) -> ('b -> 'a) -> 'a t -> 'b t

val implicit : ?cls:tag_class -> int -> 'a t -> 'a t
val explicit : ?cls:tag_class -> int -> 'a t -> 'a t

val single : 'a element -> 'a sequence
val (  @ ) : 'a element -> 'b sequence -> ('a * 'b) sequence
val ( -@ ) : 'a element -> 'b element  -> ('a * 'b) sequence

val optional : ?label:string -> 'a t -> 'a option element
val required : ?label:string -> 'a t -> 'a element

val sequence : 'a sequence -> 'a t
val sequence2 : 'a element -> 'b element -> ('a * 'b) t
val sequence3 :
  'a element ->
  'b element -> 'c element -> ('a * 'b * 'c) t
val sequence4 :
  'a element ->
  'b element ->
  'c element -> 'd element -> ('a * 'b * 'c * 'd) t
val sequence5 :
  'a element ->
  'b element ->
  'c element ->
  'd element -> 'e element -> ('a * 'b * 'c * 'd * 'e) t
val sequence6 :
  'a element ->
  'b element ->
  'c element ->
  'd element ->
  'e element ->
  'f element -> ('a * 'b * 'c * 'd * 'e * 'f) t

val sequence_of : 'a t -> 'a list t

val set : 'a sequence -> 'a t
val set2 : 'a element -> 'b element -> ('a * 'b) t
val set3 :
  'a element ->
  'b element -> 'c element -> ('a * 'b * 'c) t
val set4 :
  'a element ->
  'b element ->
  'c element -> 'd element -> ('a * 'b * 'c * 'd) t
val set5 :
  'a element ->
  'b element ->
  'c element ->
  'd element -> 'e element -> ('a * 'b * 'c * 'd * 'e) t
val set6 :
  'a element ->
  'b element ->
  'c element ->
  'd element ->
  'e element ->
  'f element -> ('a * 'b * 'c * 'd * 'e * 'f) t

val set_of : 'a t -> 'a list t

val choice2 :
  'a t -> 'b t -> [ `C1 of 'a | `C2 of 'b ] t
val choice3 :
  'a t -> 'b t -> 'c t
  -> [ `C1 of 'a | `C2 of 'b | `C3 of 'c ] t
val choice4 :
  'a t -> 'b t -> 'c t -> 'd t
  -> [ `C1 of 'a | `C2 of 'b | `C3 of 'c | `C4 of 'd ] t
val choice5 :
  'a t -> 'b t -> 'c t -> 'd t -> 'e t
  -> [ `C1 of 'a | `C2 of 'b | `C3 of 'c | `C4 of 'd | `C5 of 'e ] t
val choice6 :
  'a t -> 'b t -> 'c t -> 'd t -> 'e t -> 'f t
  -> [ `C1 of 'a | `C2 of 'b | `C3 of 'c | `C4 of 'd | `C5 of 'e | `C6 of 'f ] t


val bool             : bool       t
val integer          : Num.num    t
val bit_string       : bool array t
val bit_string'      : Cstruct.t  t
val octet_string     : Cstruct.t  t
val null             : unit       t
val oid              : oid        t
val utc_time         : time       t
val generalized_time : time       t

val utf8_string      : string t
val numeric_string   : string t
val printable_string : string t
val teletex_string   : string t
val videotex_string  : string t
val ia5_string       : string t
val graphic_string   : string t
val visible_string   : string t
val general_string   : string t
val universal_string : string t
val bmp_string       : string t

val flags       : (int * 'a) list -> 'a list t
val big_natural : string t
val int         : int    t

type encoding
val ber : encoding
val der : encoding

type 'a codec

val codec       : encoding -> 'a t -> 'a codec
val encode      : 'a codec -> 'a -> Cstruct.t
val encode_into : 'a codec -> 'a -> (int * (Cstruct.t -> unit))
val decode_exn  : 'a codec -> Cstruct.t -> 'a * Cstruct.t
val decode      : 'a codec -> Cstruct.t -> ('a * Cstruct.t) option

val random : 'a t -> 'a

