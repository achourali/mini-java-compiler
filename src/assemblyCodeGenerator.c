#include "assemblyCodeGenerator.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "semanticAnalyser.h"

symbolNode *currentFunction = NULL;
whileNode *whileNodesList = NULL;

codeNode *addCodeNode(char *code_op, int operand, symbolNode *functionNode)
{
    codeNode *newCodeNode = (codeNode *)malloc(sizeof(codeNode));
    newCodeNode->code_op = code_op;
    newCodeNode->operand = operand;
    newCodeNode->fctName = functionNode->name;
    newCodeNode->previous = NULL;
    newCodeNode->next = NULL;
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

void printCodeTable(codeNode *codeTable)
{

    printf("\n\n------------Code table-------------------\n\n");
    codeNode *temp = codeTable;
    printf("%-4s%-13s%-9s%-7s\n", "id", "operator", "operand", "fctName");
    while (temp != NULL)
    {
        printf("%-4d%-13s%-9d%-7s\n", temp->index, temp->code_op, temp->operand, temp->fctName);
        temp = temp->next;
    }

    printf("\n\n------------End of Code table------------\n");
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


whileNode* getLatestWhileNode(){
    whileNode* latestWhileNode=whileNodesList;
    whileNodesList=whileNodesList->previous;
    return latestWhileNode;
}

void updateLastTantQueFaux(){


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