# The Lua Syntax Analyzer

## Requirements

- Following tools are required to compile the syntax analyzer:
    - lex
    - yacc
    - gcc

## Compiling

- Navigate to directory containing lua.l file and run the following commands:
    ```sh
    yacc -H lua.y 
    lex lua.l 
    gcc lex.yy.c y.tab.c -o lua_syntax_analyser.o 
    ```

## Usage

- There are two ways to use this:
    1. Run the executable and give the input by entering text
        ```sh
        ./lua_syntax_analyser.o
        ```
        **Note:** There is no prompt for input but rather the line will remain
        blank. Use <C-D> to exit.
    2. You can also pipe the contents of test lua files provided in the examples directory.
        ```sh
        ./lua_syntax_analyser.o < examples/<filename>
        ```

## References
1. [Official Lua Documentation](https://www.lua.org/manual/5.4/)
2. [Lua Test Cases](https://www.lua.org/wshop15/Ierusalimschy.pdf)

    
