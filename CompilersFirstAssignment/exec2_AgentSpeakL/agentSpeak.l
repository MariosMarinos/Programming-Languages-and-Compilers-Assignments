%{
#include <stdio.h>
#include <string.h>

int line = 1;
%}

ws [ \t]+
newline \n|\x0A|\x0D\x0A
nzdigit [0-9]
digit (0|{nzdigit}) 
digits {digit}+
floats  {digits}(\.{digits})
capital [A-Z]
smallcase [a-z]
letter [A-Za-z]
variable {capital}({letter}|{digit}|_)*
atom {smallcase}({letter}|{digit}|_)*
%%
{ws} {/* do nothing */}
{digits} {return T_NUM;}
{floats} {return T_NUM;}

"." {return '.';}
"(" {return '(';}
")" {return ')';}
":" {return ':';}
"<-" {return T_ARROW;}
"true" {return T_TRUE;}
"+" {return '+';}
"-" {return '-';}
"&" {return '&';}
"not" {return T_NOT;}
"!" {return '!';}
"?" {return '?';}
"," {return ',';}
";" {return ';';}

{atom} {return T_ATOM;}
{variable} {return T_VAR;}
"_" {return T_VAR;}

{newline} {line++;} /* when finding a new line, just increase the line number used for error reporting*/
. {/*Do nothing*/}

%%

