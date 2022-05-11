%{
    #include <stdio.h>
    #include <string.h>
    #include "semanticAnalyser.h"
    #include "assemblyCodeGenerator.h"


    int yyparse(void);
    int yylex(void);
    int yyerror(const char* s);
    extern int lineno;
    #define YYERROR_VERBOSE 1;
    int errors=0;
    #define YYDEBUG 1
    extern symbolNode* currentFunction;
    extern scope* currentLocalScope;


    
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
%type <stringValue>Expression;


%%

Program:                MainClass ClassesDeclaration 
MainClass :             CLASS IDENT ACC_OUV  {enterMemberScope();}
                            MethodsDeclarations
                            PUBLIC STATIC VOID MAIN PAR_OUV STRINGARR IDENT PAR_FER ACC_OUV {enterLocalScope();}{clearParametersTypesList();currentFunction=addFunction("main","void");}
                                VarsDeclarations
                                Statements
                                ReturnStatement
                            ACC_FER {exitCurrentLocalScope();}
                            MethodsDeclarations
                        ACC_FER {exitCurrentMemberScope();}
ClassesDeclaration:     ClassesDeclaration ClassDeclaration |
ClassDeclaration:       ClassHead ACC_OUV {enterMemberScope();}
                            VarsDeclarations
                            MethodsDeclarations
                         ACC_FER {exitCurrentMemberScope();}
ClassHead:              CLASS IDENT |  CLASS IDENT EXTENDS IDENT
VarsDeclarations:       VarsDeclarations VarDeclaration |
VarDeclaration:         DataType IDENT PT_VIRG {addVariable($2,$1);}
MethodsDeclarations:    MethodsDeclarations MethodDeclaration |
MethodDeclaration:      PUBLIC STATICITY DataType IDENT {enterLocalScope();} PAR_OUV{clearParametersTypesList();} ArgumentsDeclarations PAR_FER {addFunction($4,$3);} ACC_OUV
                            VarsDeclarations
                            Statements
                            ReturnStatement
                        ACC_FER {exitCurrentLocalScope();}
ReturnStatement:        RETURN Expression PT_VIRG | 
ArgumentsDeclarations:  DataType IDENT {addParameterType($1);addVariable($2,$1);}|
                        DataType IDENT VIRG ArgumentsDeclarations {addParameterType($1);addVariable($2,$1);} |
                        ; 
DataType:               TYPE | VOID| STRINGARR | IDENT;
STATICITY:              STATIC |
Statements:             Statements Statement|
                        ACC_OUV {enterLocalScope();} VarsDeclarations Statements ACC_FER  {exitCurrentLocalScope();}
                        |
Statement:              IF PAR_OUV Expression PAR_FER
                        {addCodeNode("SIFAUX",-1,currentFunction);}
                            ACC_OUV {enterLocalScope();} Statements ACC_FER  {exitCurrentLocalScope();} 
                        { 
                            addCodeNode("SAUT",-1,currentFunction); 
                            updateLastSIFAUX();
                        }
                        ELSE ACC_OUV {enterLocalScope();} Statements ACC_FER  {exitCurrentLocalScope();} 
                        {updateLastSAUT();}
                        |
                        WHILE PAR_OUV
                        {addWhileNode(getLastCodeNodeIndex()+1);}
                        Expression PAR_FER
                        {addCodeNode("TANTQUEFAUX",-1,currentFunction);}
                        ACC_OUV {enterLocalScope();} Statements ACC_FER  {exitCurrentLocalScope();} 
                        {
                            whileNode* latestWhileNode=getLatestWhileNode();
                            addCodeNode("TANTQUE",latestWhileNode->startingConditionIndex,currentFunction);
                            updateLastTantQueFaux();
                        }
                        |
                        PRINTLN PAR_OUV Expression PAR_FER PT_VIRG
                        |
                        IDENT OPPAFFECT Expression PT_VIRG {
                            initVar($1);
                            symbolNode *variable=searchVariableInAccesibleScopes($1);
                            addCodeNode("STORE",variable->index,currentFunction);    
                        }
                        |
                        IDENT BRAK_OUV Expression BRAK_FER OPPAFFECT Expression PT_VIRG {initVar($1);}
                        |
                        THIS DOT IDENT PAR_OUV {clearArgumentsList();} Arguments PAR_FER PT_VIRG {callFunction($3);}
                        |
                        IDENT PAR_OUV {clearArgumentsList();} Arguments PAR_FER PT_VIRG {callFunction($1);}
                        

Arguments:              IDENT VIRG Arguments {usingVar($1);addArgumentTypeFromName($1);}  
                        | INT VIRG Arguments {addArgumentType("int");}
                        |BOOL VIRG Arguments  {addArgumentType("boolean");}
                        | IDENT {usingVar($1);addArgumentTypeFromName($1);}   
                        | INT {addArgumentType("int");}
                        | BOOL {addArgumentType("boolean");}
                        |
Expression:             Expression OPP Expression {
                            
                            if (strcmp($2, "+") == 0) {
                                addCodeNode("ADD",-1,currentFunction);
                            }else if (strcmp($2, "-") == 0) {
                                addCodeNode("SUB",-1,currentFunction);
                            }else if (strcmp($2, "/") == 0) {
                                addCodeNode("DIV",-1,currentFunction);
                            }else if (strcmp($2, "*") == 0) {
                                addCodeNode("MUL",-1,currentFunction);
                            }else if (strcmp($2, "<=") == 0) {
                                addCodeNode("INFE",-1,currentFunction);
                            }else if (strcmp($2, ">=") == 0) {
                                addCodeNode("SUPE",-1,currentFunction);
                            }else if (strcmp($2, "<") == 0) {
                                addCodeNode("INF",-1,currentFunction);
                            }else if (strcmp($2, ">") == 0) {
                                addCodeNode("SUP",-1,currentFunction);
                            }
                        }
                        |
                        Expression BRAK_OUV Expression BRAK_FER
                        |
                        Expression DOT LENGTH PAR_OUV PAR_FER
                        |
                        Expression DOT IDENT PAR_OUV Arguments PAR_FER 
                        |
                        INT {addCodeNode("LDC",atoi($1),currentFunction);}
                        |
                        BOOL
                        |
                        IDENT {
                            usingVar($1);
                            symbolNode *variable=searchVariableInAccesibleScopes($1);
                            addCodeNode("LDV",variable->index,currentFunction);
                        }
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
        printCodeTable(currentFunction->codeTable);
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
