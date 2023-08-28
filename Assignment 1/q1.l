%{

%}

%%
"--[a-z`A-Z0-9]*"    {printf("%s -> Comment\n", yytext);}

\"[a-zA-Z0-9]*\"	{printf("%s -> String\n", yytext);}

"and"|"break"|"do"|"else"|"elseif"|"end"|"false"|"for"|"function"|"goto"|"if"|"in"|"local"|"nil"|"not"|"or"|"repeat"|"return"|"then"|"true"|"until"|"while"	{printf("%s -> Keyword\n", yytext);}

"+"|"-"|"*"|"/"|"%"|"<"|">"|"<="|">="|"=="|"~="|"="|"+="|"-="|"*="|"/="|"%="|".."|"#"|"^"|"&"|"~"|"|"|"<<"|">>"|"//"|"("|")"|"{"|"}"|"["|"]"|"::"|";"|":"|","|"."|".."|"..."|"\'"|"\""	{printf("%s -> Operator\n", yytext);}

";"|","|":"|"."|"("|")"|"{"|"}"|"["|"]"|"..."	{printf("%s -> Separator\n", yytext);}

[0-9]+	{printf("%s -> Number\n", yytext);}

[a-zA-Z0-9]*	{printf("%s -> Identifier\n", yytext);}

%%

int yywrap(void){return 1;}
int main()
{
printf("Enter String\n");
yylex();
}

