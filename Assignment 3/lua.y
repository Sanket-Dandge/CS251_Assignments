%{
  #include<stdio.h>
  #include<string.h>
  #include "semantics.h"

  #define YYDEBUG 1
  #define DPRINT(inp) if(debug) printf(inp);
  extern int linenr;
  int debug = 0;
  struct _Node *root = NULL;

  int error_count = 0;
  int flag = 0;
%}

%union {
  struct _Node *node;
  char *strValue;
  int  num;
}

%start start
%token <num> NUMBER

%token <strValue> CONST_STRING

%token <strValue> CONST_FLOAT
%token <strValue> CONST_INTEGER

%token <strValue> KEYWORD_AND KEYWORD_BREAK KEYWORD_DO KEYWORD_ELSE KEYWORD_ELSEIF KEYWORD_END KEYWORD_FALSE KEYWORD_FOR KEYWORD_FUNCTION
%token <strValue> KEYWORD_GOTO KEYWORD_IF KEYWORD_IN KEYWORD_LOCAL KEYWORD_NIL KEYWORD_NOT KEYWORD_OR KEYWORD_REPEAT KEYWORD_RETURN
%token <strValue> KEYWORD_THEN KEYWORD_TRUE KEYWORD_UNTIL KEYWORD_WHILE

%token <strValue> PLUS MINUS ASTERISK DIVIDE MOD CARET HASH AMPERSAND TILDE PIPE LEFT_SHIFT RIGHT_SHIFT FLOOR_DIVISION
%token <strValue> EQUAL_TO NOT_EQUAL_TO LESS_EQUAL_TO GREATER_EQUAL_TO LESS_THAN GREATER_THAN ASSIGNMENT

%token <strValue> PARENTHESIS_LEFT PARENTHESIS_RIGHT BRACE_LEFT BRACE_RIGHT BRACKET_LEFT BRACKET_RIGHT SCOPE_RESOLUTION
%token <strValue> SEMICOLON COLON COMMA DOT CONCATENATION ELLIPSIS
%token <strValue> IDENTIFIER
%token EXIT 0 "end of file"

%type <node> start stmts stmt ids l_value exprs loop_while loop_for loop_for_generic loop_for_numeric expr_inc loop_repeat_until if_else_block else_if_block do_block function_block function_local function_name dot_name const_function params call_function args constant table_constructor field_list sep_fields field fieldsep var exprP expr bin_operator unary_operator

%left CARET
%left KEYWORD_NOT HASH
%left ASTERISK DIVIDE MOD
%left PLUS MINUS
%left CONCATENATION
%left LESS_THAN GREATER_THAN LESS_EQUAL_TO GREATER_EQUAL_TO NOT_EQUAL_TO EQUAL_TO
%left KEYWORD_AND
%left KEYWORD_OR

/* Rule Section */
%%

start: stmts {
     DPRINT("START:\n");
     if($1 != NULL){
       $$ = makeNode(N_PRG, 1, $1);
       root = $$;
     }
     return 0;
   }
  ;

stmts: /*empty*/   { DPRINT("\nstmts"); $$ = NULL;}
       |stmt stmts { DPRINT("\nstmts"); $$ = makeNode(N_STMTS, 2, $1, $2);}
       ;

