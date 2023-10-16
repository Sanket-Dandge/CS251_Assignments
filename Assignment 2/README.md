# The Lua Syntax Analyzer

## Requirements

- Following tools are required to compile the syntax analyzer:
    - lex
    - yacc
    - gcc

## Compiling

- Navigate to directory containing lua.l and lua.y files and run the following commands:
    ```sh
    yacc -H lua.y 
    lex lua.l 
    gcc lex.yy.c y.tab.c -o syntax_analyser_lua.o 
    ```

## Usage

- There are two ways to use this:
    1. Run the executable and give the input by entering text
        ```sh
        ./syntax_analyser_lua.o
        ```
        **Note:** There is no prompt for input but rather the line will remain
        blank. Use <C-D> to exit.
    2. You can also pipe the contents of test lua files provided in the tests directory.
        ```sh
        ./syntax_analyser_lua.o < tests/<filename>
        ```
- Alternatively you can use the `compile_and_test.sh` script provided, it will run tests on all the test cases provided.
    ```sh
    ./compile_and_test.sh test
    ```

## References
1. [Official Lua Documentation](https://www.lua.org/manual/5.4/)
2. [Lua Test Cases](https://www.lua.org/wshop15/Ierusalimschy.pdf)

    
