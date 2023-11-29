#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "semantics.h"
#include "y.tab.h"

int tempCount = 0;
int labelCount = 0;
void printArg(TACArg *a);

TreeNode* makeNode(NodeType t, int numChild, ...){
  TreeNode* newNode;
  va_list params;

  newNode = (TreeNode *) calloc(1, sizeof(TreeNode));
  newNode->prodRule = t;
  newNode->token = 0;
  newNode->id = NULL;
  newNode->numChild = numChild;

  newNode->children = calloc(numChild, sizeof(TreeNode**));
  va_start(params, numChild);
  for (int i = 0; i < numChild; i++) {
    newNode->children[i] = va_arg(params, TreeNode*);
  }
  va_end(params);

  return newNode;
}
 
TreeNode* generateTerminal(int token, char * const id){
  TreeNode* node;
  node = (TreeNode *) calloc(1, sizeof(TreeNode));
  node->prodRule = 0;
  node->token = token;

  if (id != NULL) {
    node->id = malloc((strlen(id) + 1) * sizeof(char) );
    strcpy(node->id, id);
  } else {
    node->id = NULL;
  }

  node->numChild = 0;
  node->children = NULL;

  return node;
}

#define genChildrens(root,f) \
  for(int i = 0; i < root->numChild; i++)\
    genIntCode(root->children[i], f);

int genIntCode(TreeNode *p, TACList *l){
  if (p == NULL || p->prodRule == NONE)
    return 0;

  switch(p->prodRule){
    case N_PRG:
      genChildrens(p, l);
      break;
    case N_STMTS:
      genChildrens(p, l);
      break;
    case N_ASGN: {
        TreeNode* lhs     = NULL;
        TreeNode* nextLhs = NULL;
        TreeNode* rhs     = NULL;
        TreeNode* nextRhs = NULL;

        if (p->children[0]->prodRule == N_LVALUE){
          lhs = p->children[0]->children[0];
          nextLhs = p->children[0]->children[1];
        }
        else {
          lhs = p->children[0];
          nextLhs = NULL;
        }

        if (p->children[1]->prodRule == N_EXPRS) {
          rhs = p->children[1]->children[0];
          nextRhs = p->children[1]->children[1];
        }
        else {
          rhs = p->children[1];
          nextRhs = NULL;
        }

        TACList *last = l;
        while (last->next) { last = last->next; }

        genIntCode(rhs, l);
        while (last->next) { last = last->next; }
        TACList *iterRH = last;

        TACList *nTAC;
        TACArg *out = NULL;
        if(lhs->children[0]->token == IDENTIFIER) {
          out = newArg(TA_VARIABLE, lhs->children[0]->id);
        }

        nTAC = newTAC(TAC_ASGN, iterRH->result, NULL, out, NULL);
        last->next = nTAC;

        if (nextLhs != NULL && nextRhs != NULL){
          TreeNode *new = makeNode(N_ASGN, 2, nextLhs, nextRhs);
          genIntCode(new, l);
          free(new);
        }
        break;
      }
    case N_EXPR:
        handleExpr(p, l);
        break;
    case N_CONST:
    case N_VAR:
      {
        TACArg *res = handleExpr(p, l);
        TACList *nTAC;
        TACList *last = l;

        while (last->next) { last = last->next; }

        nTAC = newTAC(TAC_NOP, NULL, NULL, res, NULL);
        last->next = nTAC;
        last = last->next;

        break;
      }
    case N_IFBLOCK:{
        handleIf(p, l, NULL, NULL);
        break;
      }
    case N_WHILE: {
        TACList *last = l;
        TACArg *begin, *end;
        TACList *nTAC;

        while (last->next) { last = last->next; }
        genIntCode(p->children[0], last);
        last->next->label = newLabel();
        begin = last->next->label;
        while (last->next) { last = last->next; }

        nTAC = newTAC(TAC_GO_IF_FALSE, last->result, NULL, newLabel(), NULL);
        end = nTAC->result;
        last->next = nTAC;
        last = last->next;

        genIntCode(p->children[1], last);
        while (last->next) { last = last->next; }

        nTAC = newTAC(TAC_GOTO, NULL, NULL, begin, NULL);
        last->next = nTAC;
        last = last->next;

        nTAC = newTAC(TAC_NOP, NULL, NULL, NULL, end);
        last->next = nTAC;
        last = last->next;
      }
    default:
      printf("Invalid production rule detected %d\n", p->prodRule);
  }

  return 0;
}