stmt: l_value ASSIGNMENT exprs              { DPRINT("\nstmt: assignment"); $$ = makeNode(N_STMT, 3, $1, generateTerminal(ASSIGNMENT, "="), $3);}
       |do_block                            { DPRINT("\nstmt: do"); $$ = $1;}
       |loop_while                          { DPRINT("\nstmt: while");$$ = $1;}
       |loop_for                            { DPRINT("\nstmt: for");$$ = $1;}
       |loop_repeat_until                   { DPRINT("\nstmt: repeat");$$ = $1;}
       |if_else_block                       { DPRINT("\nstmt: if_else");$$ = $1;}
       |function_block                      { DPRINT("\nstmt: function");$$ = NULL;}
       |KEYWORD_RETURN expr                 { DPRINT("\nstmt: return"); $$ = makeNode(N_STMT, 2, generateTerminal(KEYWORD_RETURN, "return"), $2);}
       |KEYWORD_RETURN                      { DPRINT("\nstmt: return empty"); $$ = generateTerminal(KEYWORD_RETURN, "return");}
       |call_function                       { DPRINT("\nstmt: function call"); $$ = NULL;}
       |KEYWORD_LOCAL ids                   { DPRINT("\nstmt: local"); $$ = makeNode(N_STMT, 2, generateTerminal(KEYWORD_LOCAL, "local"), $2);}
       |KEYWORD_LOCAL ids ASSIGNMENT exprs  { DPRINT("\nstmt: local"); $$ = makeNode(N_STMT, 4, generateTerminal(KEYWORD_LOCAL, "local"), $2, generateTerminal(ASSIGNMENT, "="), $4);}
       |KEYWORD_LOCAL function_local        { DPRINT("\nstmt: function local"); $$ = NULL;}
       |SEMICOLON                           { DPRINT("\nstmt: semicolon"); $$ = NULL;}
       |KEYWORD_BREAK                       { DPRINT("\nstmt: break"); $$ = generateTerminal(KEYWORD_BREAK, "break");}
       ;

ids: IDENTIFIER COMMA ids { DPRINT("\nl_value: multiple"); $$ = makeNode(N_STMT, 3, generateTerminal(IDENTIFIER, $1), generateTerminal(COMMA, ","), $3);}
   | IDENTIFIER           { DPRINT("\nl_value: single"); $$ = generateTerminal(IDENTIFIER, $1);}
   ;

l_value: var COMMA l_value { DPRINT("\nl_value: multiple"); $$ = makeNode(N_STMT, 3, $1, generateTerminal(COMMA, ","), $3);}
       | var               { DPRINT("\nl_value: single"); $$ = $1;}
       ;

exprs: exprs COMMA expr    { DPRINT("\nl_value: multiple"); $$ = makeNode(N_STMT, 3, $1, generateTerminal(COMMA, ","), $3);}
       |expr               { DPRINT("\nl_value: single"); $$ = $1}
       ;

// Loops
loop_while: KEYWORD_WHILE expr KEYWORD_DO stmts KEYWORD_END { DPRINT("\nloop_while"); $$ = makeNode(N_STMT, 5, ) }
       ;

loop_for: loop_for_generic { DPRINT("\nloop_for");}
       |loop_for_numeric   { DPRINT("\nloop_for");}
       ;

loop_for_generic: KEYWORD_FOR ids KEYWORD_IN exprs KEYWORD_DO stmts KEYWORD_END { DPRINT("\nloop_for_GENERIC");}
       ;

loop_for_numeric: KEYWORD_FOR IDENTIFIER ASSIGNMENT expr_inc KEYWORD_DO stmts KEYWORD_END { DPRINT("\nloop_for_NUMERIC");}
       ;

expr_inc: expr COMMA expr           { DPRINT("\nEXPR_INC: increment = 1");}
       | expr COMMA expr COMMA expr { DPRINT("\nEXPR_INC: set increment");}
       ;

loop_repeat_until: KEYWORD_REPEAT stmts KEYWORD_UNTIL expr { DPRINT("\nLOOP_REPEAT_UNTIL");}
       ;

// If else block
if_else_block: KEYWORD_IF expr KEYWORD_THEN stmts else_if_block { DPRINT("\nIF_ELSE_BLOCK");}
       ;

else_if_block: KEYWORD_END                                   { DPRINT("\nelse_if_block: end");}
       |KEYWORD_ELSEIF expr KEYWORD_THEN stmts else_if_block { DPRINT("\nelse_if_block: else if");}
       |KEYWORD_ELSE stmts KEYWORD_END                       { DPRINT("\nelse_if_block: else");}
       ;

