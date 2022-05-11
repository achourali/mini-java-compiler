#include "assemblyCodeGenerator.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "semanticAnalyser.h"

symbolNode *currentFunction = NULL;
symbolNode *mainFunction = NULL;
whileNode *whileNodesList = NULL;
extern symbolNode *symbolicTable;

codeNode *addCodeNode(char *code_op, int operand, symbolNode *functionNode, int calledFunctionIndex)
{
    codeNode *newCodeNode = (codeNode *)malloc(sizeof(codeNode));
    newCodeNode->code_op = code_op;
    newCodeNode->operand = operand;
    newCodeNode->previous = NULL;
    newCodeNode->next = NULL;
    newCodeNode->calledFunctionIndex = calledFunctionIndex;
    if (functionNode->codeTable == NULL)
    {
        newCodeNode->index = 0;
        functionNode->codeTable = newCodeNode;
    }
    else
    {
        codeNode *temp = functionNode->codeTable;
        while (temp->next != NULL)
            temp = temp->next;
        newCodeNode->index = temp->index + 1;
        newCodeNode->previous = temp;
        temp->next = newCodeNode;
    }
    return newCodeNode;
}

symbolNode *getMainFunction()
{

    symbolNode *tempNode = symbolicTable;

    while (tempNode != NULL)
    {
        if (strcmp(tempNode->name, "main") == 0)
        {

            return tempNode;
        }
        tempNode = tempNode->next;
    }
}
void generateMainCode()
{

    symbolNode *mainFunction = getMainFunction();
    codeNode *mainCodeNode = mainFunction->codeTable;
    while (mainCodeNode != NULL)
    {
        if (strcmp(mainCodeNode->code_op, "APPEL") == 0)
        {
            symbolNode *calledFunction = getByIndex(mainCodeNode->calledFunctionIndex);
            codeNode *functionCodeNode = calledFunction->codeTable;
            int appelJumpIndex = addCodeNode(functionCodeNode->code_op, functionCodeNode->operand, mainFunction, functionCodeNode->calledFunctionIndex)->index;
            functionCodeNode = functionCodeNode->next;
            while (functionCodeNode != NULL)
            {
                addCodeNode(functionCodeNode->code_op, functionCodeNode->operand, mainFunction, functionCodeNode->calledFunctionIndex);
                functionCodeNode = functionCodeNode->next;
            }
            mainCodeNode->operand=appelJumpIndex;
            addCodeNode("RETOUR", mainCodeNode->index + 1, mainFunction, -1);
        }
        mainCodeNode = mainCodeNode->next;
    }

    printCodeTable(mainFunction);
}

void printCodeTable(symbolNode *functionNode)
{

    codeNode *temp = functionNode->codeTable;
    printf("\n\n------------Code table of %s-----------\n\n", functionNode->name);
    printf("%-4s%-13s%-9s%-7s\n", "id", "operator", "operand", "call fct");
    while (temp != NULL)
    {
        printf("%-4d%-13s%-9d%-5d\n", temp->index, temp->code_op, temp->operand, temp->calledFunctionIndex);
        temp = temp->next;
    }

    printf("\n\n------------End of Code table------------\n");
}

void printAllCodeTables()
{

    symbolNode *tempNode = symbolicTable;

    while (tempNode != NULL)
    {
        if (strcmp(tempNode->nature, "FUNCTION") == 0)
            printCodeTable(tempNode);
        tempNode = tempNode->next;
    }
}

void updateLastSIFAUX()
{

    codeNode *temp = currentFunction->codeTable;
    codeNode *lastSiFauxNode = NULL;
    while (temp->next != NULL)
    {
        if (strcmp(temp->code_op, "SIFAUX") == 0 && temp->operand == -1)
            lastSiFauxNode = temp;
        temp = temp->next;
    }

    lastSiFauxNode->operand = temp->index + 1;
}

void updateLastSAUT()
{

    codeNode *temp = currentFunction->codeTable;
    codeNode *lastSiFauxNode = NULL;
    while (temp->next != NULL)
    {
        if (strcmp(temp->code_op, "SAUT") == 0 && temp->operand == -1)
            lastSiFauxNode = temp;
        temp = temp->next;
    }

    lastSiFauxNode->operand = temp->index + 1;
}

void addWhileNode(int startingConditionIndex)
{
    whileNode *newWhileNode = (whileNode *)malloc(sizeof(whileNode));
    newWhileNode->startingConditionIndex = startingConditionIndex;
    newWhileNode->previous = NULL;

    if (whileNodesList == NULL)
        whileNodesList = newWhileNode;
    else
    {
        newWhileNode->previous = whileNodesList;
        whileNodesList = newWhileNode;
    }
}
int getLastCodeNodeIndex()
{

    codeNode *temp = currentFunction->codeTable;
    while (temp->next != NULL)
    {
        temp = temp->next;
    }
    return temp->index;
}

whileNode *getLatestWhileNode()
{
    whileNode *latestWhileNode = whileNodesList;
    whileNodesList = whileNodesList->previous;
    return latestWhileNode;
}

void updateLastTantQueFaux()
{

    codeNode *temp = currentFunction->codeTable;
    codeNode *lastSiFauxNode = NULL;
    while (temp->next != NULL)
    {
        if (strcmp(temp->code_op, "TANTQUEFAUX") == 0 && temp->operand == -1)
            lastSiFauxNode = temp;
        temp = temp->next;
    }

    lastSiFauxNode->operand = temp->index + 1;
}