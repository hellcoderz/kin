## Tokenizer Grammar
```
start -> list verb start | list
list -> "(" ")" | "(" blist ")" | nlist | atom
blist -> list semi blist | list
nlist -> number nlist | number
atom -> string | bool | number

verb -> ^[+\-*%!&|<>=~,^#_$?@.]
string -> ^"(\\.|[^"\\\r\n])*"?
number -> ^(-?0w|0N|-?\d+\.\d*|-?\d*\.?\d+)
```
