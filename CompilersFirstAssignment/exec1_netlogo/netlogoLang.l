/* This is an example of a simple LL grammar implementation */
%{
#include <stdio.h>
#include <string.h>

#define TK_NAME 300
#define TK_VAR 310
#define TK_NUM 320
#define TK_TO 330
#define TK_TOREPORT 340
#define TK_END 350
#define TK_IF 360
#define TK_REPORT 370
#define TK_LEFT 380
#define TK_RIGHT 390
#define TK_EQUAL 400

/* Needed for syntax analyser*/
#define LEXEND 0

int line = 1;
%}

letter [a-zA-Z]
name [a-z]+
var "?"{letter}+
num [0-9]+
newline \n|\x0A|\x0D|\x0A

%%
"to" {return TK_TO;}
"end" {return TK_END;}
"to-report" {return TK_TOREPORT;}
"if" {return TK_IF;}
"[" {return TK_LEFT;}
"]" {return TK_RIGHT;}
"report" {return TK_REPORT;}
{var} {return TK_VAR;}
{name} {return TK_NAME;}
{num} {return TK_NUM;}
"=" {return TK_EQUAL;}

. {/* Do Nothing */}
{newline} { line++; }

%%
// forward declarations


int token = 0;
void error_syntax(const char* message);
void match(int tk);
/* this will be the top level function of your parser (start symbol)*/
void PDefinitions();
void PDef();
void ProcFunN();
void Body();
void B();
void C();
void D();
void Y();
void E();
void Vars();
void Args();
void VarNum();
/* Error Reporting */
/* This is a error reporting function that might prove to be handy 
for your debugging. You can call it from different rules error_syntax("<your message here>")
for example error_syntax("PDef") so you can see were your parser has failed.
*/

void PDefinitions(void){
	// if the program starts with to or to-report we apply the rule
	// otherwise we exit because of ε-transition.
	if (token == TK_TO || token == TK_TOREPORT) {
		PDef(); PDefinitions();	
	}
}

void PDef(void){
	if (token == TK_TO) {
		match(TK_TO); ProcFunN(); Body(); match(TK_END);
	}
	else if (token == TK_TOREPORT){
		match(TK_TOREPORT); ProcFunN(); Body(); match(TK_END);
	}
	else {error_syntax("PDef");}
}
void ProcFunN(void){
	if (token == TK_NAME) {
		match(TK_NAME); D();
	}
	else {error_syntax("ProcFunN");}
}

void Body(void) {
	if (token == TK_IF) {
		match(TK_IF); ProcFunN(); match(TK_LEFT); Body(); match(TK_RIGHT);
	}
	else if (token == TK_REPORT){
		match(TK_REPORT); VarNum();
	}
	else if (token == TK_NAME) {
		ProcFunN();
	}
	else if (token == TK_VAR) {
		match(TK_VAR); match(TK_EQUAL); match(TK_NUM);
	}
	else {error_syntax("Body");}
}

void VarNum(void){
	if (token == TK_NUM) {
		match(TK_NUM);
	}
	else if (token == TK_VAR) {
		match(TK_VAR);
	}
	else {error_syntax("VarNum");}
}

void E(void) {
	if (token == TK_VAR) {
		match(TK_VAR); E();
	}
	else if (token != TK_RIGHT) {error_syntax("E");}
}

void Vars(void) {
	if (token == TK_VAR) { 
		match(TK_VAR); E();
	}
	else {error_syntax("Vars");}
}

void Y(void) {
	if (token == TK_VAR || token == TK_NUM){
		VarNum(); Y();
	}
	else if (token != TK_IF && token != TK_REPORT && token != TK_NAME &&
		token != TK_VAR && token != TK_RIGHT && token != TK_LEFT && token != TK_END)
		{error_syntax("Y ERROR");}
}

void Args(void) {
	if (token == TK_VAR || token == TK_NUM){
		VarNum(); Y();
	}
	else {error_syntax("Args");}
}

void C(void){
	if (token == TK_VAR || token == TK_NUM){
		Args();
	}
	else if (token != TK_IF && token != TK_REPORT && token != TK_NAME &&
		token != TK_VAR && token != TK_RIGHT && token != TK_LEFT && token != TK_END)
		{error_syntax("C ERROR");}
}

void B(void) {
	if (token == TK_LEFT) {
		match(TK_LEFT); Vars(); match(TK_RIGHT);
	}
	else if (token != TK_IF && token != TK_REPORT && token != TK_NAME &&
		token != TK_VAR && token != TK_RIGHT && token != TK_LEFT && token != TK_END)
		{error_syntax("Y ERROR");}
}

void D(void) {
	if (token == TK_LEFT){
		B();
	}
	else if (token == TK_VAR || token == TK_NUM){
		C();
	}
	else if (token != TK_IF && token != TK_REPORT && token != TK_NAME &&
		token != TK_VAR && token != TK_RIGHT && token != TK_LEFT && token != TK_END)
			{printf("num %d : ", token);error_syntax("D ERROR");}
}


void error_syntax(const char * message){
   printf("Parsing Rule %s. Syntax Error reading %s at line %d of input. \n",message, yytext, line);
   exit(-1);
}

/* Match next token */
void match(int tk){
   if (token == tk) token = yylex();
   else  error_syntax("Match Failed");
}

int main(int argc, char **argv ){
   ++argv, --argc;  /* skip over program name */
   if ( argc > 0 )
       yyin = fopen( argv[0], "r" );
   else
      yyin = stdin;

   token = yylex();
   PDefinitions();
   if (token == LEXEND) printf("\n Success! \n \n");
   else error_syntax("Parse not Complete.");
   return 0;
}
