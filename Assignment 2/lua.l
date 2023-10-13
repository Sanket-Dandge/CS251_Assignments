%{
  #include "y.tab.h" 
  extern int yylval; 
  int linenr = 0;
%}

STRING (\"([^"\n]|\\\"|\\\n)*\")|(\'([^'\n]|\\\'|\\\n)*\')
LONG_BRACKETS \[\[[^\]\]]*?\]\]

DEC [0-9]
DEC_EXP ((E|e)[\+|-]?[0-9])
DEC_FLOAT ({DEC}*\.{DEC}+|{DEC}+\.{DEC}*){DEC_EXP}?|{DEC}+{DEC_EXP}

HEX [0-9a-fA-F]
HEX_EXP ((P|p)[\+|-]?[0-9])
HEX_FLOAT 0(x|X)(({HEX}*\.{HEX}+|{HEX}+\.{HEX}*){HEX_EXP}?|{HEX}+{HEX_EXP})

%%
--{LONG_BRACKETS}             return 0;
--.*                          return 0;

{STRING}                      {yylval = yytext; return CONST_STRING;}
{LONG_BRACKETS}               {yylval = yytext; return CONST_STRING;}

{DEC_FLOAT}|{HEX_FLOAT}       {yylval = yytext; return CONST_FLOAT;}
{DEC}+|0(x|X){HEX}+           {yylval = yytext; return CONST_INTEGER;}

"and"                         return KEYWORD_AND;
"break"                       return KEYWORD_BREAK;
"do"                          return KEYWORD_DO;
"else"                        return KEYWORD_ELSE;
"elseif"                      return KEYWORD_ELSEIF;
"end"                         return KEYWORD_END;
"false"                       return KEYWORD_FALSE;
"for"                         return KEYWORD_FOR;
"function"                    return KEYWORD_FUNCTION;
"goto"                        return KEYWORD_GOTO;
"if"                          return KEYWORD_IF;
"in"                          return KEYWORD_IN;
"local"                       return KEYWORD_LOCAL;
"nil"                         return KEYWORD_NIL;
"not"                         return KEYWORD_NOT;
"or"                          return KEYWORD_OR;
"repeat"                      return KEYWORD_REPEAT;
"return"                      return KEYWORD_RETURN;
"then"                        return KEYWORD_THEN;
"true"                        return KEYWORD_TRUE;
"until"                       return KEYWORD_UNTIL;
"while"                       return KEYWORD_WHILE;

"+"                           return PLUS;
"-"                           return MINUS;
"*"                           return ASTERISK;
"/"                           return DIVIDE;
"%"                           return MOD;
"^"                           return CARET;
"#"                           return HASH;
"&"                           return AMPERSAND;
"~"                           return TILDE;
"|"                           return PIPE;
"<<"                          return LEFT_SHIFT;
">>"                          return RIGHT_SHIFT;
"//"                          return FLOOR_DIVISION;
"=="                          return EQUAL_TO;
"~="                          return NOT_EQUAL_TO;
"<="                          return LESS_EQUAL_TO;
">="                          return GREATER_EQUAL_TO;
"<"                           return LESS_THAN;
">"                           return GREATER_THAN;
"="                           return ASSIGNMENT;
"("                           return PARENTHESIS_LEFT;
")"                           return PARENTHESIS_RIGHT;
"{"                           return BRACE_LEFT;
"}"                           return BRACE_RIGHT;
"["                           return BRACKET_LEFT;
"]"                           return BRACKET_RIGHT;
"::"                          return SCOPE_RESOLUTION;
";"                           return SEMICOLON;
":"                           return COLON;
","                           return COMMA;
"."                           return DOT;
".."                          return CONCATENATION;
"..."                         return ELLIPSIS;


[a-zA-Z_][a-zA-Z0-9_]*	      {
                                yylval = yytext;
                                return IDENTIFIER;
                              }

[ \t]									{ /* spacing */}
[\n]									{ linenr++;}
<<EOF>>                 				{printf("end %s \n", ""); return EXIT; }
. {printf("other chars%s \n", yytext); }
%%

int yywrap(void){return 1;}
