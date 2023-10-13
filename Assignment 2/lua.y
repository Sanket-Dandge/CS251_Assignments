%{ 
   /* Definition section */
  #include<stdio.h>  
  int flag=0;
  #define YYDEBUG 1
%}

%start start 
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

%token EXIT 0 "end of file"


/* Rule Section */
%% 
  
start: stmts{ 
         printf("\nResult=\n"); 
         return 0; 
        } 
  ;

 stmts: /*empty*/ {printf("\nstmts");}
 |stmt stmts      {printf("\nstmts");}
 ;
 
 stmt: function_block     {printf("\nstmt");} 
 |loop_while              {printf("\nstmt");}
 |loop_for                {printf("\nstmt");}
 |loop_repeat_until       {printf("\nstmt");}
 |if_else_block           {printf("\nstmt");}
 |l_value ASSIGNMENT expr {printf("\nstmt");}
 |KEYWORD_RETURN expr     {printf("\nstmt");}
 |SEMICOLON
 ;

 l_value: IDENTIFIER COMMA l_value
 | IDENTIFIER
 ;

 // Loops
 loop_while: KEYWORD_WHILE expr KEYWORD_DO stmts KEYWORD_END {printf("\nloop_while");}
 ;
 
 loop_for: loop_for_generic {printf("\nloop_for");}
 |loop_for_numeric {printf("\nloop_for");}
 ;

 loop_for_generic: KEYWORD_FOR IDENTIFIER KEYWORD_IN expr KEYWORD_DO stmts KEYWORD_END {printf("\nloop_for_GENERIC");}
 ;

 loop_for_numeric: KEYWORD_FOR IDENTIFIER ASSIGNMENT expr_inc KEYWORD_DO stmts KEYWORD_END {printf("\nloop_for_NUMERIC");}
 ;

 expr_inc: IDENTIFIER COMMA IDENTIFIER {printf("\nEXPR_INC");}
 | IDENTIFIER COMMA IDENTIFIER COMMA IDENTIFIER {printf("\nEXPR_INC");}
 ;

 loop_repeat_until: KEYWORD_REPEAT stmts KEYWORD_UNTIL expr {printf("\nLOOP_REPEAT_UNTIL");}
 ;

 // If else block
 if_else_block: KEYWORD_IF expr KEYWORD_THEN stmts else_if_block {printf("\nIF_ELSE_BLOCK");}
 ;

 else_if_block: KEYWORD_END {printf("\nelse_if_block");}
 |KEYWORD_ELSEIF expr KEYWORD_THEN stmts else_if_block {printf("\nelse_if_block");}
 |KEYWORD_ELSE stmts KEYWORD_END {printf("\nelse_if_block");}
 ;

 // Functions
 function_block: KEYWORD_FUNCTION IDENTIFIER PARENTHESIS_LEFT l_value PARENTHESIS_RIGHT stmts KEYWORD_END {printf("\nFUNCTION_BLOCK");}
 ;

 const_function: KEYWORD_FUNCTION PARENTHESIS_LEFT l_value PARENTHESIS_RIGHT stmts KEYWORD_END {printf("\nconst_function");}
 ;

 params: {printf("\nPARAMS");}
 |expr COMMA params {printf("\nPARAMS");}
 |expr {printf("\nPARAMS");}
 |table_constructor {printf("\nPARAMS");}
 |CONST_STRING {printf("\nPARAMS");}
 ;

 // Constants
 constant: CONST_STRING {printf("\nCONSTANT");}
 |CONST_FLOAT {printf("\nCONSTANT");}
 |CONST_INTEGER {printf("\nCONSTANT");}
 |const_function {printf("\nCONSTANT");}
 |KEYWORD_NIL {printf("\nCONSTANT");}
 |KEYWORD_FALSE {printf("\nCONSTANT");}
 |KEYWORD_TRUE {printf("\nCONSTANT");}
 ;

 //table_constructor
 table_constructor: BRACE_LEFT FIELDS BRACE_RIGHT {printf("\nTABLE_CONSTRUCTOR");}
 FIELDS: expr {printf("\nFIELDS");}
 | BRACKET_LEFT expr BRACE_RIGHT ASSIGNMENT expr {printf("\nFIELDS");}
 | IDENTIFIER ASSIGNMENT expr {printf("\nFIELDS");}
 ;

 expr: expr bin_operator expr {printf("\nEXPR");}
 |unary_operator expr {printf("\nEXPR");}
 |constant  {printf("\nEXPR");}
 |IDENTIFIER {printf("\nEXPR");}
 |PARENTHESIS_LEFT expr PARENTHESIS_RIGHT {printf("\nEXPR");}
 |expr PARENTHESIS_LEFT params PARENTHESIS_RIGHT {printf("\nEXPR");}
 ;

 //exprs: expr {COMMA expr}
 bin_operator:
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
 ;

 |CONCATENATION       {printf("\nBIN_OPERATOR");}

 //Bit-wise operators
 |AMPERSAND           {printf("\nBIN_OPERATOR");}
 |PIPE                {printf("\nBIN_OPERATOR");}
 |LEFT_SHIFT          {printf("\nBIN_OPERATOR");}
 |RIGHT_SHIFT         {printf("\nBIN_OPERATOR");}

 unary_operator: HASH                {printf("\nUNARY_OPERATOR");}
 |MINUS {printf("\nUNARY_OPERATOR");}
 |KEYWORD_NOT {printf("\nUNARY_OPERATOR");}
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
