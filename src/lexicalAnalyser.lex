%{


int lineno=1;
int bloc_comment=0;
#include "syntaxiqueAnalyser.tab.h"
%}
delim     [ \t]
bl        {delim}+
chiffre   [0-9]
type ("int"|"boolean"|"String"|"void")("[""]")?
identifier ([a-zA-Z_][a-zA-Z0-9_]*)
BOOLEAN_LITERAL "true"|"false"
INTEGER_LITERAL  "-"?[1-9][0-9]*
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
[(]                      if(!bloc_comment){return( PAR_OUV);}
[)]                      if(!bloc_comment){return( PAR_FER);}
"="	                    if(!bloc_comment){return( OPPAFFECT);}
"!"                      if(!bloc_comment){return( OPPNOT);}
"."                      if(!bloc_comment){return( DOT);}
";"                      if(!bloc_comment){return( PT_VIRG);}
","                      if(!bloc_comment){return( VIRG);}
"["                      if(!bloc_comment){return( BRAK_OUV); }
"]"                      if(!bloc_comment){return( BRAK_FER); }
{CLASS}                  if(!bloc_comment){return( CLASS);}
{PUBLIC}                 if(!bloc_comment){return( PUBLIC);}
{STATIC}                 if(!bloc_comment){return( STATIC);}
{VOID}                   if(!bloc_comment){return( VOID);}
{MAIN}                   if(!bloc_comment){return( MAIN);}
{EXTENDS}                if(!bloc_comment){return( EXTENDS);}
{RETURN}                 if(!bloc_comment){return( RETURN);}
{IF}                     if(!bloc_comment){return( IF);}
{ELSE}                   if(!bloc_comment){return( ELSE);}
{WHILE}                  if(!bloc_comment){return( WHILE);}
{THIS}                   if(!bloc_comment){return( THIS);}
{NEW}                    if(!bloc_comment){return( NEW);}
{LENGTH}                 if(!bloc_comment){return( LENGTH);}
{PRINTLN}                if(!bloc_comment){return( PRINTLN);}
{STRINGARR}              if(!bloc_comment){return( STRINGARR);}
{OPP}                    if(!bloc_comment){return( OPP);}
{BOOLEAN_LITERAL}        if(!bloc_comment){return( BOOL);}
{INTEGER_LITERAL}        if(!bloc_comment){return( INT);}
{type}                   if(!bloc_comment){return( TYPE);}
{identifier}             if(!bloc_comment){return( IDENT);}
.                        if(!bloc_comment){return( ERROR);}


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
