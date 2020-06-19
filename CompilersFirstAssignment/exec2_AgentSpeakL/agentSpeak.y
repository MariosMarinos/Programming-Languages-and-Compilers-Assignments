%{
#include <stdio.h>
#include <stdlib.h>

int yylex();

%}

%error-verbose

%token T_VAR
%token'.'
%token'('
%token ')'
%token ':'
%token T_ARROW "<-"
%token T_TRUE "true"
%token '&'
%token T_NOT "not"
%token '!'
%token '?'
%token ','
%token ';'
%token T_newline
%token T_NUM
%token T_ATOM 

%{
void yyerror (const char * msg);
%}

%left '+' '-'


%%
agent : beliefs plans
		;
beliefs : /*empty */
		| beliefs belief
		;
belief : predicate '.'
	;
predicate : T_ATOM '(' terms ')'
	  ;	
plans : /* empty */
	  | plans plan
		; 
plan : triggering_event ':' context T_ARROW body '.'
     | error ':' {yyerrok;} 
     | error '.' {yyerrok;}
     ;
triggering_event : '+' predicate
				 | '-' predicate
				 | '+' goal
				 | '-' goal
					; 
context : T_TRUE
		| cliterals
		;
cliterals : literal 
		  | literal '&' cliterals
			;
literal : predicate
		| T_NOT '(' predicate ')'
		;
goal : '!' predicate 
	 | '?' predicate
	 ;
body : T_TRUE 
	 | actions
	 ;
actions : action
		| action ';' actions
		;
action : predicate
	   | goal
	   | belief_update
	   ;
belief_update : '+' predicate
			  | '-' predicate
			  ;
terms : term
	  | term ',' terms
	  ;
term : T_VAR
	 | T_ATOM
	 | T_NUM
	 | T_ATOM '(' terms ')'
	 ;

%%

/* This is the lexer file.*/

#include "agentSpeak.lex.c"

/* The usual yyerror, + line number indication. The variable line is defined in the lexical analyser.*/
void yyerror (const char * msg){
   fprintf(stderr, "Error(line %d) : %s\n", line,msg);
}

int main(int argc, char **argv ){
  
   ++argv, --argc;  /* skip over program name */
   if ( argc > 0 )
       yyin = fopen( argv[0], "r" );
   else
      yyin = stdin;

   int result = yyparse();
   if (yynerrs == 0) 
	printf("Syntax OK!\n");
   else 
	printf("There were %d erros in code. Failure!\n", yynerrs);
   return result;
}
