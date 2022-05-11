#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "semanticAnalyser.h"

int idCounter = 0;
scope *currentLocalScope = NULL;
scope *currentMemberScope = NULL;
symbolNode *symbolicTable = NULL;
argumentNode *parametersTypesList = NULL;
argumentNode *argumentsTypesList = NULL;
extern int lineno;
extern int errors;

void enterLocalScope()
{
    scope *child = (scope *)malloc(sizeof(scope));
    child->id = idCounter++;
    if (currentLocalScope != NULL)
        currentLocalScope->child = child;
    child->parent = currentLocalScope;
    child->child = NULL;
    currentLocalScope = child;
    // printf("entering LOCAL scope %d\n", child->id);
}

void exitCurrentLocalScope()
{
    // printf("exiting LOCAL scope %d\n", currentLocalScope->id);
    currentLocalScope = currentLocalScope->parent;
}

void enterMemberScope()
{
    currentMemberScope = (scope *)malloc(sizeof(scope));
    currentMemberScope->id = idCounter++;
}

void exitCurrentMemberScope()
{
    currentMemberScope = NULL;
}

void addVariable(char *name, char *type)
{
    if (currentLocalScope != NULL)
    {
        scope *tempScope = currentLocalScope;
        while (tempScope != NULL)
        {
            symbolNode *varWithSameName = searchVaribleInScope(name, tempScope);
            if (varWithSameName != NULL)
            {

                printf("Error on line %d : %s.\n\n", lineno, "Variable already declared ");
                errors++;
                return;
            }
            tempScope = tempScope->parent;
        }
    }
    else
    {
        symbolNode *varWithSameName = searchVaribleInScope(name, currentMemberScope);
        if (varWithSameName != NULL)
        {
            printf("Error on line %d : %s.\n\n", lineno, "Variable already declared ");
            errors++;
            return;
        }
    }

    symbolNode *newNode = (symbolNode *)malloc(sizeof(symbolNode));

    newNode->name = name;
    newNode->nature = "VARIABLE";
    newNode->type = type;
    newNode->isInitialised = 0;
    newNode->isUsed = 0;
    newNode->args = NULL;
    newNode->codeTable = NULL;

    if (currentLocalScope != NULL)
        newNode->scope = currentLocalScope;
    else
        newNode->scope = currentMemberScope;

    if (symbolicTable == NULL)
    {
        newNode->index = 0;
        symbolicTable = newNode;
    }
    else
    {
        symbolNode *tempNode = symbolicTable;
        while (tempNode->next != NULL)
        {
            tempNode = tempNode->next;
            newNode->index = tempNode->index;
        }
        newNode->index++;

        tempNode->next = newNode;
    }
}
symbolNode *searchVaribleInScope(char *varName, scope *scope)
{
    symbolNode *tempNode = symbolicTable;
    while (tempNode != NULL)
    {
        if (
            strcmp(tempNode->name, varName) == 0 &&
            strcmp(tempNode->nature, "VARIABLE") == 0 &&
            tempNode->scope == scope)
            return tempNode;
        tempNode = tempNode->next;
    }
    return NULL;
}

symbolNode *searchVariableInAccesibleScopes(char *varName)
{
    symbolNode *varWithSameName = NULL;

    scope *tempScope = currentLocalScope;
    while (tempScope != NULL)
    {
            varWithSameName = searchVaribleInScope(varName, tempScope);
        if (varWithSameName != NULL)
        {
            break;
        }

        tempScope = tempScope->parent;
    }

    if (varWithSameName == NULL)
        varWithSameName = searchVaribleInScope(varName, currentMemberScope);


    return varWithSameName;
}

void initVar(char *varName)
{
    symbolNode *var = searchVariableInAccesibleScopes(varName);
    if (var)
        var->isInitialised = 1;
};

void usingVar(char *varName)
{
    symbolNode *var = searchVariableInAccesibleScopes(varName);
    if (var == NULL)
    {
        printf("Error on line %d : %s.\n\n", lineno, "Variable is not declared ");
        errors++;
        return;
    }
    if (var->isInitialised)
        var->isUsed = 1;
    else
    {

        printf("Error on line %d : Variable %s used but not initialised .\n\n", lineno, varName);
        errors++;
    }
};

