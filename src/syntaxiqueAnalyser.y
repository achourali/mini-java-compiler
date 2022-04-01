%{
    #include <stdio.h>
    #include <string.h>
    int yylex(void);
    int yyerror(const char* s);
    extern int lineno;
    #define YYERROR_VERBOSE 1
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
%token ERROR
%token STRINGARR
%token BRAK_OUV
%token BRAK_FER
%token VIRG
%token OPP
%token DOT
%token OPPNOT



%%

Program:                MainClass ClassesDeclaration
MainClass :             CLASS IDENT ACC_OUV 
                            PUBLIC STATIC VOID MAIN PAR_OUV STRINGARR IDENT PAR_FER ACC_OUV
                                VarsDeclarations
                                Statements
                                ReturnStatement
                            ACC_FER 
                        ACC_FER
ClassesDeclaration:     ClassesDeclaration ClassDeclaration |
ClassDeclaration:       ClassHead ACC_OUV
                            VarsDeclarations
                            MethodsDeclarations
                        ACC_FER
ClassHead:              CLASS IDENT |  CLASS IDENT EXTENDS IDENT
VarsDeclarations:        VarsDeclarations VarDeclaration|VarDeclaration | 
VarDeclaration:         DataType IDENT PT_VIRG
MethodsDeclarations:    MethodsDeclarations MethodDeclaration |
MethodDeclaration:      PUBLIC DataType IDENT PAR_OUV Arguments PAR_FER ACC_OUV
                            VarsDeclarations
                            Statements
                            ReturnStatement
                        ACC_FER
ReturnStatement:        RETURN Expression PT_VIRG | 
Arguments:              DataType IDENT|DataType IDENT VIRG Arguments  
DataType:               TYPE | VOID| STRINGARR | IDENT
Statements:             Statement| Statements Statement| ACC_OUV Statements ACC_FER |
Statement:              IF PAR_OUV Expression PAR_FER 
                            Statements 
                        ELSE Statements 
                        |
                        WHILE PAR_OUV Expression PAR_FER Statements 
                        |
                        PRINTLN PAR_OUV Expression PAR_FER PT_VIRG
                        |
                        IDENT OPPAFFECT Expression PT_VIRG
                        |
                        IDENT BRAK_OUV Expression BRAK_FER OPPAFFECT Expression PT_VIRG

                        PRINTLN PAR_OUV Expression PAR_FER PT_VIRG
Expression:             Expression OPP Expression
                        |
                        Expression BRAK_OUV Expression BRAK_FER
                        |
                        Expression DOT LENGTH
                        |
                        Expression DOT IDENT PAR_OUV Arguments PAR_FER
                        |
                        INT
                        |
                        BOOL
                        |
                        IDENT
                        |
                        THIS
                        |
                        NEW TYPE BRAK_OUV Expression BRAK_FER
                        |
                        NEW IDENT PAR_OUV PAR_FER
                        |
                        OPPNOT Expression
                        |
                        PAR_OUV Expression PAR_FER




%%

int main( int argc, char **argv ){
    printf("\n \nSTARTING ... \n \n");
    int result=yyparse();
    if (result==0) printf("DONE WITH NO ERROS . \n\n");
    return 0;
}   


int yyerror(const char* s)
{
	printf("Syntax Error on line %d : %s\n\n", lineno,s); 
	return 0;
}
