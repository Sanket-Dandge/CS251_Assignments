#!/bin/bash

yacc -H lua.y 2> /dev/null
flex lua.l 2> /dev/null
gcc lex.yy.c y.tab.c -o syntax_analyser_lua.o 2> /dev/null
if [ "$1" == "test" ]; then
  for file in $(ls tests); do
    cat tests/$file | ./syntax_analyser_lua.o
  done
fi
