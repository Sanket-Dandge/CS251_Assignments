%{

%}

LONG_BRACKETS \[\[[^\]\]]*?\]\]

%%
--{LONG_BRACKETS}             {printf("COMMENT_LONG \t\t%s\n", yytext);}
--.*                          {printf("COMMENT_SHORT \t\t%s\n", yytext);}

\"([^"\n]|\\\"|\\\n)*\"       {printf("CONST_STRING \t\t%s\n", yytext);}
{LONG_BRACKETS}               {printf("CONST_STRING \t\t%s\n", yytext);}

[0-9]+	{printf("%s -> Number\n", yytext);}

"and"      {printf("KEYWORD_AND \n");}
"break"    {printf("KEYWORD_BREAK \n");}
"do"       {printf("KEYWORD_DO \n");}
"else"     {printf("KEYWORD_ELSE \n");}
"elseif"   {printf("KEYWORD_ELSEIF \n");}
"end"      {printf("KEYWORD_END \n");}
"false"    {printf("KEYWORD_FALSE \n");}
"for"      {printf("KEYWORD_FOR \n");}
"function" {printf("KEYWORD_FUNCTION \n");}
"goto"     {printf("KEYWORD_GOTO \n");}
"if"       {printf("KEYWORD_IF \n");}
"in"       {printf("KEYWORD_IN \n");}
"local"    {printf("KEYWORD_LOCAL \n");}
"nil"      {printf("KEYWORD_NIL \n");}
"not"      {printf("KEYWORD_NOT \n");}
"or"       {printf("KEYWORD_OR \n");}
"repeat"   {printf("KEYWORD_REPEAT \n");}
"return"   {printf("KEYWORD_RETURN \n");}
"then"     {printf("KEYWORD_THEN \n");}
"true"     {printf("KEYWORD_TRUE \n");}
"until"    {printf("KEYWORD_UNTIL \n");}
"while"    {printf("KEYWORD_WHILE \n");}

"+"        {printf("PLUS \n");}
"-"        {printf("MINUS \n");}
"*"        {printf("ASTERISK \n");}
"/"        {printf("DIVIDE \n");}
"%"        {printf("MOD \n");}
"^"        {printf("CARET \n");}
"#"        {printf("HASH \n");}
"&"        {printf("AMPERSAND \n");}
"~"        {printf("TILDE \n");}
"|"        {printf("PIPE \n");}
"<<"       {printf("LEFT_SHIFT \n");}
">>"       {printf("RIGHT_SHIFT \n");}
"//"       {printf("FLOOR_DIVISION \n");}
"=="       {printf("EQUAL_TO \n");}
"~="       {printf("NOT_EQUAL_TO \n");}
"<="       {printf("LESS_EQUAL_TO \n");}
">="       {printf("GREATER_EQUAL_TO \n");}
"<"        {printf("LESS_THAN \n");}
">"        {printf("GREATER_THAN \n");}
"="        {printf("ASSIGNMENT \n");}
"("        {printf("PARENTHESIS_LEFT \n");}
")"        {printf("PARENTHESIS_RIGHT \n");}
"{"        {printf("BRACE_LEFT \n");}
"}"        {printf("BRACE_RIGHT \n");}
"["        {printf("BRACKET_LEFT \n");}
"]"        {printf("BRACKET_RIGHT \n");}
"::"       {printf("SCOPE_RESOLUTION \n");}
";"        {printf("SEMICOLON \n");}
":"        {printf("COLON \n");}
","        {printf("COMMA \n");}
"."        {printf("DOT \n");}
".."       {printf("CONCATENATION \n");}
"..."      {printf("ELLIPSIS \n");}


[a-zA-Z0-9]*	{printf("%s -> Identifier\n", yytext);}
\n|" "|\t|\r|\f|\v {}
%%

int yywrap(void){return 1;}
int main()
{
  printf("Enter String\n");
  yylex();
}