// Do block
do_block: KEYWORD_DO stmts KEYWORD_END    { DPRINT("\nDO_BLOCK");}

// Functions
function_block: KEYWORD_FUNCTION function_name PARENTHESIS_LEFT params PARENTHESIS_RIGHT stmts KEYWORD_END { DPRINT("\nFUNCTION_BLOCK");}
       ;

function_local: KEYWORD_FUNCTION IDENTIFIER PARENTHESIS_LEFT params PARENTHESIS_RIGHT stmts KEYWORD_END { DPRINT("\nFUNCTION_BLOCK");}
       ;

function_name: IDENTIFIER dot_name           { DPRINT("\nFUNCTION_NAME: dot");}
       |IDENTIFIER dot_name COLON IDENTIFIER { DPRINT("\nFUNCTION_BLOCK: dot colon");}
       ;

dot_name: DOT IDENTIFIER dot_name    { DPRINT("\nDOT_NAME: dot_id");}
       |/*empty*/                    { DPRINT("\nDOT_NAME: empty"); $$ = NULL;}
       ;

const_function: KEYWORD_FUNCTION PARENTHESIS_LEFT params PARENTHESIS_RIGHT stmts KEYWORD_END { DPRINT("\nconst_function");}
       ;

params: /*empty*/               { DPRINT("\nPARAMS: empty"); $$ = NULL;}
       |IDENTIFIER COMMA params { DPRINT("\nPARAMS: multiple");}
       |IDENTIFIER              { DPRINT("\nPARAMS: single");}
       |ELLIPSIS                { DPRINT("\nPARAMS: ellipsis");}
       ;


call_function: exprP args           { DPRINT("\nFunction");}
       |exprP COLON IDENTIFIER args { DPRINT("\nFunction");}
       ;

args: PARENTHESIS_LEFT exprs PARENTHESIS_RIGHT { DPRINT("\nARGS: exprs");}
       |PARENTHESIS_LEFT PARENTHESIS_RIGHT     { DPRINT("\nARGS: empty_exprs");}
       |table_constructor                      { DPRINT("\nARGS: table");}
       |CONST_STRING                           { DPRINT("\nARGS: string");}
       ;

// Constants
constant: CONST_STRING    { DPRINT("\nCONSTANT: string");}
       |CONST_FLOAT       { DPRINT("\nCONSTANT: float");}
       |CONST_INTEGER     { DPRINT("\nCONSTANT: integer");}
       |const_function    { DPRINT("\nCONSTANT: function");}
       |KEYWORD_NIL       { DPRINT("\nCONSTANT: nil");}
       |KEYWORD_FALSE     { DPRINT("\nCONSTANT: false");}
       |KEYWORD_TRUE      { DPRINT("\nCONSTANT: true");}
       |table_constructor { DPRINT("\nCONSTANT: table");}
       ;

//table_constructor
table_constructor: BRACE_LEFT field_list BRACE_RIGHT { DPRINT("\nTABLE_CONSTRUCTOR");}
       |BRACE_LEFT BRACE_RIGHT                       { DPRINT("\nTABLE_CONSTRUCTOR");}
       ;

field_list: field sep_fields      { DPRINT("\nFIELD_LIST: no_fieldsep");}        
       |field sep_fields fieldsep { DPRINT("\nFIELD_LIST: with_fieldsep");}
       ;

sep_fields: fieldsep field sep_fields { DPRINT("\nSEP_FIELDS");}
       | /*empty*/                    { DPRINT("\nSEP_FIELDS: empty"); $$ = NULL;}
       ;

field:  expr                                           { DPRINT("\nFIELDS");}
       | BRACKET_LEFT expr BRACE_RIGHT ASSIGNMENT expr { DPRINT("\nFIELDS");}
       | IDENTIFIER ASSIGNMENT expr                    { DPRINT("\nFIELDS");}
       ;

