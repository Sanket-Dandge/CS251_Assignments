%{
  #include<stdio.h>
  #include<string.h>

  #define YYDEBUG 1
  #define YYSTYPE char * 

  extern int linenr;

  int error_count = 0;
  int flag = 0;
%}

%union {
  char *strValue;
}

%start start
%token <strValue> NUMBER

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

%left CARET
%left KEYWORD_NOT HASH MINUS
%left ASTERISK DIVIDE MOD
%left PLUS MINUS
%left CONCATENATION
%left LESS_THAN GREATER_THAN LESS_EQUAL_TO GREATER_EQUAL_TO NOT_EQUAL_TO EQUAL_TO
%left KEYWORD_AND
%left KEYWORD_OR

/* Rule Section */
%%

start: stmts { printf("START:\n"); return 0; }
  ;

stmts: /*empty*/   { printf("\nstmts");}
       |stmt stmts { printf("\nstmts");}
       ;

stmt: l_value ASSIGNMENT exprs              { printf("\nstmt: assignment");}
       |do_block                            { printf("\nstmt: do");}
       |loop_while                          { printf("\nstmt: while");}
       |loop_for                            { printf("\nstmt: for");}
       |loop_repeat_until                   { printf("\nstmt: repeat");}
       |if_else_block                       { printf("\nstmt: if_else");}
       |function_block                      { printf("\nstmt: function");}
       |KEYWORD_RETURN expr                 { printf("\nstmt: return");}
       |KEYWORD_RETURN                      { printf("\nstmt: return empty");}
       |call_function                       { printf("\nstmt: function call");}
       |KEYWORD_LOCAL ids                   { printf("\nstmt: local");}
       |KEYWORD_LOCAL ids ASSIGNMENT exprs  { printf("\nstmt: local");}
       |KEYWORD_LOCAL function_local        { printf("\nstmt: function local");}
       |SEMICOLON                           { printf("\nstmt: semicolon");}
       ;

ids: IDENTIFIER COMMA ids { printf("\nl_value: multiple");}
   | IDENTIFIER           { printf("\nl_value: single");}
   ;

l_value: var COMMA l_value { printf("\nl_value: multiple");}
       | var               { printf("\nl_value: single");}
       ;

exprs: exprs COMMA expr    { printf("\nl_value: multiple");}
       |expr               { printf("\nl_value: single");}
       ;

// Loops
loop_while: KEYWORD_WHILE expr KEYWORD_DO stmts KEYWORD_END { printf("\nloop_while");}
       ;

loop_for: loop_for_generic { printf("\nloop_for");}
       |loop_for_numeric   { printf("\nloop_for");}
       ;

loop_for_generic: KEYWORD_FOR ids KEYWORD_IN exprs KEYWORD_DO stmts KEYWORD_END { printf("\nloop_for_GENERIC");}
       ;

loop_for_numeric: KEYWORD_FOR IDENTIFIER ASSIGNMENT expr_inc KEYWORD_DO stmts KEYWORD_END { printf("\nloop_for_NUMERIC");}
       ;

expr_inc: expr COMMA expr           { printf("\nEXPR_INC: increment = 1");}
       | expr COMMA expr COMMA expr { printf("\nEXPR_INC: set increment");}
       ;

loop_repeat_until: KEYWORD_REPEAT stmts KEYWORD_UNTIL expr { printf("\nLOOP_REPEAT_UNTIL");}
       ;

// If else block
if_else_block: KEYWORD_IF expr KEYWORD_THEN stmts else_if_block { printf("\nIF_ELSE_BLOCK");}
       ;

else_if_block: KEYWORD_END                                   { printf("\nelse_if_block: end");}
       |KEYWORD_ELSEIF expr KEYWORD_THEN stmts else_if_block { printf("\nelse_if_block: else if");}
       |KEYWORD_ELSE stmts KEYWORD_END                       { printf("\nelse_if_block: else");}
       ;

// Do block
do_block: KEYWORD_DO stmts KEYWORD_END    { printf("\nDO_BLOCK");}

// Functions
function_block: KEYWORD_FUNCTION function_name PARENTHESIS_LEFT params PARENTHESIS_RIGHT stmts KEYWORD_END { printf("\nFUNCTION_BLOCK");}
       ;

function_local: KEYWORD_FUNCTION IDENTIFIER PARENTHESIS_LEFT params PARENTHESIS_RIGHT stmts KEYWORD_END { printf("\nFUNCTION_BLOCK");}
       ;

function_name: IDENTIFIER dot_name           { printf("\nFUNCTION_NAME: dot");}
       |IDENTIFIER dot_name COLON IDENTIFIER { printf("\nFUNCTION_BLOCK: dot colon");}
       ;

dot_name: DOT IDENTIFIER dot_name    { printf("\nDOT_NAME: dot_id");}
       |/*empty*/                    { printf("\nDOT_NAME: empty");}
       ;

const_function: KEYWORD_FUNCTION PARENTHESIS_LEFT params PARENTHESIS_RIGHT stmts KEYWORD_END { printf("\nconst_function");}
       ;

params: /*empty*/               { printf("\nPARAMS: empty");}
       |IDENTIFIER COMMA params { printf("\nPARAMS: multiple");}
       |IDENTIFIER              { printf("\nPARAMS: single");}
       |ELLIPSIS                { printf("\nPARAMS: ellipsis");}
       ;


