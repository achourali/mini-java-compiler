#ifndef SEMANTIC_ANALYSER_H
#define SEMANTIC_ANALYSER_H

#include "assemblyCodeGenerator.h"

struct symbolNode
{
    int index;
    char *name;
    char *nature;
    char *type;
    int isInitialised;
    int isUsed;
    struct argumentNode *args;
    struct scope *scope;
    struct symbolNode *next;
    struct codeNode *codeTable;
};

typedef struct symbolNode symbolNode;

struct argumentNode
{
    char *type;
    struct argumentNode *next;
};
typedef struct argumentNode argumentNode;

struct scope
{
    int id;
    struct scope *parent;
    struct scope *child;
};
typedef struct scope scope;

void enterLocalScope();
void exitCurrentLocalScope();
void addVariable(char *name, char *type);
void printSymbolicTable();
void enterMemberScope();
void exitCurrentMemberScope();
void test();
symbolNode *searchVaribleInScope(char *varName, scope *scope);
void initVar(char *varName);
void usingVar(char *varName);
int checkIfAllVarsAreUsed();
symbolNode *addFunction(char *name, char *returnType);
void clearParametersTypesList();
void addParameterType(char *type);
void clearArgumentsList();
void addArgumentTypeFromName(char *varName);
void addArgumentType(char *type);
symbolNode *callFunction(char *functionName);
symbolNode *searchFunctionInScope(char *varName);
symbolNode *searchVariableInAccesibleScopes(char *varName);

#endif