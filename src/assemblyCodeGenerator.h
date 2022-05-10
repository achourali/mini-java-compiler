#ifndef ASSEMBLY_CODE_GENERATOR_H
#define ASSEMBLY_CODE_GENERATOR_H

struct codeNode
{
    char *code_op;
    int operand;
    char *fctName;
    struct codeNode *previous;
    struct codeNode *next;
};
typedef struct codeNode codeNode;

void addCode(char *code_op, int operand,codeNode* codeTable);
void printCodeTable(codeNode* codeTable);


#endif