call_function: exprP args           { printf("\nFunction");}
       |exprP COLON IDENTIFIER args { printf("\nFunction");}
       ;

args: PARENTHESIS_LEFT exprs PARENTHESIS_RIGHT { printf("\nARGS: exprs");}
       |PARENTHESIS_LEFT PARENTHESIS_RIGHT     { printf("\nARGS: empty_exprs");}
       |table_constructor                      { printf("\nARGS: table");}
       |CONST_STRING                           { printf("\nARGS: string");}
       ;

// Constants
constant: CONST_STRING    { printf("\nCONSTANT: string");}
       |CONST_FLOAT       { printf("\nCONSTANT: float");}
       |CONST_INTEGER     { printf("\nCONSTANT: integer");}
       |const_function    { printf("\nCONSTANT: function");}
       |KEYWORD_NIL       { printf("\nCONSTANT: nil");}
       |KEYWORD_FALSE     { printf("\nCONSTANT: false");}
       |KEYWORD_TRUE      { printf("\nCONSTANT: true");}
       |table_constructor { printf("\nCONSTANT: table");}
       ;

//table_constructor
table_constructor: BRACE_LEFT field_list BRACE_RIGHT { printf("\nTABLE_CONSTRUCTOR");}
       |BRACE_LEFT BRACE_RIGHT                       { printf("\nTABLE_CONSTRUCTOR");}
       ;

field_list: field sep_fields      { printf("\nFIELD_LIST: no_fieldsep");}        
       |field sep_fields fieldsep { printf("\nFIELD_LIST: with_fieldsep");}
       ;

sep_fields: fieldsep field sep_fields { printf("\nSEP_FIELDS");}
       | /*empty*/                    { printf("\nSEP_FIELDS: empty");}
       ;

field:  expr                                           { printf("\nFIELDS");}
       | BRACKET_LEFT expr BRACE_RIGHT ASSIGNMENT expr { printf("\nFIELDS");}
       | IDENTIFIER ASSIGNMENT expr                    { printf("\nFIELDS");}
       ;

fieldsep: COMMA { printf("\nFIELDSEP: COMMA");}
    | SEMICOLON { printf("\nFIELDSEP: SEMICOLON");}

var: IDENTIFIER                                { printf("\nVAR: id");}        
       | exprP BRACKET_LEFT expr BRACKET_RIGHT { printf("\nVAR: expr");}
       | exprP DOT IDENTIFIER                  { printf("\nVAR: dot");}

exprP: PARENTHESIS_LEFT expr PARENTHESIS_RIGHT { printf("\nEXPR_P: parenthesis");}
       |call_function                          { printf("\nEXPR_P: function call");}
       |var                                    { printf("\nEXPR_P: var");}

expr:  constant                { printf("\nEXPR: const");}
       |ELLIPSIS               { printf("\nEXPR: elipsis");}
       |exprP                  { printf("\nEXPR: prefix");}
       |expr bin_operator expr { printf("\nEXPR: bin");}
       |unary_operator expr    { printf("\nEXPR: unary");}
       ;

bin_operator:
       // Arithmetic Operators
       PLUS                 {printf("\nBIN_OPERATOR: plus");}
       |MINUS               {printf("\nBIN_OPERATOR: minus");}
       |ASTERISK            {printf("\nBIN_OPERATOR: asterisk");}
       |DIVIDE              {printf("\nBIN_OPERATOR: divide");}
       |CARET               {printf("\nBIN_OPERATOR: caret");}
       |FLOOR_DIVISION      {printf("\nBIN_OPERATOR: floor_division");}
       |MOD                 {printf("\nBIN_OPERATOR: mod");}
       //Relational Operators
       |EQUAL_TO            {printf("\nBIN_OPERATOR: equal_to");}
       |NOT_EQUAL_TO        {printf("\nBIN_OPERATOR: not_equal_to");}
       |LESS_EQUAL_TO       {printf("\nBIN_OPERATOR: less_equal_to");}
       |GREATER_EQUAL_TO    {printf("\nBIN_OPERATOR: greater_equal_to");}
       |LESS_THAN           {printf("\nBIN_OPERATOR: less_than");}
       |GREATER_THAN        {printf("\nBIN_OPERATOR: greater_than");}
       //Logical Operators
       |KEYWORD_AND         {printf("\nBIN_OPERATOR: keyword_and");}
       |KEYWORD_OR          {printf("\nBIN_OPERATOR: keyword_or");}
       //Concatenation Operator
       |CONCATENATION       {printf("\nBIN_OPERATOR: concatenation");}
       //Bit-wise operators
       |AMPERSAND           {printf("\nBIN_OPERATOR: ampersand");}
       |PIPE                {printf("\nBIN_OPERATOR: pipe");}
       |LEFT_SHIFT          {printf("\nBIN_OPERATOR: left_shift");}
       |RIGHT_SHIFT         {printf("\nBIN_OPERATOR: right_shift");}
       ;

unary_operator: HASH {printf("\nUNARY_OPERATOR: hash");}
       |MINUS        {printf("\nUNARY_OPERATOR: minus");}
       |KEYWORD_NOT  {printf("\nUNARY_OPERATOR: keyword_not");}
       |TILDE        {printf("\nUNARY_OPERATOR: tilde");}
       ;
%%

//driver code
void main()
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
