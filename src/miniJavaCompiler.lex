%{

int yylineno;
int bloc_comment=0;
%}
delim     [ \t]
bl        {delim}+
chiffre   [0-9]
keyword "class"|"public"|"static"|"void"|"main"|"extends"|"return"|"if"|"else"|"while"|"this"|"new"|"length"|"System.out.println"
type ("int"|"boolean"|"String"|"void")("[""]")?
identifier ([a-zA-Z_][a-zA-Z0-9_]*)
BOOLEAN_LITERAL "true"|"false"
INTEGER_LITERAL  "-"?[1-9][0-9]*
iderrone  {chiffre}(.*)


%%

{bl}                     printf(" ");
"//".*                   if(!bloc_comment) printf(" line comment ");   
"/*"                     bloc_comment=1;
"*/"                     if(bloc_comment ){printf(" bloc comment "); bloc_comment=0;};
\n                       yylineno+=1;if(!bloc_comment)printf("\n%d",yylineno);
"{"                      if(!bloc_comment)printf(" acc_ouv ");
"}"                      if(!bloc_comment)printf(" acc_fer ");
[(]                      if(!bloc_comment)printf(" parenthese_ouvrante ");
[)]                      if(!bloc_comment)printf(" parenthese_fermante ");
"="	                    if(!bloc_comment)printf(" OPPAFFECT ");
";"                      if(!bloc_comment)printf(" point_virg ");
{keyword}                if(!bloc_comment)printf(" keyword ");
{BOOLEAN_LITERAL}        if(!bloc_comment)printf(" BOOLEAN_LITERAL ");
{INTEGER_LITERAL}        if(!bloc_comment)printf(" INTEGER_LITERAL ");
{type}                   if(!bloc_comment)printf(" type ");
{identifier}             if(!bloc_comment)printf(" identifier ");
.                        if(!bloc_comment)printf(" error ");
%%

int main(int argc, char *argv[]) 
{
     printf("1");
     yyin = fopen(argv[1], "r");
     yylex();
     fclose(yyin);
     printf("\n");
}


int yywrap()
{
	return(1);
}
