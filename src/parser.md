## Tokenizer Grammar
```
start -> list | atom verb atom | atom
list -> slist | blist | nlist
slist -> string list | string 
blist -> bool blist | bool
nlist -> number nlist | number
atom -> string | bool | number

verb -> ^[+\-*%!&|<>=~,^#_$?@.]
string -> ^"(\\.|[^"\\\r\n])*"?
number -> ^(-?0w|0N|-?\d+\.\d*|-?\d*\.?\d+)
```
