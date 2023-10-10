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
 STMTS: /*empty*/ {}
 |STMT STMTS {}
 
 STMT: FUNCTION_BLOCK {} 
 |LOOP_WHILE {}
 |LOOP_FOR {}
 |LOOP_REPEAT_UNTIL {}
 |IF_ELSE_BLOCK {}

 FUNCTION_BLOCK: KEYWORD_FUNCTION IDENTIFIER PARENTHESIS_LEFT PARAMS PARENTHESIS_RIGHT STMTS KEYWORD_END {}

 LOOP_WHILE: KEYWORD_WHILE EXPR KEYWORD_DO STMTS KEYWORD_END {}
 
 LOOP_FOR: LOOP_FOR_GENERIC {}
 |LOOP_FOR_NUMERIC {}

 LOOP_FOR_GENERIC: KEYWORD_FOR IDENTIFIER KEYWORD_IN EXPR KEYWORD_DO STMTS KEYWORD_END {}

 LOOP_FOR_NUMERIC: KEYWORD_FOR IDENTIFIER ASSIGNMENT EXPR_INC KEYWORD_DO STMTS KEYWORD_END {}

 IF_ELSE_BLOCK: KEYWORD_IF EXPR KEYWORD_THEN STMTS ELSE_IF_BLOCK {}

 ELSE_IF_BLOCK: KEYWORD_END {}
 |KEYWORD_ELSEIF EXPR KEYWORD_THEN STMTS ELSE_IF_BLOCK {}
 |KEYWORD_ELSE STMTS KEYWORD_END {}

 LOOP_REPEAT_UNTIL: KEYWORD_REPEAT STMTS KEYWORD_UNTIL EXPR

 PARAMS: {}
 |EXPR COMMA PARAMS
 |EXPR

 EXPR_INC: IDENTIFIER COMMA IDENTIFIER
 | IDENTIFIER COMMA IDENTIFIER COMMA IDENTIFIER

 CONSTANT: CONST_STRING
 |CONST_FLOAT
 |CONST_INTEGER
 |CONST_FUNCTION

 CONST_FUNCTION: KEYWORD_FUNCTION PARENTHESIS_LEFT PARAMS PARENTHESIS_RIGHT STMTS KEYWORD_END {}

 EXPR: EXPR BIN_OPERATOR EXPR
 |UNARY_OPERATOR EXPR
 |CONSTANT 
 |IDENTIFIER
 |PARENTHESIS_LEFT EXPR PARENTHESIS_RIGHT
 |EXPR PARENTHESIS_LEFT EXPR PARENTHESIS_RIGHT {/*Function Calls */}
 |
 BIN_OPERATOR: PLUS               
 |MINUS              
 |ASTERISK           
 |DIVIDE             
 |CARET             
 //Relational Operators
 |EQUAL_TO           
 |NOT_EQUAL_TO       
 |LESS_EQUAL_TO      
 |GREATER_EQUAL_TO   
 |LESS_THAN          
 |GREATER_THAN
 //Logical Operators
 |KEYWORD_AND
 |KEYWORD_OR

 |CONCATENATION      
 |MOD                
 |AMPERSAND          
 |TILDE              
 |PIPE               
 |LEFT_SHIFT         
 |RIGHT_SHIFT        
 |FLOOR_DIVISION     
 |ASSIGNMENT         
 |PARENTHESIS_LEFT   
 |PARENTHESIS_RIGHT  
 |BRACE_LEFT         
 |BRACE_RIGHT        
 |BRACKET_LEFT       
 |BRACKET_RIGHT      
 |SCOPE_RESOLUTION   
 |SEMICOLON          
 |COLON              
 |COMMA              
 |DOT                
 |ELLIPSIS           

 UNARY_OPERATOR: HASH               
 |MINUS
 |KEYWORD_NOT
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