TACArg* handleExpr(TreeNode* p, TACList *l){
  TACList *last = l;
  while (last->next) { last = last->next; }
  if(p->prodRule == N_EXPR && p->numChild == 3){
    /* Handle bin ops */
    TACList *nTAC;
    TACArg *lhs = handleExpr(p->children[0], last);
    TACArg *rhs = handleExpr(p->children[2], last);
    while (last->next) { last = last->next; }

    nTAC = newTAC(tokToOp(p->children[1]->token), lhs, rhs, newTemp(), NULL);
    last->next = nTAC;
    last = last->next;

    return nTAC->result;
  } else if (p->prodRule == N_EXPR && p->numChild == 2){
    /* Handle un ops */
    TACList *nTAC;
    TACArg *arg = handleExpr(p->children[1], last);
    while (last->next) { last = last->next; }

    nTAC = newTAC(tokToOp(p->children[0]->token), arg, NULL, newTemp(), NULL);
    last->next = nTAC;
    last = last->next;

    return nTAC->result;
  } else if(p->prodRule == N_CONST) {
    return newArg(TA_LITERAL, p->children[0]->id);
  } else if(p->prodRule == N_VAR){
    return newArg(TA_VARIABLE, p->children[0]->id);
  } else {
    printf("Invalid expr debug error\n");
    exit(1);
    return NULL;
  }
}

TACArg* handleIf(TreeNode* p, TACList *l, TACArg *begin, TACArg *end){
  TACList *last = l;
  TACArg *res, *nextBegin;
  TACList *nTAC;

  while (last->next) { last = last->next; }

  if (p->prodRule == N_IFBLOCK){
    /* Condition */
    res = handleExpr(p->children[0], l);
    last->next->label = begin;

    while (last->next) { last = last->next; }

    nTAC = newTAC(TAC_GO_IF_FALSE, res, NULL, newLabel(), NULL);
    nextBegin = nTAC->result;

    last->next = nTAC;
    last = last->next;

    /* then block */
    genIntCode(p->children[1], last);
    while (last->next) { last = last->next; }

    /* Goto end */
    nTAC = newTAC(TAC_GOTO, NULL, NULL, end ? end : newLabel(), NULL);
    end = nTAC->result;

    last->next = nTAC;
    last = last->next;

    handleIf(p->children[2], l, nextBegin, end);
  }
  else if (p->prodRule == N_ELSE) {
    while (last->next) { last = last->next; }
    genIntCode(p->children[0], last);
    last->next->label = begin;

    while (last->next) { last = last->next; }

    nTAC = newTAC(TAC_NOP, NULL, NULL, NULL, end);
    last->next = nTAC;
    last = last->next;

  }
  else if (p->token == KEYWORD_END){
    /** no else block */
    nTAC = newTAC(TAC_NOP, NULL, NULL, NULL, begin);
    last->next = nTAC;
    last = last->next;

    nTAC = newTAC(TAC_NOP, NULL, NULL, NULL, end);
    last->next = nTAC;
    last = last->next;
  }

  return NULL;
}

TACList* newTAC(TACType op,
                TACArg *arg1,
                TACArg *arg2,
                TACArg *result,
                TACArg *label
               )
{
  TACList *newTAC = calloc(1, sizeof(TACList));
  newTAC->op = op;
  newTAC->arg1 = arg1;
  newTAC->arg2 = arg2;
  newTAC->result = result;
  newTAC->label = label;

  return newTAC;
}

