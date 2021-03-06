open Import;;

type t =
  { etype : Encryption_type.t
  ; kvno : Uint32.t option
  ; cipher : Octet_string.t (* Decrypts to EncTicketPart *)
  }

module Format = struct
  type t = Encryption_type.Format.t * Uint32.Format.t option * Cstruct.t

  let asn =
    Application_tag.tag `Ticket
      (sequence3
         (tag_required 0 ~label:"etype" Encryption_type.Format.asn)
         (tag_optional 1 ~label:"kvno" Uint32.Format.asn)
         (tag_required 2 ~label:"cipher" Octet_string.Format.asn))
end

let format_of_t t =
  ( Encryption_type.format_of_t t.etype
  , Option.map Uint32.format_of_t t.kvno
  , Octet_string.format_of_t t.cipher )
