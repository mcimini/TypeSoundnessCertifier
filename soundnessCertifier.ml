open Batteries
open Option
open Unix
open Aux
open TypedLanguage
open Ldl
open ListLemmas
open LdlToTypedLanguage
open TypeChecker
open TypeCheckerTypedLanguage
open Proof
open Values
open ErrorManagement
open ContextualRules
open ErrorManagement
open CanonicalForms
open Progress
open Preservation 
open LdlToTypedLanguage
open GenerateLambdaProlog
open TypeCheckerPreservation 
open ParserLan
open Parser
open Subtyping

let sep = "\n\n"
let generateThm tsName ldl subtyping = generateThmPreamble tsName 
							^ sep ^ 
							(generateTheoremS (generateSubtypingLemmas ldl subtyping)) 
							^ sep ^ 
							(generateTheoremS (generateCanonicalFormsLemma ldl subtyping)) 
							^ sep ^ 
							(progressDefinition ldl) 
							^ sep ^ 
							(generateTheoremS (generateProgressLemmas ldl subtyping)) 
							^ sep ^ 
							(generateTheorem (generateProgressTheorem ldl subtyping)) 
							^ sep ^
 							(generateTheoremS (generatePreservationTheorem ldl subtyping)) 
							^ sep ^ 
							typesoundnessProof (ldl_containErrors ldl)

let displayPreservationMessage str = 
	let (operator,nested) = (String.split str "_") in 
	if nested = "" then "Reduction rule for " ^ operator ^ "is not type preserving"
	else "Reduction rule of " ^ operator ^ " for handling a value " ^ nested ^ " is not type preserving"
							
let checkResult tlName output = 
	(* let lastline = List.hd output in (* remember that output is in reverse *)  it seems that the error output is: test_r_snd_pair < search.\n Error: Search failed *) 
	(* So we grab the last TWO lines rather than the last time. *) 
	let lastTWOline = List.hd output ^ " \n " ^ List.hd (List.tl output) in  
	if (String.exists lastTWOline "< search." || String.exists lastTWOline "failed" || String.exists lastTWOline "Error") 
		(* if Abella 2.0.2, 2.0.3, and 2.0.4 fail our type preservation check, they quit abruptly after "search.", which is then the last line *)
		(* this check above will be replaced with a better way to interact with Abella *)
		(* then raise(Failure("FAILED Type Preservation. Specification: " ^ tlName ^ ". Rule: " ^ String.tail (fst (String.split lastline "<")) (String.length "test_r_") ^ "\n")) *)
		then raise(Failure("FAILED Type Preservation. Specification: " ^ tlName ^ ": " ^ displayPreservationMessage (fst  (String.split (snd (String.split lastTWOline "test_r_")) " <")))) 
		else ()


let callAbella command =
  let lines = ref [] in
  let in_channel = Unix.open_process_in command in
  begin
    try begin 
	      while true do
          lines := input_line in_channel :: !lines
          done;
	    end;
	(* Based on a suggestion by github user kensand, I leave this catch below general rather than for End_of_file solely *)
    with _ -> ()
  end; 
  Unix.close_process_in in_channel;
  !lines

let runPreservationTests tlName ldl subtyping = 
	(* timeout is 3 seconds, with gtimeout 
	let timeout = "" in 
	let timeout = " gtimeout 3s " in 
	*)
	let timeout = "" in 
	let testingQueriesFile = "test_" ^ tlName ^ ".thm" in 
	let test_thm = open_out ("./generated/" ^ testingQueriesFile) in 
		output_string test_thm ("Specification \"" ^ tlName ^ "\".\n\n");
		List.map (output_string test_thm) (List.map generateAbellaQuery (preservationTestsAsRules ldl subtyping)); 
		close_out test_thm;
		let directory = getcwd () in 
			chdir "generated"; 
			(* let output = callAbella (timeout ^ "abella " ^ testingQueriesFile) in *)
		    ignore (Unix.alarm 3);
		    Sys.set_signal Sys.sigalrm (Sys.Signal_handle (fun _ -> raise(Failure("Timeout")))); 
			let output = ref [] in 
 		   	begin try output := callAbella (timeout ^ "abella " ^ testingQueriesFile) with _ -> () end;
            chdir directory; 
			checkResult tlName !output;
			Sys.remove ("./generated/" ^ testingQueriesFile) ;; 


let tlTable = 
let dir = "repo/" in 
let contents = Array.to_list (Sys.readdir dir) in
(* let contents = List.rev_map (Filename.concat dir) contents in *)
let files =
  List.fold_left (fun (files) f ->
       match (stat (dir ^ f)).st_kind with
	   | S_REG -> if String.ends_with f ".lan" then files @ [dropLastInString f 4] else files (* Regular file *)
   	   | _ -> files)
	   [] contents in 
	   files
