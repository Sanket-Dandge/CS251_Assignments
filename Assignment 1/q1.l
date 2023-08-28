%{

%}

LONG_BRACKETS \[\[[^\]\]]*?\]\]

%%
--{LONG_BRACKETS}             {printf("COMMENT_LONG %s\n", yytext);}
--.*                          {printf("COMMENT_SHORT %s\n", yytext);}

\"([^"\n]|\\\"|\\\n)*\"       {printf("CONST_STRING %s\n", yytext);}
{LONG_BRACKETS}               {printf("CONST_STRING %s\n", yytext);}

[0-9]+	{printf("%s -> Number\n", yytext);}

"and"|"break"|"do"|"else"|"elseif"|"end"|"false"|"for"|"function"|"goto"|"if"|"in"|"local"|"nil"|"not"|"or"|"repeat"|"return"|"then"|"true"|"until"|"while"	{printf("%s -> Keyword\n", yytext);}

"+"|"-"|"*"|"/"|"%"|"<"|">"|"<="|">="|"=="|"~="|"="|"+="|"-="|"*="|"/="|"%="|".."|"#"|"^"|"&"|"~"|"|"|"<<"|">>"|"//"|"("|")"|"{"|"}"|"["|"]"|"::"|";"|":"|","|"."|".."|"..."|"\'"|"\""	{printf("%s -> Operator\n", yytext);}

";"|","|":"|"."|"("|")"|"{"|"}"|"["|"]"|"..."	{printf("%s -> Separator\n", yytext);}


[a-zA-Z0-9]*	{printf("%s -> Identifier\n", yytext);}
\n|" "|\t|\r|\f|\v {}
%%

int yywrap(void){return 1;}
int main()
{
  printf("Enter String\n");
  yylex();
}

