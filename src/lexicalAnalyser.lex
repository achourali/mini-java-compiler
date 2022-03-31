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



%%

{bl}                     printf(" ");
"//".*                   if(!bloc_comment) printf(" line comment ");   
"/*"                     bloc_comment=1;
"*/"                     if(bloc_comment ){printf(" bloc comment "); bloc_comment=0;};
\n                       lineno+=1;
"{"                      if(!bloc_comment){return( ACC_OUV);}
"}"                      if(!bloc_comment){return( ACC_FER);}
[(]                      if(!bloc_comment){return( PAR_OUV);}
[)]                      if(!bloc_comment){return( PAR_FER);}
"="	                    if(!bloc_comment){return( OPPAFFECT);}
";"                      if(!bloc_comment){return( PT_VIRG);}

{CLASS}                  if(!bloc_comment) {return(CLASS);}
{PUBLIC}                 if(!bloc_comment) {return(PUBLIC);}
{STATIC}                 if(!bloc_comment) {return(STATIC);}
{VOID}                   if(!bloc_comment) {return(VOID);}
{MAIN}                   if(!bloc_comment) {return(MAIN);}
{EXTENDS}                if(!bloc_comment) {return(EXTENDS);}
{RETURN}                 if(!bloc_comment) {return(RETURN);}
{IF}                     if(!bloc_comment) {return(IF);}
{ELSE}                   if(!bloc_comment) {return(ELSE);}
{WHILE}                  if(!bloc_comment) {return(WHILE);}
{THIS}                   if(!bloc_comment) {return(THIS);}
{NEW}                    if(!bloc_comment) {return(NEW);}
{LENGTH}                 if(!bloc_comment) {return(LENGTH);}
{PRINTLN}                if(!bloc_comment) {return(PRINTLN);}

{BOOLEAN_LITERAL}        if(!bloc_comment){return( BOOL);}
{INTEGER_LITERAL}        if(!bloc_comment){return( INT);}
{type}                   if(!bloc_comment){return( TYPE);}
{identifier}             if(!bloc_comment){return(IDENT);}
.                        if(!bloc_comment){return( ERROR);}


%%

int Omain(int argc, char *argv[]) 
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
