#ifndef SEMANTIC_ANALYSER_H

struct node
{
    char *name;
    char *nature;
    char *type;
    int isInitialised;
    int isUsed;
    struct argumentNode *args;
    struct scope *scope;
    struct node *next;
};

typedef struct node node;

struct argumentNode{
    char* type;
    struct argumentNode * next;
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
node *searchVaribleInScope(char *varName, scope *scope);
void initVar(char *varName);
void usingVar(char *varName);
int checkIfAllVarsAreUsed();
void addFunction(char *name, char *returnType);
void clearParametersTypesList();
void addParameterType(char* type);
void clearArgumentsList();
void addArgumentTypeFromName(char* varName);
void addArgumentType(char* type);
void callFunction(char* functionName);
node *searchFunctionInScope(char *varName);

#endif