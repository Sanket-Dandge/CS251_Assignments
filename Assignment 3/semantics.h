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
  N_IFBLOCK,
  N_ELSE,
  N_WHILE,
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
  TA_VARIABLE,
  TA_LABEL,
} TACArgType;

typedef struct _TACArg{
  TACArgType nodeType;
  char *nodeValue;
  /* char *datatype; */
} TACArg;

typedef enum _TACType {
  TAC_NOP,
  TAC_ASGN,
  TAC_ADD,
  TAC_SUB,
  TAC_MUL,
  TAC_DIV,
  TAC_POW,
  TAC_DIF,
  TAC_MOD,
  TAC_EQ,
  TAC_NEQ,
  TAC_LEQ,
  TAC_GEQ,
  TAC_LT,
  TAC_GT,
  TAC_AND,
  TAC_OR,
  TAC_CNCT,
  TAC_AMPS,

  TAC_GOTO,
  TAC_GO_IF_FALSE,
} TACType;

typedef struct _TACList{
  TACType    op;
  TACArg     *arg1, *arg2, *result, *label;
  struct _TACList *next;
} TACList;

TreeNode* makeNode         (NodeType t, int numChild, ...);
TreeNode* generateTerminal (int token, char * const id);
int       genIntCode       (TreeNode *root, TACList *f);
int       newVar           (VarList* list, VarType type);
TACList*  newTAC           (TACType op, TACArg *arg1, TACArg *arg2, TACArg *result, TACArg *label);
TACArg*   newArg           (TACArgType type, char * nodeValue);
TACArg*   newTemp          ();
TACArg*   newLabel         ();
TACArg*   handleExpr       (TreeNode* p, TACList *l);
TACType   tokToOp          (int token);
void      printOp          (TACType op);
TACArg* handleIf(TreeNode* p, TACList *l, TACArg *beginLabel, TACArg *endLabel);

#endif
