%{ 
   /* Definition section */
  #include<stdio.h>  
  int flag=0;
%}

%start START 
%token NUMBER 
%token COMMENT_LONG       
%token COMMENT_SHORT      

%token CONST_STRING       

%token CONST_FLOAT        
%token CONST_INTEGER      

%token KEYWORD_AND        
%token KEYWORD_BREAK      
%token KEYWORD_DO         
%token KEYWORD_ELSE       
%token KEYWORD_ELSEIF     
%token KEYWORD_END        
%token KEYWORD_FALSE      
%token KEYWORD_FOR        
%token KEYWORD_FUNCTION   
%token KEYWORD_GOTO       
%token KEYWORD_IF         
%token KEYWORD_IN         
%token KEYWORD_LOCAL      
%token KEYWORD_NIL        
%token KEYWORD_NOT        
%token KEYWORD_OR         
%token KEYWORD_REPEAT     
%token KEYWORD_RETURN     
%token KEYWORD_THEN       
%token KEYWORD_TRUE       
%token KEYWORD_UNTIL      
%token KEYWORD_WHILE      

%token PLUS               
%token MINUS              
%token ASTERISK           
%token DIVIDE             
%token MOD                
%token CARET              
%token HASH               
%token AMPERSAND          
%token TILDE              
%token PIPE               
%token LEFT_SHIFT         
%token RIGHT_SHIFT        
%token FLOOR_DIVISION     
%token EQUAL_TO           
%token NOT_EQUAL_TO       
%token LESS_EQUAL_TO      
%token GREATER_EQUAL_TO   
%token LESS_THAN          
%token GREATER_THAN       
%token ASSIGNMENT         
%token PARENTHESIS_LEFT   
%token PARENTHESIS_RIGHT  
%token BRACE_LEFT         
%token BRACE_RIGHT        
%token BRACKET_LEFT       
%token BRACKET_RIGHT      
%token SCOPE_RESOLUTION   
%token SEMICOLON          
%token COLON              
%token COMMA              
%token DOT                
%token CONCATENATION      
%token ELLIPSIS           

%token IDENTIFIER         

/* Rule Section */
%% 
  