int checkIfAllVarsAreUsed()
{

    symbolNode *tempNode = symbolicTable;
    while (tempNode != NULL)
    {
        if (strcmp(tempNode->nature, "VARIABLE") == 0 && tempNode->isUsed == 0)
        {
            printf("Error on line %d : Variable '%s' declared but not used .\n\n", lineno, tempNode->name);
            errors++;
            return 0;
        }
        tempNode = tempNode->next;
    }
    return 1;
}

symbolNode *addFunction(char *name, char *returnType)
{

    symbolNode *newNode = (symbolNode *)malloc(sizeof(symbolNode));

    newNode->name = name;
    newNode->nature = "FUNCTION";
    newNode->type = returnType;
    newNode->isInitialised = 0;
    newNode->isUsed = 0;
    newNode->args = parametersTypesList;
    newNode->scope = currentMemberScope;
    newNode->codeTable = NULL;

    if (symbolicTable == NULL)
    {
        symbolicTable = newNode;
        newNode->index = 0;
    }
    else
    {
        symbolNode *tempNode = symbolicTable;
        while (tempNode->next != NULL)
        {
            tempNode = tempNode->next;
            newNode->index = tempNode->index;
        }
        newNode->index++;
        tempNode->next = newNode;
    }
    return newNode;
}

void clearParametersTypesList()
{
    parametersTypesList = NULL;
}
void addParameterType(char *type)
{
    argumentNode *parameter = (argumentNode *)malloc(sizeof(argumentNode));
    parameter->type = type;
    parameter->next = NULL;
    if (parametersTypesList == NULL)
        parametersTypesList = parameter;
    else
    {
        parameter->next = parametersTypesList;
        parametersTypesList = parameter;
    }
}

void clearArgumentsList()
{
    argumentsTypesList = NULL;
};

void addArgumentType(char *type)
{
    argumentNode *argument = (argumentNode *)malloc(sizeof(argumentNode));
    argument->type = type;
    argument->next = NULL;
    if (argumentsTypesList == NULL)
        argumentsTypesList = argument;
    else
    {
        argument->next = argumentsTypesList;
        argumentsTypesList = argument;
    }
}

void addArgumentTypeFromName(char *varName)
{
    symbolNode *var = searchVariableInAccesibleScopes(varName);
    if (var)
        addArgumentType(var->type);
    else
    {
        printf("Error on line %d : could not find variable '%s'  .\n\n", lineno, varName);
        errors++;
    }
}

symbolNode* callFunction(char *functionName)
{
    symbolNode *function = searchFunctionInScope(functionName);

    if (!function)
    {
        printf("Error on line %d : could not find function '%s'  .\n\n", lineno, functionName);
        errors++;
        return;
    }

    argumentNode *tempArg = argumentsTypesList;
    argumentNode *tempParam = function->args;
    while (tempArg != NULL && tempParam != NULL)
    {
        if (strcmp(tempArg->type, tempParam->type) != 0)
        {
            printf("Error on line %d : arguments type error when calling function '%s'  .\n\n", lineno, functionName);
            errors++;
            return;
        };
        tempArg = tempArg->next;
        tempParam = tempParam->next;
    }
    if (tempArg != NULL || tempParam != NULL)
    {
        printf("Error on line %d : number of arguments error when calling function '%s'  .\n\n", lineno, functionName);
        errors++;
        return;
    }
    return function;
}

symbolNode *searchFunctionInScope(char *varName)
{
    symbolNode *tempNode = symbolicTable;
    while (tempNode != NULL)
    {
        if (
            strcmp(tempNode->name, varName) == 0 &&
            strcmp(tempNode->nature, "FUNCTION") == 0 &&
            tempNode->scope == currentMemberScope)
            return tempNode;
        tempNode = tempNode->next;
    }
    return NULL;
}

void printSymbolicTable()
{

    printf("\n\n------------Symbolic table-------------------\n\n");
    symbolNode *tempNode = symbolicTable;
    printf("%-3s%-6s%-10s%-7s%-5s%-5s%-8s%s\n", "id", "name", "nature", "type", "init", "used", "scopeId", "args");

    while (tempNode != NULL)
    {
        printf("%-3d%-6s%-10s%-7s%-5d%-5d%-8d", tempNode->index, tempNode->name, tempNode->nature, tempNode->type, tempNode->isInitialised, tempNode->isUsed, tempNode->scope->id);
        argumentNode *tempArg = tempNode->args;
        while (tempArg != NULL)
        {
            printf("%s,", tempArg->type);
            tempArg = tempArg->next;
        }

        printf("\n");
        tempNode = tempNode->next;
    }

    printf("\n\n------------End of symbolic table------------\n");
}