#ifndef ASSEMBLY_CODE_GENERATOR_H
#define ASSEMBLY_CODE_GENERATOR_H

#include "semanticAnalyser.h"

struct codeNode
{
    int index;
    char *code_op;
    int operand;
    char *fctName;
    struct codeNode *previous;
    struct codeNode *next;
    struct symbolNode *calledFunctionIndex;
};
typedef struct codeNode codeNode;
typedef struct symbolNode symbolNode;

struct whileNode
{
    struct whileNode *previous;
    int startingConditionIndex;
};
typedef struct whileNode whileNode;

codeNode *addCodeNode(char *code_op, int operand, symbolNode *functionNode,int calledFunctionIndex);
void printCodeTable(symbolNode *functionNode);
void updateLastSIFAUX();
void updateLastSAUT();
void addWhileNode(int startingConditionIndex);
int getLastCodeNodeIndex();
whileNode *getLatestWhileNode();
void updateLastTantQueFaux();
void printAllCodeTables();
void generateMainCode();

#endif