(*	 
[
(* CBN Calculi *)
"stlc_cbn" ; 
"stlc_cbv" ; 
"stlc_par" ; 
"stlc_cbv_rightToleft" ; 
"pairs_superlazy" ; 
"pairs_lazy" ; 
"pairs_plain" ; 
"pairs_leftToRight" ; 
"pairs_onlyfstButBoth" ; 
"iff" ;
"lists" ;
"lists_lazy" ;
"lists_lefToright" ;
"listsIsNil";
"listsIsNil_lazy" ;
"listsIsNil_lefToright" ;
"sums" ;
"unitt" ;
"itlc_cbn" ;
"itlc_cbv" ;
"itlc_par" ;
"tuples_plain" ;
"tuples_lazy" ;
"tuples_parallel" ;
"tuples_lefToright" ;
"foralll" ;
"recursive" ;
(* STLC with if and booleans *)
"stlc_cbn_iff" ;
"stlc_cbn_iff_par" ;
"stlc_cbv_iff" ;
"stlc_cbv_iff_par" ;
"stlc_par_iff" ;
"stlc_par_iff_par" ;
(* STLC with pairs lazy, superlazy etcetera *)
"stlc_cbn_pairs_lazy" ;
"stlc_cbn_pairs_superlazy" ;
"stlc_cbn_pairs_plain" ;
"stlc_cbn_pairs_lefToright" ;
"stlc_cbn_pairs_onlyfstButBoth" ;
"stlc_cbn_pairs_onlysnd" ;
"stlc_cbv_pairs_lazy" ;
"stlc_cbv_pairs_superlazy" ;
"stlc_cbv_pairs_plain" ;
"stlc_cbv_pairs_lefToright" ;
"stlc_cbv_pairs_onlyfstButBoth" ;
"stlc_cbv_pairs_onlysnd" ;
"stlc_par_pairs_lazy" ;
"stlc_par_pairs_superlazy" ;
"stlc_par_pairs_plain" ;
"stlc_par_pairs_lefToright" ;
"stlc_par_pairs_onlyfstButBoth" ;
"stlc_par_pairs_onlysnd" ;
(* STLC with lists *)
"stlc_cbn_lists" ;
"stlc_cbn_lists_lazy" ;
"stlc_cbn_lists_lefToright" ;
"stlc_cbv_lists" ;
"stlc_cbv_lists_lazy" ;
"stlc_cbv_lists_lefToright" ;
"stlc_par_lists" ;
"stlc_par_lists_lazy" ;
"stlc_par_lists_lefToright" ;
(* STLC with lists with booleans and isNil *)
"stlc_cbn_listsIsNil" ;
"stlc_cbn_listsIsNil_lazy" ;
"stlc_cbn_listsIsNil_lefToright" ;
"stlc_cbv_listsIsNil" ;
"stlc_cbv_listsIsNil_lazy" ;
"stlc_cbv_listsIsNil_lefToright" ;
"stlc_par_listsIsNil" ;
"stlc_par_listsIsNil_lazy" ;
"stlc_par_listsIsNil_lefToright" ;
(* STLC with fix *)
"stlc_cbn_fix" ;
"stlc_cbv_fix" ;
"stlc_par_fix" ;
(* Implicitly Typed Lambda Calculus with fix *)
"itlc_cbn_fix" ;
"itlc_cbv_fix" ;
"itlc_par_fix" ;
(* STLC with let *)
"stlc_cbn_let" ;
"stlc_cbv_let" ;
"stlc_par_let" ;
(* STLC with letrec with type annotations *)
"stlc_cbn_letrecWithType" ;
"stlc_cbv_letrecWithType" ;
"stlc_par_letrecWithType" ;
(* Implicitly Typed Lambda Calculus with letrec with no type annotations *)
"itlc_cbn_letrec" ;
"itlc_cbv_letrec" ;
"itlc_par_letrec" ;
(* Implicitly Typed Lambda Calculus with letrec with no type annotations *)
"itlc_cbn_letrecFix" ;
"itlc_cbv_letrecFix" ;
"itlc_par_letrecFix" ;
(* STLC with sums *)
"stlc_cbn_sums" ;
"stlc_cbv_sums" ;
"stlc_par_sums" ;
(* STLC with unit *)
"stlc_cbn_unitt" ;
"stlc_cbv_unitt" ;
"stlc_par_unitt" ;
(* STLC with exceptions *)
"stlc_cbn_exc" ;
"stlc_cbv_exc" ;
"stlc_par_exc" ;
(* STLC with tuples lazy, parallel and plain *)
"stlc_cbn_tuples_lazy" ;
"stlc_cbn_tuples_parallel" ;
"stlc_cbn_tuples_plain" ;
"stlc_cbn_tuples_lefToright" ;
"stlc_cbv_tuples_lazy" ;
"stlc_cbv_tuples_parallel" ;
"stlc_cbv_tuples_plain" ;
"stlc_cbv_tuples_lefToright" ;
"stlc_par_tuples_lazy" ;
"stlc_par_tuples_parallel" ;
"stlc_par_tuples_plain" ;
"stlc_par_tuples_lefToright" ;
(* System F *)
"stlc_cbn_forall" ;
"stlc_cbv_forall" ;
"stlc_par_forall" ;
(* STLC with recursive types *)
"stlc_cbn_recursive" ;
"stlc_cbv_recursive" ;
"stlc_par_recursive" ;
(** Some combinations **)
(* STLC with booleans, lists, sums and letrec *)
"lists_withMore_cbv" ;
"lists_withMore_cbn" ;
"lists_withMore_par" ;
"lists_withMore_leftToRight_cbv" ;
"lists_withMore_leftToRight_cbn" ;
"lists_withMore_leftToRight_par" ;
(* STLC with booleans, lists, sums and letrec *)
"sums_and_pairs_cbv" ;
"sums_and_pairs_cbn" ;
"sums_and_pairs_par" ;
(* STLC with booleans, lists, universal types, fix, let, letrec, and exceptions, with and without type annotations *)
"forall_withMore_cbn" ;
"forall_withMore_cbv" ;
"forall_withMore_par" ;
"forall_withMoreWithType_cbn" ;
"forall_withMoreWithType_cbv" ;
"forall_withMoreWithType_par" ;
(* STLC with booleans, lists, recursive types, fix, letrec, and exceptions, with and without type annotations *)
"recursive_withMore_cbn" ;
"recursive_withMore_cbv" ;
"recursive_withMore_par" ;
(* Paper Fpl: STLC cbv with integers, booleans, pairs, sums, lists, universal types, recursive types, fix, letrec, and exceptions *)
"fpl_cbv" ;
(* Subtyping 
   fpl_cbv_sub: is Fpl but without recursive types. *)
"fpl_cbv_sub" ;
"systemFsub" ;
"fpl_cbv_tuple_sub" ;
"systemFsub_kernel" ;
]
*)
	   
