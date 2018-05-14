## Tokenizer Grammar
```
start -> atom verb atom | atom
atom -> string | bool | number

verb -> ^[+\-*%!&|<>=~,^#_$?@.]
string -> ^"(\\.|[^"\\\r\n])*"?
number -> ^(-?0w|0N|-?\d+\.\d*|-?\d*\.?\d+)
```
