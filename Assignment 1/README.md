# The Lua Lexical Analyser

## Requirements

- Following tools are required to compile the lexical analyser:
    - lex
    - gcc

## Compiling

- Navigate to directory containing lua.l file and run the following commands:
    ```sh
    lex -o lua.yy.c lua.l
    gcc lua.yy.c -o lua_lexical_analyser.o
    ```

## Usage

- The generated executable `lua_lexical_analyser.o` will accept input on `stdin`.
- There are two ways to use this:
    1. Run the executable and give the input by entering text
        ```sh
        ./lua_lexical_analyser.o
        ```
        **Note:** There is no prompt for input but rather the line will remain
        blank. Use <C-D> to exit.
    2. You can also pipe the contents of `test.lua` file provided.
        ```sh
        ./lua_lexical_analyser.o < test.lua
        ```
