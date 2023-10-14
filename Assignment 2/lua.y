%{
   /* Definition section */
  #include<stdio.h>
  int flag=0;
  #define YYDEBUG 1
%}

%start start
%token NUMBER

%token CONST_STRING

%token CONST_FLOAT
%token CONST_INTEGER

%token KEYWORD_AND KEYWORD_BREAK KEYWORD_DO KEYWORD_ELSE KEYWORD_ELSEIF KEYWORD_END KEYWORD_FALSE KEYWORD_FOR KEYWORD_FUNCTION
%token KEYWORD_GOTO KEYWORD_IF KEYWORD_IN KEYWORD_LOCAL KEYWORD_NIL KEYWORD_NOT KEYWORD_OR KEYWORD_REPEAT KEYWORD_RETURN
%token KEYWORD_THEN KEYWORD_TRUE KEYWORD_UNTIL KEYWORD_WHILE

%token PLUS MINUS ASTERISK DIVIDE MOD CARET HASH AMPERSAND TILDE PIPE LEFT_SHIFT RIGHT_SHIFT FLOOR_DIVISION
%token EQUAL_TO NOT_EQUAL_TO LESS_EQUAL_TO GREATER_EQUAL_TO LESS_THAN GREATER_THAN ASSIGNMENT
%token PARENTHESIS_LEFT PARENTHESIS_RIGHT BRACE_LEFT BRACE_RIGHT BRACKET_LEFT BRACKET_RIGHT SCOPE_RESOLUTION
%token SEMICOLON COLON COMMA DOT CONCATENATION ELLIPSIS

%token IDENTIFIER

%token EXIT 0 "end of file"


/* Rule Section */
%%

start: stmts { printf("START:\n"); return 0; }
  ;

stmts: /*empty*/   { printf("\nstmts");}
       |stmt stmts { printf("\nstmts");}
       ;

stmt: function_block            { printf("\nstmt: function");}
       |loop_while              { printf("\nstmt: while");}
       |loop_for                { printf("\nstmt: for");}
       |loop_repeat_until       { printf("\nstmt: repeat");}
       |if_else_block           { printf("\nstmt: if_else");}
       |l_value ASSIGNMENT expr { printf("\nstmt: assignment");}
       |KEYWORD_RETURN expr     { printf("\nstmt: return");}
       |call_function           { printf("\nstmt: function call");}
       |SEMICOLON               { printf("\nstmt: semicolon");}
       ;

l_value: IDENTIFIER COMMA l_value { printf("\nl_value: multiple");}
       | IDENTIFIER               { printf("\nl_value: single");}
       ;

// Loops
loop_while: KEYWORD_WHILE expr KEYWORD_DO stmts KEYWORD_END { printf("\nloop_while");}
       ;

loop_for: loop_for_generic { printf("\nloop_for");}
       |loop_for_numeric   { printf("\nloop_for");}
       ;

loop_for_generic: KEYWORD_FOR IDENTIFIER KEYWORD_IN expr KEYWORD_DO stmts KEYWORD_END { printf("\nloop_for_GENERIC");}
       ;

loop_for_numeric: KEYWORD_FOR IDENTIFIER ASSIGNMENT expr_inc KEYWORD_DO stmts KEYWORD_END { printf("\nloop_for_NUMERIC");}
       ;

expr_inc: IDENTIFIER COMMA IDENTIFIER                 { printf("\nEXPR_INC: increment = 1");}
       | IDENTIFIER COMMA IDENTIFIER COMMA IDENTIFIER { printf("\nEXPR_INC: set increment");}
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

// Functions
function_block: KEYWORD_FUNCTION IDENTIFIER PARENTHESIS_LEFT l_value PARENTHESIS_RIGHT stmts KEYWORD_END { printf("\nFUNCTION_BLOCK");}
       ;

const_function: KEYWORD_FUNCTION PARENTHESIS_LEFT l_value PARENTHESIS_RIGHT stmts KEYWORD_END { printf("\nconst_function");}
       ;

call_function: expr PARENTHESIS_LEFT params PARENTHESIS_RIGHT { printf("\nFunction");}

