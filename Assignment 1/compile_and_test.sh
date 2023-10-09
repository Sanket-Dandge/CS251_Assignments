if [[ -z "$1" ]]; then
  inputfile="q1.l"
else
  inputfile="$1"
fi
flex $inputfile
gcc lex.yy.c -o lexical_analyser.o
cat test.lua | ./lexical_analyser.o
