## Tokenizer Grammar
```
start -> list verb list | list verb atom | atom verb list | atom verb atom | list | atom
list -> slist | blist | nlist
slist -> string list | string
blist -> bool blist | bool
nlist -> number nlist | number
atom -> string | bool | number

verb -> ^[+\-*%!&|<>=~,^#_$?@.]
string -> ^"(\\.|[^"\\\r\n])*"?
number -> ^(-?0w|0N|-?\d+\.\d*|-?\d*\.?\d+)
```
