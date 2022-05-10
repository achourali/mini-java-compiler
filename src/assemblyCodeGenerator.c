#include "assemblyCodeGenerator.h"
#include <stdio.h>
#include "semanticAnalyser.h"

symbolNode *currentFunction = NULL;

void addCodeNode(char *code_op, int operand, symbolNode *functionNode)
{
    codeNode *newCodeNode = (codeNode *)malloc(sizeof(codeNode));
    newCodeNode->code_op = code_op;
    newCodeNode->operand = operand;
    newCodeNode->fctName = functionNode->name;
    if (functionNode->codeTable == NULL)
    {
        functionNode->codeTable = newCodeNode;
    }
    else
    {
        codeNode *temp = functionNode->codeTable;
        while (temp->next != NULL)
            temp = temp->next;
        temp->next = newCodeNode;
    }
}

void printCodeTable(codeNode *codeTable)
{

    printf("\n\n------------Code table-------------------\n\n");
    codeNode *temp = codeTable;
    printf("%-10s%-9s%-7s\n","operator","operand","fctName");
    while (temp != NULL)
    {
        printf("%-10s%-9d%-7s\n", temp->code_op,temp->operand,temp->fctName);
        temp = temp->next;
    }

    printf("\n\n------------End of Code table------------\n");
}