%{


#include "syntaxiqueAnalyser.tab.h"
#include "semanticAnalyser.h"
int lineno=1;
int bloc_comment=0;

%}
delim     [ \t]
bl        {delim}+
chiffre   [0-9]
type ("int"|"boolean"|"String"|"void")("[""]")?
identifier ([a-zA-Z_][a-zA-Z0-9_]*)
BOOLEAN_LITERAL "true"|"false"
INTEGER_LITERAL  "-"?[0-9][0-9]*
iderrone  {chiffre}(.*)
CLASS "class"
PUBLIC "public"
STATIC "static"
VOID "void"
MAIN "main"
EXTENDS "extends"
RETURN "return"
IF "if"
ELSE "else"
WHILE "while"
THIS "this"
NEW "new"
LENGTH "length"
PRINTLN "System.out.println"
STRINGARR "String[]"
OPP ("&&"|"+"|"-"|"*"|"<"|">")


%%

{bl}                     
"//".*                   if(!bloc_comment) {   }
"/*"                     bloc_comment=1;
"*/"                     if(bloc_comment ){ bloc_comment=0;};
\n                       lineno+=1;
"{"                      if(!bloc_comment){return( ACC_OUV);}
"}"                      if(!bloc_comment){return( ACC_FER);}
[(]                      if(!bloc_comment){yylval.stringValue= strdup(yytext);return( PAR_OUV);}
[)]                      if(!bloc_comment){yylval.stringValue= strdup(yytext);return( PAR_FER);}
"="	                     if(!bloc_comment){yylval.stringValue= strdup(yytext);return( OPPAFFECT);}
"!"                      if(!bloc_comment){yylval.stringValue= strdup(yytext);return( OPPNOT);}
"."                      if(!bloc_comment){yylval.stringValue= strdup(yytext);return( DOT);}
";"                      if(!bloc_comment){yylval.stringValue= strdup(yytext);return( PT_VIRG);}
","                      if(!bloc_comment){yylval.stringValue= strdup(yytext);return( VIRG);}
"["                      if(!bloc_comment){yylval.stringValue= strdup(yytext);return( BRAK_OUV); }
"]"                      if(!bloc_comment){yylval.stringValue= strdup(yytext);return( BRAK_FER); }
{CLASS}                  if(!bloc_comment){yylval.stringValue= strdup(yytext);return( CLASS);}
{PUBLIC}                 if(!bloc_comment){yylval.stringValue= strdup(yytext);return( PUBLIC);}
{STATIC}                 if(!bloc_comment){yylval.stringValue= strdup(yytext);return( STATIC);}
{VOID}                   if(!bloc_comment){yylval.stringValue= strdup(yytext);return( VOID);}
{MAIN}                   if(!bloc_comment){yylval.stringValue= strdup(yytext);return( MAIN);}
{EXTENDS}                if(!bloc_comment){yylval.stringValue= strdup(yytext);return( EXTENDS);}
{RETURN}                 if(!bloc_comment){yylval.stringValue= strdup(yytext);return( RETURN);}
{IF}                     if(!bloc_comment){yylval.stringValue= strdup(yytext);return( IF);}
{ELSE}                   if(!bloc_comment){yylval.stringValue= strdup(yytext);return( ELSE);}
{WHILE}                  if(!bloc_comment){yylval.stringValue= strdup(yytext);return( WHILE);}
{THIS}                   if(!bloc_comment){yylval.stringValue= strdup(yytext);return( THIS);}
{NEW}                    if(!bloc_comment){yylval.stringValue= strdup(yytext);return( NEW);}
{LENGTH}                 if(!bloc_comment){yylval.stringValue= strdup(yytext);return( LENGTH);}
{PRINTLN}                if(!bloc_comment){yylval.stringValue= strdup(yytext);return( PRINTLN);}
{STRINGARR}              if(!bloc_comment){yylval.stringValue= strdup(yytext);return( STRINGARR);}
{OPP}                    if(!bloc_comment){yylval.stringValue= strdup(yytext);return( OPP);}
{BOOLEAN_LITERAL}        if(!bloc_comment){yylval.stringValue= strdup(yytext);return( BOOL);}
{INTEGER_LITERAL}        if(!bloc_comment){yylval.stringValue= strdup(yytext);return( INT);}
{type}                   if(!bloc_comment){yylval.stringValue= strdup(yytext);return( TYPE);}
{identifier}             if(!bloc_comment){yylval.stringValue= strdup(yytext);return(IDENT);}
.                        if(!bloc_comment){yylval.stringValue= strdup(yytext);return( ERROR);}


%%

// int main(int argc, char *argv[]) 
// {
//      yylex();
//      printf("\n");
// }


int yywrap()
{
	return(1);
}
