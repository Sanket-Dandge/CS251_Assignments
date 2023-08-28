%{

%}

LONG_BRACKETS \[\[[^\]\]]*?\]\]

%%
--{LONG_BRACKETS}             {printf("COMMENT_LONG       %s\n", yytext);}
--.*                          {printf("COMMENT_SHORT      %s\n", yytext);}

\"([^"\n]|\\\"|\\\n)*\"       {printf("CONST_STRING       %s\n", yytext);}
{LONG_BRACKETS}               {printf("CONST_STRING       %s\n", yytext);}

[0-9]+	{printf("%s -> Number\n", yytext);}

"and"                         {printf("KEYWORD_AND        %s\n", yytext);}
"break"                       {printf("KEYWORD_BREAK      %s\n", yytext);}
"do"                          {printf("KEYWORD_DO         %s\n", yytext);}
"else"                        {printf("KEYWORD_ELSE       %s\n", yytext);}
"elseif"                      {printf("KEYWORD_ELSEIF     %s\n", yytext);}
"end"                         {printf("KEYWORD_END        %s\n", yytext);}
"false"                       {printf("KEYWORD_FALSE      %s\n", yytext);}
"for"                         {printf("KEYWORD_FOR        %s\n", yytext);}
"function"                    {printf("KEYWORD_FUNCTION   %s\n", yytext);}
"goto"                        {printf("KEYWORD_GOTO       %s\n", yytext);}
"if"                          {printf("KEYWORD_IF         %s\n", yytext);}
"in"                          {printf("KEYWORD_IN         %s\n", yytext);}
"local"                       {printf("KEYWORD_LOCAL      %s\n", yytext);}
"nil"                         {printf("KEYWORD_NIL        %s\n", yytext);}
"not"                         {printf("KEYWORD_NOT        %s\n", yytext);}
"or"                          {printf("KEYWORD_OR         %s\n", yytext);}
"repeat"                      {printf("KEYWORD_REPEAT     %s\n", yytext);}
"return"                      {printf("KEYWORD_RETURN     %s\n", yytext);}
"then"                        {printf("KEYWORD_THEN       %s\n", yytext);}
"true"                        {printf("KEYWORD_TRUE       %s\n", yytext);}
"until"                       {printf("KEYWORD_UNTIL      %s\n", yytext);}
"while"                       {printf("KEYWORD_WHILE      %s\n", yytext);}

"+"                           {printf("PLUS               %s\n", yytext);}
"-"                           {printf("MINUS              %s\n", yytext);}
"*"                           {printf("ASTERISK           %s\n", yytext);}
"/"                           {printf("DIVIDE             %s\n", yytext);}
"%"                           {printf("MOD                %s\n", yytext);}
"^"                           {printf("CARET              %s\n", yytext);}
"#"                           {printf("HASH               %s\n", yytext);}
"&"                           {printf("AMPERSAND          %s\n", yytext);}
"~"                           {printf("TILDE              %s\n", yytext);}
"|"                           {printf("PIPE               %s\n", yytext);}
"<<"                          {printf("LEFT_SHIFT         %s\n", yytext);}
">>"                          {printf("RIGHT_SHIFT        %s\n", yytext);}
"//"                          {printf("FLOOR_DIVISION     %s\n", yytext);}
"=="                          {printf("EQUAL_TO           %s\n", yytext);}
"~="                          {printf("NOT_EQUAL_TO       %s\n", yytext);}
"<="                          {printf("LESS_EQUAL_TO      %s\n", yytext);}
">="                          {printf("GREATER_EQUAL_TO   %s\n", yytext);}
"<"                           {printf("LESS_THAN          %s\n", yytext);}
">"                           {printf("GREATER_THAN       %s\n", yytext);}
"="                           {printf("ASSIGNMENT         %s\n", yytext);}
"("                           {printf("PARENTHESIS_LEFT   %s\n", yytext);}
")"                           {printf("PARENTHESIS_RIGHT  %s\n", yytext);}
"{"                           {printf("BRACE_LEFT         %s\n", yytext);}
"}"                           {printf("BRACE_RIGHT        %s\n", yytext);}
"["                           {printf("BRACKET_LEFT       %s\n", yytext);}
"]"                           {printf("BRACKET_RIGHT      %s\n", yytext);}
"::"                          {printf("SCOPE_RESOLUTION   %s\n", yytext);}
";"                           {printf("SEMICOLON          %s\n", yytext);}
":"                           {printf("COLON              %s\n", yytext);}
","                           {printf("COMMA              %s\n", yytext);}
"."                           {printf("DOT                %s\n", yytext);}
".."                          {printf("CONCATENATION      %s\n", yytext);}
"..."                         {printf("ELLIPSIS           %s\n", yytext);}


[a-zA-Z_][a-zA-Z0-9_]*	      {printf("IDENTIFIER         %s\n", yytext);}
\n|" "|\t|\r|\f|\v {}
%%

int yywrap(void){return 1;}
int main()
{
  printf("Enter String\n");
  yylex();
}

