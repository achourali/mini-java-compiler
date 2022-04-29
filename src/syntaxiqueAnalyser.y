%{
    #include <stdio.h>
    #include <string.h>
    #include "semanticAnalyser.h"


    int yyparse(void);
    int yylex(void);
    int yyerror(const char* s);
    extern int lineno;
    #define YYERROR_VERBOSE 1;
    int errors=0;


    
%}

%glr-parser
%union {
   char* stringValue;
   char** stringsValues;
}

    

%token <stringValue>CLASS
%token <stringValue>PUBLIC 
%token <stringValue>STATIC 
%token <stringValue>VOID 
%token <stringValue>MAIN 
%token <stringValue>EXTENDS   
%token <stringValue>RETURN
%token <stringValue>IF
%token <stringValue>ELSE 
%token <stringValue>WHILE 
%token <stringValue>THIS
%token <stringValue>NEW
%token <stringValue>LENGTH 
%token <stringValue>PRINTLN 
%token <stringValue>IDENT
%token <stringValue>ACC_OUV
%token <stringValue>ACC_FER
%token <stringValue>PAR_OUV
%token <stringValue>PAR_FER
%token <stringValue>OPPAFFECT
%token <stringValue>PT_VIRG
%token <stringValue>BOOL
%token <stringValue>INT
%token <stringValue>TYPE
%token <stringValue>ERROR
%token <stringValue>STRINGARR
%token <stringValue>BRAK_OUV
%token <stringValue>BRAK_FER
%token <stringValue>VIRG
%token <stringValue>OPP
%token <stringValue>DOT
%token <stringValue>OPPNOT


%type <stringValue> DataType ;


%%

Program:                MainClass ClassesDeclaration 
MainClass :             CLASS IDENT ACC_OUV  {enterMemberScope();}
                            PUBLIC STATIC VOID MAIN PAR_OUV STRINGARR IDENT PAR_FER ACC_OUV {enterLocalScope();}
                                VarsDeclarations
                                Statements
                                ReturnStatement
                            ACC_FER {exitCurrentLocalScope();}
                        ACC_FER {exitCurrentMemberScope();}
ClassesDeclaration:     ClassesDeclaration ClassDeclaration |
ClassDeclaration:       ClassHead ACC_OUV {enterMemberScope();}
                            VarsDeclarations
                            MethodsDeclarations
                         ACC_FER {exitCurrentMemberScope();}
ClassHead:              CLASS IDENT |  CLASS IDENT EXTENDS IDENT
VarsDeclarations:        VarsDeclarations VarDeclaration |
VarDeclaration:         DataType IDENT PT_VIRG {addVariable($2,$1);}
MethodsDeclarations:    MethodsDeclarations MethodDeclaration |
MethodDeclaration:      PUBLIC DataType IDENT {enterLocalScope();} PAR_OUV{clearArgumentsTypesList();} ArgumentsDeclarations PAR_FER {addFunction($3,$2);} ACC_OUV
                            VarsDeclarations
                            Statements
                            ReturnStatement
                        ACC_FER {exitCurrentLocalScope();}
ReturnStatement:        RETURN Expression PT_VIRG | 
ArgumentsDeclarations:  DataType IDENT {addArgumentType($1);addVariable($2,$1);}|
                        DataType IDENT VIRG ArgumentsDeclarations {addArgumentType($1);addVariable($2,$1);} |
                        ; 
DataType:               TYPE | VOID| STRINGARR | IDENT;
Statements:             Statements Statement| 
                        ACC_OUV {enterLocalScope();} Statements ACC_FER  {exitCurrentLocalScope();}|
                        VarDeclaration| 
                        ;
Statement:              IF PAR_OUV Expression PAR_FER 
                            Statements 
                        ELSE Statements 
                        |
                        WHILE PAR_OUV Expression PAR_FER Statements 
                        |
                        PRINTLN PAR_OUV Expression PAR_FER PT_VIRG
                        |
                        IDENT OPPAFFECT Expression PT_VIRG {initVar($1);}
                        |
                        IDENT BRAK_OUV Expression BRAK_FER OPPAFFECT Expression PT_VIRG {initVar($1);}


                        PRINTLN PAR_OUV Expression PAR_FER PT_VIRG

Arguments:              IDENT VIRG Arguments  | INT VIRG Arguments |BOOL VIRG Arguments  | IDENT | INT | BOOL 
Expression:             Expression OPP Expression
                        |
                        Expression BRAK_OUV Expression BRAK_FER
                        |
                        Expression DOT LENGTH PAR_OUV PAR_FER
                        |
                        Expression DOT IDENT PAR_OUV Arguments PAR_FER 
                        |
                        INT
                        |
                        BOOL
                        |
                        IDENT {usingVar($1);}
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
    printf("\n\nSTARTING ... \n\n");
    errors+=yyparse();
    checkIfAllVarsAreUsed();
    if (errors==0) {
        printSymbolicTable();
        printf("\n\nDONE WITH NO ERROS . \n\n");
        
    }
    return 0;
}   


int yyerror(const char* s)
{
	printf("Error on line %d : %s\n\n", lineno,s); 
    errors++;
	return 0;
}
