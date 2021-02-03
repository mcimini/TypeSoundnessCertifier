open Batteries
open Unix
open Lexing

let get_positions lexbuf = let pos = lexbuf.lex_curr_p in pos.pos_fname ^ ":" ^ string_of_int pos.pos_lnum  ^ ":" ^ string_of_int (pos.pos_cnum - pos.pos_bol + 1)

let parseWithMenhir fileName = 
	let fileNameLAN = fileName ^ ".lan" in 
	let input = (open_in ("repo/" ^ fileNameLAN)) in 
 	let filebuf = Lexing.from_input input in 
	let language = try ParserWithErrors.file Lexer.token filebuf with 
		| Lexer.Error msg -> raise(Failure("Lexer error in " ^ fileNameLAN ^ ": " ^ get_positions filebuf ^ " with message: " ^ msg))
		| ParserWithErrors.Error -> raise(Failure("Parser error in " ^ fileNameLAN ^ ": " ^ get_positions filebuf)) in 
	 IO.close_in input; 

(* to execute: ./test stlc_cbv.lan *)