params:                   { printf("\nPARAMS: empty");}
       |expr COMMA params { printf("\nPARAMS: multiple");}
       |expr              { printf("\nPARAMS: single");}
       |table_constructor { printf("\nPARAMS: table");}
       |CONST_STRING      { printf("\nPARAMS: string");}
       ;

// Constants
constant: CONST_STRING { printf("\nCONSTANT: string");}
       |CONST_FLOAT    { printf("\nCONSTANT: float");}
       |CONST_INTEGER  { printf("\nCONSTANT: integer");}
       |const_function { printf("\nCONSTANT: function");}
       |KEYWORD_NIL    { printf("\nCONSTANT: nil");}
       |KEYWORD_FALSE  { printf("\nCONSTANT: false");}
       |KEYWORD_TRUE   { printf("\nCONSTANT: true");}
       ;

//table_constructor
table_constructor: BRACE_LEFT FIELDS BRACE_RIGHT { printf("\nTABLE_CONSTRUCTOR");}
       ;

FIELDS: expr                                           { printf("\nFIELDS");}
       | BRACKET_LEFT expr BRACE_RIGHT ASSIGNMENT expr { printf("\nFIELDS");}
       | IDENTIFIER ASSIGNMENT expr                    { printf("\nFIELDS");}
       ;

expr: expr bin_operator expr                    { printf("\nEXPR: bin");}
       |unary_operator expr                     { printf("\nEXPR: unary");}
       |constant                                { printf("\nEXPR: const");}
       |IDENTIFIER                              { printf("\nEXPR: id");}
       |PARENTHESIS_LEFT expr PARENTHESIS_RIGHT { printf("\nEXPR: parenthesis");}
       |call_function                           { printf("\nEXPR: function call");}
       ;

//exprs: expr {COMMA expr}
bin_operator:
       // Arithmetic Operators
       PLUS                 {printf("\nBIN_OPERATOR");}
       |MINUS               {printf("\nBIN_OPERATOR");}
       |ASTERISK            {printf("\nBIN_OPERATOR");}
       |DIVIDE              {printf("\nBIN_OPERATOR");}
       |CARET               {printf("\nBIN_OPERATOR");}
       |FLOOR_DIVISION      {printf("\nBIN_OPERATOR");}
       |MOD                 {printf("\nBIN_OPERATOR");}
       //Relational Operators
       |EQUAL_TO            {printf("\nBIN_OPERATOR");}
       |NOT_EQUAL_TO        {printf("\nBIN_OPERATOR");}
       |LESS_EQUAL_TO       {printf("\nBIN_OPERATOR");}
       |GREATER_EQUAL_TO    {printf("\nBIN_OPERATOR");}
       |LESS_THAN           {printf("\nBIN_OPERATOR");}
       |GREATER_THAN        {printf("\nBIN_OPERATOR");}
       //Logical Operators
       |KEYWORD_AND         {printf("\nBIN_OPERATOR");}
       |KEYWORD_OR          {printf("\nBIN_OPERATOR");}
       //Concatenation Operator
       |CONCATENATION       {printf("\nBIN_OPERATOR");}
       //Bit-wise operators
       |AMPERSAND           {printf("\nBIN_OPERATOR");}
       |PIPE                {printf("\nBIN_OPERATOR");}
       |LEFT_SHIFT          {printf("\nBIN_OPERATOR");}
       |RIGHT_SHIFT         {printf("\nBIN_OPERATOR");}
       ;

unary_operator: HASH        {printf("\nUNARY_OPERATOR");}
       |MINUS               {printf("\nUNARY_OPERATOR");}
       |KEYWORD_NOT         {printf("\nUNARY_OPERATOR");}
       |TILDE               {printf("\nUNARY_OPERATOR");}
       ;
%%

//driver code
void main()
{
  printf("\nEnter Lua Program:\n");
   yyparse();
  if(flag==0)
   printf("\nValid Syntax\n");
}

void yyerror()
{
   printf("\nInvalid Syntax\n");
   flag=1;
}
