%{
    #include <stdio.h>
    #include <string.h>
    int yylex(void);
    int yyerror(char* s);
    extern int lineno;
%}

%union {
    int i;
    char *s;
};

%token CLASS
%token PUBLIC 
%token STATIC 
%token VOID 
%token MAIN 
%token EXTENDS   
%token RETURN
%token IF
%token ELSE 
%token WHILE 
%token THIS
%token NEW
%token LENGTH 
%token PRINTLN 
%token IDENT
%token ACC_OUV
%token ACC_FER
%token PAR_OUV
%token PAR_FER
%token OPPAFFECT
%token PT_VIRG
%token BOOL
%token INT
%token TYPE
%token IDEN
%token ERROR


%%

program: PUBLIC CLASS IDENT ACC_OUV ACC_FER;


%%

int main( int argc, char **argv ){
    yyparse();
    return 0;
}   


int yyerror(char *s)


{
	printf("Syntax Error on line %d\n", lineno);
	return 0;
}