let testOne tlName =
	let (tlRaw, subtypingRaw) = parseFile tlName in 
	(try typecheck tlRaw with | Failure errorMessage -> raise(Failure("Typechecker Failure for " ^ tlName ^ ": " ^ errorMessage)));
	let ldl = (try typecheck_tl tlRaw subtypingRaw with | Failure errorMessage -> raise(Failure("Failure for " ^ tlName ^ ": " ^ errorMessage))) in 
	let tl = compile ldl in 	
	let subtyping = subtyping_expand ldl subtypingRaw in 
	let mycalculus_sig = open_out ("./generated/" ^ tlName ^ ".sig") in
	let mycalculus_mod = open_out ("./generated/" ^ tlName ^ ".mod") in
	let mycalculus_thm = open_out ("./generated/" ^ tlName ^ ".thm") in
 	output_string mycalculus_sig (generateSignature tlName tl);
	output_string mycalculus_sig (subtyping_declaration subtyping);
	output_string mycalculus_mod (generateModule tlName tl);	
	output_string mycalculus_mod (generateRules (subtyping_definition ldl subtyping));
	output_string mycalculus_thm (generateThm tlName ldl subtyping); 
    close_out mycalculus_sig;
    close_out mycalculus_mod;
    close_out mycalculus_thm;
	runPreservationTests tlName ldl subtyping; 
	Sys.remove ("./repo/" ^ tlName ^ ".mod"); 
	Sys.remove ("./repo/" ^ tlName ^ ".sig"); 
	let directory = getcwd () in 
		chdir "generated";
		Unix.open_process_in ("abella " ^ (tlName ^ ".thm"));
		chdir directory;;

	
		
(* 
let test2 = List.map testOne tlTable; print_string "All the specifications in input are type sound!\n";
let test = List.map compileToLambdaProlog tlTable; List.map testOne tlTable; print_string "All the specifications in input are type sound!\n"; 
Unix.open_process_in ("abella " ^ (tlName ^ ".thm") ^ " > " ^ (tlName ^ "_output.txt"));
		*)
let compileToLambdaProlog tlName = parseFileLan tlName ;; 

let test = match Array.to_list Sys.argv with 
	| [_] -> List.map compileToLambdaProlog tlTable; List.map testOne tlTable; print_string "All the specifications in input are type sound!\n";
	| _ -> List.map testOne tlTable; print_string "All the specifications in input are type sound!\n";
(*
List.map (fun x -> print_string x; print_string "\n";) tlTable
*)