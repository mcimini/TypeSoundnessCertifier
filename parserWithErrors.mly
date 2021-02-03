
%token <string> VARLEX
%token <string> VARTERM
%token <int> INT
%token GRAMMARASSIGN
%token MID
%token COMMA
%token PROVIDED
%token COLON
%token TURNSTYLE
%token AND
%token LEFTPAR  
%token RIGHTPAR 
%token EMPTYCTX 
%token DOT 
%token STEP 
%token VALUECTX 
%token EXPCTX 
%token GAMMA 
%token VARX 
%token VARBIGX 
%token LEFTSQUARE 
%token RIGHTSQUARE 
%token SUBSTBAR 
%token VALUEPRED 
%token DIRECTIVE 
%token SUBTYPING 
 

%left EXEC

%token EOF

%start file
%type <bool> file

%%

file:
  | EOF
    { true }
  | language EOF
    { true }

language :
	| option(list(grammarLine)) option(list(rule)) option(list(directives)) 
  		{ true }
 
term :  
  | LEFTPAR VARLEX list(term) RIGHTPAR	
    { true } 
  | VARX
    { true }
  | VARBIGX
    { true }
  | VARTERM
    { true }
  | LEFTPAR VARX RIGHTPAR term      
    { true }  
  | LEFTPAR VARBIGX RIGHTPAR term     
  	{ true } 
  | VALUECTX
      { true } 
  | EXPCTX
      { true } 
  | term LEFTSQUARE term SUBSTBAR term RIGHTSQUARE
      { true } 

rule : 
  | f = formula DOT
    { true }
  | f = formula PROVIDED separated_list(AND, formula) DOT
    { true }

formula : 
  | assumption TURNSTYLE term COLON term
    { true }
    | assumption TURNSTYLE term SUBTYPING term
      { true }
  | term STEP term 
    { true }
  | term SUBTYPING term
    { true }
  | VALUEPRED term 
	{ true }

assumption : 
  | GAMMA 
    { true }
  | GAMMA COMMA VARX COLON term
    { true }
  | GAMMA COMMA VARBIGX 
	{ true }
  | GAMMA COMMA term SUBTYPING term 
    { true }

grammarLine : 
	| VARTERM option(VARTERM) GRAMMARASSIGN separated_list(MID, term)	
	{ true }
	| VARTERM option(VARTERM) GRAMMARASSIGN EMPTYCTX MID option(separated_list(MID, term))	
	{ true }

directives : 
	| DIRECTIVE list(tagInfo) DOT	
	{ true }
	| DIRECTIVE list(tagInfo) rule	
	{ true }

tagInfo : 
	| VARLEX	
	| VARTERM
	| INT	
	| COLON	
	{ true }
  