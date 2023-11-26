#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "semantics.h"
#include "y.tab.h"

int tempCount = 0;
void printArg(TACArg *a);

TreeNode* makeNode(NodeType t, int numChild, ...){
  TreeNode* newNode;
  va_list params;

  newNode = (TreeNode *) malloc(sizeof(TreeNode));
  newNode->prodRule = t;
  newNode->token = 0;
  newNode->id = NULL;
  newNode->numChild = numChild;

  newNode->children = malloc(numChild * sizeof(TreeNode**));
  va_start(params, numChild);
  for (int i = 0; i < numChild; i++) {
    newNode->children[i] = va_arg(params, TreeNode*);
  }
  va_end(params);

  return newNode;
}
 
TreeNode* generateTerminal(int token, char * const id){
  TreeNode* node;
  node = (TreeNode *) malloc(sizeof(TreeNode));
  node->prodRule = 0;
  node->token = token;

  if (id != NULL) {
    node->id = malloc(sizeof(char) * (strlen(id) + 1));
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
        while (last->next) {
          last = last->next;
        }

        genIntCode(rhs, l);
        while (last->next) {
          last = last->next;
        }
        TACList *iterRH = last;

        TACList *newTAC = malloc(sizeof(TACList));
        TACArg *out = NULL;
        if(lhs->children[0]->token == IDENTIFIER) {
          out = newArg(TA_VARIABLE, lhs->children[0]->id);
        }

        newTAC->op = TAC_ASSIGN;
        newTAC->arg1 = iterRH->result;
        newTAC->arg2 = NULL;
        newTAC->result = out;

        last->next = newTAC;

        if (nextLhs != NULL && nextRhs != NULL){
          TreeNode *new = makeNode(N_ASGN, 2, nextLhs, nextRhs);
          genIntCode(new, l);
          free(new);
        }
        break;
      }
    case N_EXPR:
    case N_CONST:
        handleExpr(p, l);
        break;
    default:
      printf("Invalid production rule detected %d", p->prodRule);
  }

  return 0;
}

TACArg* handleExpr(TreeNode* p, TACList *l){
  TACList *last = l;
  while (last->next) {
    last = last->next;
  }
  if(p->prodRule == N_EXPR && p->numChild == 3){
    /* Handle bin ops */
    TACArg *lhs = handleExpr(p->children[0], last);
    TACArg *rhs = handleExpr(p->children[2], last);
    while (last->next) {
      last = last->next;
    }
    TACList *newTAC = malloc(sizeof(TACList));
    newTAC->op = tokToOp(p->children[1]->token);
    newTAC->arg1 = lhs;
    newTAC->arg2 = rhs;
    newTAC->result = newTemp();

    last->next = newTAC;
    last = last->next;
    return newTAC->result;
  } else if (p->prodRule == N_EXPR && p->numChild == 2){
    /* Handle un ops */
    TACArg *arg = handleExpr(p->children[1], last);
    while (last->next) {
      last = last->next;
    }
    TACList *newTAC = malloc(sizeof(TACList));
    newTAC->op = tokToOp(p->children[0]->token);
    newTAC->arg1 = arg;
    newTAC->result = newTemp();

    last->next = newTAC;
    last = last->next;
    return newTAC->result;
  } else if(p->prodRule == N_CONST) {
    return newArg(TA_LITERAL, p->children[0]->id);
  } else {
    exit(1);
    printf("Invalid expr debug error\n");
    return NULL;
  }
}

TACList* handleBin(TreeNode* arg1, TreeNode* op, TreeNode* arg2){

}

TACArg* newArg(TACArgType type, char * nodeValue){
  TACArg *new = malloc(sizeof(TACArg));
  new->nodeType = type;
  new->nodeValue = nodeValue;
  return new;
}

TACArg* newTemp(){
  TACArg *newVar = malloc(sizeof(TACArg));
  newVar->nodeType = TA_VARIABLE;
  newVar->nodeValue = malloc(sizeof(char) * 10);
  bzero(newVar->nodeValue, 10);
  sprintf(newVar->nodeValue, "t%d", tempCount);

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
    default:
      printf("Invalid token %d, no corrosponding operation", token);
      exit(1);
  }
}

void printTACList(TACList *list){
  while (list) {
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

  case TAC_ASSIGN: printf("ASSIGN"); break;
  case TAC_ADD: printf("ADD"); break;
  case TAC_SUB: printf("SUB"); break;
  case TAC_MUL: printf("MUL"); break;
  case TAC_DIV: printf("DIV"); break;
  case TAC_POW: printf("POW"); break;
  case TAC_DIF: printf("DIF"); break;
  case TAC_MOD: printf("MOD"); break;
  }
}
/*
case EQUAL_TO: return TAC_EQ
case NOT_EQUAL_TO: return TAC_
case LESS_EQUAL_TO: return TAC_
case GREATER_EQUAL_TO: return TAC_
case LESS_THAN: return TAC_
case GREATER_THAN: return TAC_
case KEYWORD_AND: return TAC_
case KEYWORD_OR: return TAC_
case CONCATENATION: return TAC_
case AMPERSAND: return TAC_
case PIPE: return TAC_
case LEFT_SHIFT: return TAC_
case RIGHT_SHIFT: return TAC_
case : return TAC_
case HASH: return TAC_
case MINUS: return TAC_
case KEYWORD_NOT: return TAC_
case TILDE: return TAC_
*/
