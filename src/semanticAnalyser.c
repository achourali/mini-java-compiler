#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "semanticAnalyser.h"

int idCounter = 0;
scope *currentLocalScope = NULL;
scope *currentMemberScope = NULL;
node *symbolicTable = NULL;
argumentNode *argumentsList = NULL;
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
            node *varWithSameName = searchVaribleInScope(name, tempScope);
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
        node *varWithSameName = searchVaribleInScope(name, currentMemberScope);
        if (varWithSameName != NULL)
        {
            printf("Error on line %d : %s.\n\n", lineno, "Variable already declared ");
            errors++;
            return;
        }
    }

    node *newNode = (node *)malloc(sizeof(node));

    newNode->name = name;
    newNode->nature = "VARIABLE";
    newNode->type = type;
    newNode->isInitialised = 0;
    newNode->isUsed = 0;
    newNode->args = NULL;

    if (currentLocalScope != NULL)
        newNode->scope = currentLocalScope;
    else
        newNode->scope = currentMemberScope;

    if (symbolicTable == NULL)
        symbolicTable = newNode;
    else
    {
        node *tempNode = symbolicTable;
        while (tempNode->next != NULL)
        {
            tempNode = tempNode->next;
        }

        tempNode->next = newNode;
    }
}
node *searchVaribleInScope(char *varName, scope *scope)
{
    node *tempNode = symbolicTable;
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

node *searchVariableInAccesibleScopes(char *varName)
{
    node *varWithSameName = NULL;

    scope *tempScope = currentLocalScope;
    while (tempScope != NULL)
    {
        node *varWithSameName = searchVaribleInScope(varName, tempScope);
        if (varWithSameName != NULL)

            return varWithSameName;

        tempScope = tempScope->parent;
    }

    if (varWithSameName == NULL)
        varWithSameName = searchVaribleInScope(varName, currentMemberScope);

    return varWithSameName;
}

void initVar(char *varName)
{
    node *tempNode = symbolicTable;
    while (tempNode != NULL)
    {
        if (
            strcmp(tempNode->name, varName) == 0 &&
            strcmp(tempNode->nature, "VARIABLE") == 0)
        {
            tempNode->isInitialised = 1;
            break;
        }

        tempNode = tempNode->next;
    }
};

void usingVar(char *varName)
{
    node *var = searchVariableInAccesibleScopes(varName);
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

        printf("Error on line %d : %s.\n\n", lineno, "Variable used but not initialised ");
        errors++;
    }
};

int checkIfAllVarsAreUsed()
{

    node *tempNode = symbolicTable;
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

void addFunction(char *name, char *returnType)
{
    printf("adding function %s %s :\n",returnType, name);
    
    node *newNode = (node *)malloc(sizeof(node));

    newNode->name = name;
    newNode->nature = "FUNCTION";
    newNode->type = returnType;
    newNode->isInitialised = 0;
    newNode->isUsed = 0;
    newNode->args = argumentsList;

    newNode->scope = currentMemberScope;

    if (symbolicTable == NULL)
        symbolicTable = newNode;
    else
    {
        node *tempNode = symbolicTable;
        while (tempNode->next != NULL)
        {
            tempNode = tempNode->next;
        }

        tempNode->next = newNode;
    }
    
}

void clearArgumentsTypesList()
{
    argumentsList = NULL;
}
void addArgumentType(char *type)
{
    argumentNode *argument = (argumentNode *)malloc(sizeof(argumentNode));
    argument->type = type;
    argument->next = NULL;
    if (argumentsList == NULL)
        argumentsList = argument;
    else
    {
        argumentNode *tempArgument = argumentsList;
        while (tempArgument->next != NULL)
        {
            tempArgument = tempArgument->next;
        }
        tempArgument->next = argument;
    }
}

void printSymbolicTable()
{

    printf("\n\n------------Symbolic table----------\n");
    node *tempNode = symbolicTable;
    printf("%-6s%-10s%-7s%-5s%-5s%-8s%s\n", "name", "nature", "type", "init", "used", "scopeId","args");

    while (tempNode != NULL)
    {
        printf("%-6s%-10s%-7s%-5d%-5d%-8d", tempNode->name, tempNode->nature, tempNode->type, tempNode->isInitialised, tempNode->isUsed, tempNode->scope->id);
        argumentNode* tempArg=tempNode->args;
        while(tempArg!=NULL){
            printf("%s,",tempArg->type);
            tempArg=tempArg->next;
        }

        printf("\n");
        tempNode = tempNode->next;
    }
}