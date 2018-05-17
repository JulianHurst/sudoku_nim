# Sudoku solver
A simple recursive sudoku solver written in nim.

## Compilation instructions
Because the code is recursive and the nim GC seems to (sometimes) have problems with the recursive call stack size, stackTrace must be switched off and the code must be optimized.

For developement run :  
```sh
nim c --stackTrace:off --opt:speed --debugger:native sudoku.nim
```

Otherwise run :  
```sh
nim c -d:release sudoku.nim
```
