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
};
typedef struct codeNode codeNode;
typedef struct symbolNode symbolNode;

codeNode *addCodeNode(char *code_op, int operand,symbolNode* functionNode);
void printCodeTable(codeNode* codeTable);
void updateLastSIFAUX();
void updateLastSAUT();


#endif