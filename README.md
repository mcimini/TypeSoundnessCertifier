# TypeSoundnessCertifier

Author: Matteo Cimini (matteo_cimini@uml.edu)
	<br />
Tool tested with Abella versions 2.0.2 included to 2.0.5 included.

Quick links 
<ul>
<li> <a href="#instructions">Instructions</a>
<li> <a href="#examples">Examples of error messages provided by the tool</a>
</ul>

<br /> 

TypeSoundnessCertifier comprises two components:
<ul>
<li> Lang-n-Check: Takes in input a language definition and type checks it to see whether it is type sound. 
<li> A proof generator: Takes in input a language definition that has been type checked by Lang-n-Check, and generates a machine checked proof of type soundness in the Abella proof assistant. 
	<br /> The proof generator is based on manual algorithms that later have been declaratively expressed in another tool called <a href="https://github.com/mcimini/lang-n-prove">Lang-n-Prove</a>. 
	<br /> In the future, we plan to replace the proof generator, and directly integrate Lang-n-Prove. 
</ul>


### Update (December 2017): <br />
As of July 2017 (a POPL 2018 submission), 
<br />
<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**_TypeSoundnessCertifier automatically solves the POPLMark Challenge 2A!!_**
<br /><br />(i.e. the tool automatically generates the full mechanized type soundness proof for System F with bounded subtyping, from its language definition.) 
<br />See below for the reference to this example.   
<br />

# <a name="instructions"></a>Instructions 
<br />

Requirements: 
<br />
<ul>
<li> To compile, Ocaml is required.
<br />
	 To install: install OPAM, at https://opam.ocaml.org (Instructions are at that website)
<li> Ocaml Batteries package is required. 
<br />
	 To install: "opam install batteries"
<li> To run:  the <a href="http://abella-prover.org">Abella proofs assistant</a> must be installed and the command "abella" must be in the $PATH 
<br />
	 To install: "opam install abella" 
<br />
	 Tool tested with Abella versions 2.0.2 included to 2.0.5 included. The tool may not work with more recent versions, and you may need to use opam to install a version of Abella between 2.0.2 and to 2.0.5 included. 
</ul>

Quick usage: 
<br />
<ul>
<li> make 
	<br /> <i> Compilation may take 1 or 2 minutes </i> 
<li> ./soundy 
</ul>
Output: a successful message means that <br />
<ul>
<li> The tool has succesfully type checked all the language specifications in the folder "repo". 
<li> The tool has automatically generated Abella files (.sig, .mod, and especially .thm) in the folder "generated". 
       <br/><i>These files contain the theorem and proof of type soundness for each language specification. </i> 
<li> Abella has succesfully proof-checked all the type soundness proofs generated. 
       <br/><i>To be precise: the command "</i>abella<i>" runs to "Proof Completed" on all generated .thm in the folder "generated". </i> 
	   <br />
</ul>

To clean: <br />
<ul>
<li> make cleanOnlyTool 
	<br /> (removes compilation files and executable) 
<li> make clean 
	<br />  (removes Abella files in "generated") 
</ul>
<br />

# <a name="examples"></a>Examples of Spotted Design Mistakes in Languages. 

Only a few relevant examples, acting on the file "<strong>fpl_cbv.mod</strong>" in the folder "<strong>repo</strong>": 
<br />(./soundy after each modification)
<br />fpl_cbv.mod, which stands for 'functional programming language', contains the language definition for a functional language with integers, booleans, pairs, sums, lists, universal types, recursive types, fix, letrec, and exceptions (try, raise))
<ul>
	<li style="margin: 20px;"> Remove line 33: <strong> step (pred (zero )) (raise (zero )).</strong>
	<br /> Error Message: "Operator <strong>pred</strong> is elimination form for the type <strong>int</strong> but does not have a reduction rule for handling one of the values of type <strong>int</strong>: value <strong>zero</strong>"
<li style="margin: 20px;">  Replace line 33: <strong> step (pred (zero )) (raise (zero )).</strong>  with <strong> step (pred <strong style="color:red;">(tt)</strong>) (raise (zero )).</strong>	 
	<br /> Error Message: "<strong>pred</strong> is an elimination form for type <strong>int</strong>, but has a reduction rule to handle <strong>tt</strong>, which is not a value of type <strong>int</strong>"
	<br /> <i>Notice that the type system of a logical framework may not spot this error because </i><strong>pred</strong><i> accepts an expression as argument and </i><strong>(tt)</strong><i> is an expression. This error can be spotted after our high-level classification of operators.</i>
	<br />
<li style="margin: 20px;">  Replace line 45: <strong> step (fst (pair E1 E2)) E1.</strong>  with <strong> step (fst (pair E1 E2)) <strong style="color:red;"> E2</strong></strong>. 
	<br /> <i>The mistake here is that <strong>(fst (pair E1 E2))</strong> does not have the type of <strong>E2</strong> but that of <strong>E1</strong>.</i>
	<br /> Error Message: "Reduction rule of <strong>fst</strong> for handling a value <strong>pair</strong> is not type preserving"
	<br />