fieldsep: COMMA { DPRINT("\nFIELDSEP: COMMA");}
    | SEMICOLON { DPRINT("\nFIELDSEP: SEMICOLON");}

var: IDENTIFIER                                { DPRINT("\nVAR: id");}        
       | exprP BRACKET_LEFT expr BRACKET_RIGHT { DPRINT("\nVAR: expr");}
       | exprP DOT IDENTIFIER                  { DPRINT("\nVAR: dot");}

exprP: PARENTHESIS_LEFT expr PARENTHESIS_RIGHT { DPRINT("\nEXPR_P: parenthesis");}
       |call_function                          { DPRINT("\nEXPR_P: function call");}
       |var                                    { DPRINT("\nEXPR_P: var");}

expr:  constant                { DPRINT("\nEXPR: const");}
       |ELLIPSIS               { DPRINT("\nEXPR: elipsis");}
       |exprP                  { DPRINT("\nEXPR: prefix");}
       |expr bin_operator expr { DPRINT("\nEXPR: bin");}
       |unary_operator expr    { DPRINT("\nEXPR: unary");}
       ;

bin_operator:
       // Arithmetic Operators
       PLUS                 {DPRINT("\nBIN_OPERATOR: plus");}
       |MINUS               {DPRINT("\nBIN_OPERATOR: minus");}
       |ASTERISK            {DPRINT("\nBIN_OPERATOR: asterisk");}
       |DIVIDE              {DPRINT("\nBIN_OPERATOR: divide");}
       |CARET               {DPRINT("\nBIN_OPERATOR: caret");}
       |FLOOR_DIVISION      {DPRINT("\nBIN_OPERATOR: floor_division");}
       |MOD                 {DPRINT("\nBIN_OPERATOR: mod");}
       //Relational Operators
       |EQUAL_TO            {DPRINT("\nBIN_OPERATOR: equal_to");}
       |NOT_EQUAL_TO        {DPRINT("\nBIN_OPERATOR: not_equal_to");}
       |LESS_EQUAL_TO       {DPRINT("\nBIN_OPERATOR: less_equal_to");}
       |GREATER_EQUAL_TO    {DPRINT("\nBIN_OPERATOR: greater_equal_to");}
       |LESS_THAN           {DPRINT("\nBIN_OPERATOR: less_than");}
       |GREATER_THAN        {DPRINT("\nBIN_OPERATOR: greater_than");}
       //Logical Operators
       |KEYWORD_AND         {DPRINT("\nBIN_OPERATOR: keyword_and");}
       |KEYWORD_OR          {DPRINT("\nBIN_OPERATOR: keyword_or");}
       //Concatenation Operator
       |CONCATENATION       {DPRINT("\nBIN_OPERATOR: concatenation");}
       //Bit-wise operators
       |AMPERSAND           {DPRINT("\nBIN_OPERATOR: ampersand");}
       |PIPE                {DPRINT("\nBIN_OPERATOR: pipe");}
       |LEFT_SHIFT          {DPRINT("\nBIN_OPERATOR: left_shift");}
       |RIGHT_SHIFT         {DPRINT("\nBIN_OPERATOR: right_shift");}
       ;

unary_operator: HASH {DPRINT("\nUNARY_OPERATOR: hash");}
       |MINUS        {DPRINT("\nUNARY_OPERATOR: minus");}
       |KEYWORD_NOT  {DPRINT("\nUNARY_OPERATOR: keyword_not");}
       |TILDE        {DPRINT("\nUNARY_OPERATOR: tilde");}
       ;
%%

//driver code
int main()
{
  printf("\nEnter Lua Program:\n");
   yyparse();
  if(flag==0)
  {
    printf("\nValid Syntax\n");
    return(0);
  }
  else
  {
    printf("\n%d syntax errors detected\n", error_count);
    return(1);
  }
  return(0);
}

void yyerror()
{
   printf("\nUnexpected token `%s' at line %d\n", yylval, linenr);
   error_count++;
   flag = 1;
}