START: STMTS{ 
  
         printf("\nResult=\n"); 
  
         return 0; 
          } 
 STMTS: /*empty*/ {printf("\nSTMTS");}
 |STMT STMTS      {printf("\nSTMTS");}
 
 STMT: FUNCTION_BLOCK     {printf("\nSTMT");} 
 |LOOP_WHILE              {printf("\nSTMT");}
 |LOOP_FOR                {printf("\nSTMT");}
 |LOOP_REPEAT_UNTIL       {printf("\nSTMT");}
 |IF_ELSE_BLOCK           {printf("\nSTMT");}
 |L_VALUE ASSIGNMENT EXPR {printf("\nSTMT");}
 |KEYWORD_RETURN EXPR     {printf("\nSTMT");}
 |SEMICOLON
 | 

 L_VALUE: IDENTIFIER {COMMA IDENTIFIER}

 // Loops
 LOOP_WHILE: KEYWORD_WHILE EXPR KEYWORD_DO STMTS KEYWORD_END {printf("\nLOOP_WHILE");}
 
 LOOP_FOR: LOOP_FOR_GENERIC {printf("\nLOOP_FOR");}
 |LOOP_FOR_NUMERIC {printf("\nLOOP_FOR");}

 LOOP_FOR_GENERIC: KEYWORD_FOR IDENTIFIER KEYWORD_IN EXPR KEYWORD_DO STMTS KEYWORD_END {printf("\nLOOP_FOR_GENERIC");}

 LOOP_FOR_NUMERIC: KEYWORD_FOR IDENTIFIER ASSIGNMENT EXPR_INC KEYWORD_DO STMTS KEYWORD_END {printf("\nLOOP_FOR_NUMERIC");}

 EXPR_INC: IDENTIFIER COMMA IDENTIFIER {printf("\nEXPR_INC");}
 | IDENTIFIER COMMA IDENTIFIER COMMA IDENTIFIER {printf("\nEXPR_INC");}

 LOOP_REPEAT_UNTIL: KEYWORD_REPEAT STMTS KEYWORD_UNTIL EXPR {printf("\nLOOP_REPEAT_UNTIL");}

 // If else block
 IF_ELSE_BLOCK: KEYWORD_IF EXPR KEYWORD_THEN STMTS ELSE_IF_BLOCK {printf("\nIF_ELSE_BLOCK");}

 ELSE_IF_BLOCK: KEYWORD_END {printf("\nELSE_IF_BLOCK");}
 |KEYWORD_ELSEIF EXPR KEYWORD_THEN STMTS ELSE_IF_BLOCK {printf("\nELSE_IF_BLOCK");}
 |KEYWORD_ELSE STMTS KEYWORD_END {printf("\nELSE_IF_BLOCK");}

 // Functions
 FUNCTION_BLOCK: KEYWORD_FUNCTION IDENTIFIER PARENTHESIS_LEFT ARGS PARENTHESIS_RIGHT STMTS KEYWORD_END {printf("\nFUNCTION_BLOCK");}

 CONST_FUNCTION: KEYWORD_FUNCTION PARENTHESIS_LEFT ARGS PARENTHESIS_RIGHT STMTS KEYWORD_END {printf("\nCONST_FUNCTION");}

 ARGS: IDENTIFIER {COMMA IDENTIFIER} {printf("\nARGS");}

 PARAMS: {printf("\nPARAMS");}
 |EXPR COMMA PARAMS {printf("\nPARAMS");}
 |EXPR {printf("\nPARAMS");}
 |TABLE_CONSTRUCTOR {printf("\nPARAMS");}
 |CONST_STRING {printf("\nPARAMS");}

 // Constants
 CONSTANT: CONST_STRING {printf("\nCONSTANT");}
 |CONST_FLOAT {printf("\nCONSTANT");}
 |CONST_INTEGER {printf("\nCONSTANT");}
 |CONST_FUNCTION {printf("\nCONSTANT");}
 |KEYWORD_NIL {printf("\nCONSTANT");}
 |KEYWORD_FALSE {printf("\nCONSTANT");}
 |KEYWORD_TRUE {printf("\nCONSTANT");}

 //TABLE_CONSTRUCTOR
 TABLE_CONSTRUCTOR: BRACE_LEFT FIELDS BRACE_RIGHT {printf("\nTABLE_CONSTRUCTOR");}
 FIELDS: EXPR {printf("\nFIELDS");}
 | BRACKET_LEFT EXPR BRACE_RIGHT ASSIGNMENT EXPR {printf("\nFIELDS");}
 | IDENTIFIER ASSIGNMENT EXPR {printf("\nFIELDS");}

 EXPR: EXPR BIN_OPERATOR EXPR {printf("\nEXPR");}
 |UNARY_OPERATOR EXPR {printf("\nEXPR");}
 |CONSTANT  {printf("\nEXPR");}
 |IDENTIFIER {printf("\nEXPR");}
 |PARENTHESIS_LEFT EXPR PARENTHESIS_RIGHT {printf("\nEXPR");}
 |EXPR PARENTHESIS_LEFT PARAMS PARENTHESIS_RIGHT {printf("\nEXPR");}

 EXPRS: EXPR {COMMA EXPR}
 BIN_OPERATOR:
 // Arithmetic Operators
 PLUS                {printf("\nBIN_OPERATOR");}
 |MINUS               {printf("\nBIN_OPERATOR");}
 |ASTERISK            {printf("\nBIN_OPERATOR");}
 |DIVIDE              {printf("\nBIN_OPERATOR");}
 |CARET              {printf("\nBIN_OPERATOR");}
 |FLOOR_DIVISION      {printf("\nBIN_OPERATOR");}
 |MOD                 {printf("\nBIN_OPERATOR");}
 //Relational Operators
 |EQUAL_TO            {printf("\nBIN_OPERATOR");}
 |NOT_EQUAL_TO        {printf("\nBIN_OPERATOR");}
 |LESS_EQUAL_TO       {printf("\nBIN_OPERATOR");}
 |GREATER_EQUAL_TO    {printf("\nBIN_OPERATOR");}
 |LESS_THAN           {printf("\nBIN_OPERATOR");}
 |GREATER_THAN {printf("\nBIN_OPERATOR");}
 //Logical Operators
 |KEYWORD_AND {printf("\nBIN_OPERATOR");}
 |KEYWORD_OR {printf("\nBIN_OPERATOR");}

 |CONCATENATION       {printf("\nBIN_OPERATOR");}

 //Bit-wise operators
 |AMPERSAND           {printf("\nBIN_OPERATOR");}
 |PIPE                {printf("\nBIN_OPERATOR");}
 |LEFT_SHIFT          {printf("\nBIN_OPERATOR");}
 |RIGHT_SHIFT         {printf("\nBIN_OPERATOR");}

// |SEMICOLON          
// |COLON              
// |COMMA              
// |DOT                
// |ELLIPSIS           

 UNARY_OPERATOR: HASH                {printf("\nUNARY_OPERATOR");}
 |MINUS {printf("\nUNARY_OPERATOR");}
 |KEYWORD_NOT {printf("\nUNARY_OPERATOR");}
 |TILDE               {printf("\nUNARY_OPERATOR");}
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