<li style="margin: 20px;">  Remove line 133: <strong> % context app C e.</strong>
	<br /> Error Message: "The principal argument of the elimination form <strong>app</strong> is not declared as evaluation context, hence some programs may get stuck"
	<br />
<li style="margin: 20px;">  Remove line 134: <strong> % context app v C.</strong>
	<br /> Error Message: "Operator <strong>app</strong> has a reduction rule that requires some its arguments to be values, but these are not in evaluation contexts, hence some programs may get stuck."
	<br />
<li style="margin: 20px;">  Remove line 125: <strong> % context pair v C.</strong>
	<br /> Error Message: "Operator <strong>pair</strong> has a value declaration in which some of its arguments must be values, but are not in evaluation contexts, hence some programs may get stuck.""
	<br />
<li style="margin: 20px;">  Replace line 129: <strong> % context cons C e.</strong> with <strong> % context cons C v.</strong>
	<br /> Error Message: "Evaluation contexts have cyclic dependencies, hence some programs may get stuck"
	<br />
<li style="margin: 20px;">  Replace line 21: <strong> typeOf (cons E1 E2) (list T) :- <strong style="color:red;">typeOf E1 T,</strong> typeOf E2 (list T).</strong> 
	<br /> with <strong >typeOf (cons E1 E2) (list T) :- typeOf E2 (list T).</strong>
	<br /> Error Message: "This typing rule does not assign a type to the expression E1: <strong>typing rule displayed</strong>"
	
</ul>

# Some Interesting Examples  in the Folder "repo"<br />
<ul> 
<li> fpl_cbv_sub.mod: The language fpl above, without recursive types, and with subtyping for all other types. 
<li> systemFsub.mod: System F with bounded subtyping, i.e., POPLMark Challenge 2A. 
<li> systemFsub_records: System F sub with records, i.e., POPLMark Challenge 2B without pattern-matching. 
	  <br />Disclaimer 1: that a list is either empty or a 'cons' is an admitted lemma. 
	  <br />Disclaimer 2: that labels in records have distinct names is an admitted lemma. 
	  <br />The rest of the type soundness proof is completely mechanized, automatically generated. 
<li> systemFsub_records_invoke: System F sub with records, and also an invoke operators, i.e. grab a function from the record to apply it to an argument. 
	  <br />Disclaimer 1: that a list is either empty or a 'cons' is an admitted lemma. 
	  <br />Disclaimer 2: that labels in records have distinct names is an admitted lemma. 
	  <br />The rest of the type soundness proof is completely mechanized, automatically generated. 
<li> systemFsub_kernel: Like System F sub, but the first argument of 'for all' is invariant.
<li> Some other examples include 
<ul> 
<li> <a href="https://github.com/mcimini/TypeSoundnessCertifier/tree/master/Comp5310_teaching_version/repo/stlc_option.lan">option types</a>
<li> <a href="https://github.com/mcimini/TypeSoundnessCertifier/tree/master/Comp5310_teaching_version/repo/stlc_lists_append.lan">list append</a>
<li> <a href="https://github.com/mcimini/TypeSoundnessCertifier/tree/master/Comp5310_teaching_version/repo/stlc_lists_filter.lan">list filter</a>
<li> <a href="https://github.com/mcimini/TypeSoundnessCertifier/tree/master/Comp5310_teaching_version/repo/stlc_lists_map.lan">map</a>
<li> <a href="https://github.com/mcimini/TypeSoundnessCertifier/tree/master/Comp5310_teaching_version/repo/stlc_lists_filteri.lan">filteri (also depends on the position in the list of the current element being processed)</a>
<li> <a href="https://github.com/mcimini/TypeSoundnessCertifier/tree/master/Comp5310_teaching_version/repo/stlc_lists_mapi.lan">mapi (also depends on the position in the list of the current element being processed)</a>
<li> <a href="https://github.com/mcimini/TypeSoundnessCertifier/tree/master/Comp5310_teaching_version/repo/stlc_lists_range.lan">range</a>
<li> <a href="https://github.com/mcimini/TypeSoundnessCertifier/tree/master/Comp5310_teaching_version/repo/stlc_lists_length.lan">list length</a>
<li> <a href="https://github.com/mcimini/TypeSoundnessCertifier/tree/master/Comp5310_teaching_version/repo/stlc_lists_reverse.lan">reverse</a>
<li> <a href="https://github.com/mcimini/TypeSoundnessCertifier/tree/master/Comp5310_teaching_version/repo/stlc_natural_recursor.lan">the recursor of natural numbers (natrec)</a>
</ul> 
</ul> 

