OCAML=ocamlfind ocamlc -w "-8-10-11-14-25-26" -g -package batteries -package menhirLib -linkpkg -thread 
OUTPUT=soundy
GENERATEDDIR=generated/
REPODIR=repo/

default:
	ocamllex lexer.mll
	menhir parserWithErrors.mly
	$(OCAML) parserWithErrors.mli parserWithErrors.ml lexer.ml testParsing.ml aux.ml typedLanguage.ml ldl.ml proof.ml listManagement.ml generateLambdaProlog.ml subtyping.ml listLemmas.ml canonicalForms.ml progress.ml values.ml contextualRules.ml errorManagement.ml alphaConversion.ml ldlToTypedLanguage.ml typeCheckerProgress.ml typeChecker.ml typeCheckerTypedLanguage.ml preservation.ml typeCheckerPreservation.ml parserLan.ml parser.ml soundnessCertifier.ml -o $(OUTPUT)
	
cleanOnlyTool:
	rm *.cmo
	rm *.cmi
	rm $(OUTPUT)
clean:
	rm -f $(GENERATEDDIR)*.thm
	rm -f $(GENERATEDDIR)*.sig
	rm -f $(GENERATEDDIR)*.mod
	rm -f $(REPODIR)*.sig
	rm -f $(REPODIR)*.mod