TACArg* newArg(TACArgType type, char * nodeValue){
  TACArg *new = calloc(1, sizeof(TACArg));
  new->nodeType = type;
  new->nodeValue = strdup(nodeValue);
  return new;
}

TACArg* newTemp(){
  TACArg *newVar = calloc(1, sizeof(TACArg));
  newVar->nodeType = TA_VARIABLE;
  newVar->nodeValue = malloc(sizeof(char) * 10);
  bzero(newVar->nodeValue, 10);
  sprintf(newVar->nodeValue, "t%d", tempCount);
  tempCount++;

  return newVar;
}

TACArg* newLabel(){
  TACArg *newVar = calloc(1, sizeof(TACArg));
  newVar->nodeType = TA_LABEL;
  newVar->nodeValue = malloc(sizeof(char) * 10);
  bzero(newVar->nodeValue, 10);
  sprintf(newVar->nodeValue, "L%d", labelCount);
  labelCount++;

  return newVar;
}

TACType tokToOp(int token){
  switch (token) {
    case PLUS: return TAC_ADD;
    case MINUS: return TAC_SUB;
    case ASTERISK: return TAC_MUL;
    case DIVIDE: return TAC_DIV;
    case CARET: return TAC_POW;
    case FLOOR_DIVISION: return TAC_DIF;
    case MOD: return TAC_MOD;
    case EQUAL_TO: return TAC_EQ;
    case NOT_EQUAL_TO: return TAC_NEQ;
    case LESS_EQUAL_TO: return TAC_LEQ;
    case GREATER_EQUAL_TO: return TAC_GEQ;
    case LESS_THAN: return TAC_LT;
    case GREATER_THAN: return TAC_GT;
    case KEYWORD_AND: return TAC_AND;
    case KEYWORD_OR: return TAC_OR;
    case CONCATENATION: return TAC_CNCT;
    case AMPERSAND: return TAC_AMPS;

    default:
      printf("Invalid token %d, no corrosponding operation", token);
      exit(1);
  }
}

void printTACList(TACList *list){
  while (list) {
    printArg(list->label);
    printf(":\t\t");
    printOp(list->op);
    printf("\t\t");
    printArg(list->arg1);
    printf("\t\t");
    printArg(list->arg2);
    printf("\t\t");
    printArg(list->result);
    printf("\n");
    list = list->next;
  }
}

void printArg(TACArg *a){
  if(a && a->nodeValue)
    printf("%s", a->nodeValue);
}
void printOp(TACType op){
  switch (op) {

    case TAC_NOP:  printf("NOP");  break;
    case TAC_ASGN: printf("ASGN"); break;
    case TAC_ADD:  printf("ADD");  break;
    case TAC_SUB:  printf("SUB");  break;
    case TAC_MUL:  printf("MUL");  break;
    case TAC_DIV:  printf("DIV");  break;
    case TAC_POW:  printf("POW");  break;
    case TAC_DIF:  printf("DIF");  break;
    case TAC_MOD:  printf("MOD");  break;
    case TAC_EQ:   printf("EQ");   break;
    case TAC_NEQ:  printf("NEQ");  break;
    case TAC_LEQ:  printf("LEQ");  break;
    case TAC_GEQ:  printf("GEQ");  break;
    case TAC_LT:   printf("LT");   break;
    case TAC_GT:   printf("GT");   break;
    case TAC_AND:  printf("AND");  break;
    case TAC_OR:   printf("OR");   break;
    case TAC_CNCT: printf("CNCT"); break;
    case TAC_AMPS: printf("AMPS"); break;

    case TAC_GOTO: printf("GOTO"); break;
    case TAC_GO_IF_FALSE: printf("IF_NOT"); break;

  }
}
/*
case PIPE: return TAC_
case LEFT_SHIFT: return TAC_
case RIGHT_SHIFT: return TAC_
case : return TAC_
case HASH: return TAC_
case MINUS: return TAC_
case KEYWORD_NOT: return TAC_
case TILDE: return TAC_
*/
