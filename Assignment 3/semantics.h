#ifndef SEMANTICS_STRUCTURES
#define SEMANTICS_STRUCTURES
#include <stdbool.h>
#include <stdio.h>

typedef enum _NodeType {
  NONE = 0,
  N_PRG,
  N_STMTS,
  N_STMT,
  N_ASGN,
  N_EXPRS,
  N_LVALUE,
  N_EXPR,
  N_VAR,
  N_CONST,
} NodeType;

typedef struct _Node{
  NodeType prodRule;
  int      token;
  char*    id; // This is required for all token in order to throw errors
  int      numChild;
  struct _Node**   children;
} TreeNode;

typedef struct _LuaTable{

} LuaTable;

typedef enum _VarType{
  VARTYPE_NIL,
  VARTYPE_NUM,
  VARTYPE_BOOL,
  VARTYPE_STR,
  VARTYPE_TABLE,
} VarType;

typedef struct _VarList{
  char*   name;
  VarType type;
  union{
    float     num;
    bool      boolean;
    char*     str;
    LuaTable* table;
  };
  struct _VarList* next;
} VarList;

typedef enum _TACArgType{
  TA_NULL,
  TA_BEGIN,
  TA_LITERAL,
  TA_VARIABLE
} TACArgType;

typedef struct _TACArg{
  TACArgType nodeType;
  char *nodeValue;
  /* char *datatype; */
} TACArg;

typedef enum _TACType {
  TAC_ASSIGN,
  TAC_ADD,
  TAC_SUB,
  TAC_MUL,
  TAC_DIV,
  TAC_POW,
  TAC_DIF,
  TAC_MOD,
} TACType;

typedef struct _TACList{
  TACType    op;
  TACArg     *arg1, *arg2, *result;
  struct _TACList *next;
} TACList;

TreeNode* makeNode         (NodeType t, int numChild, ...);
TreeNode* generateTerminal (int token, char * const id);
int       genIntCode       (TreeNode *root, TACList *f);
int       newVar           (VarList* list, VarType type);
TACArg* newArg(TACArgType type, char * nodeValue);
TACArg* newTemp();
TACArg* handleExpr(TreeNode* p, TACList *l);
TACList* handleBin(TreeNode* arg1, TreeNode* op, TreeNode* arg2);
TACType tokToOp(int token);
void printOp(TACType op);

#endif
