yacc -H lua.y && exit 1
flex lua.l && exit 2
gcc lex.yy.c y.tab.c -o syntax_analyser.o && exit 3
if [ "$1" == "test" ]; then
  cat test.lua | ./syntax_analyser.o
fi
