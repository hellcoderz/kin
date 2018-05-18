## Tokenizer Grammar
```
start -> list1 verb list1 | list
list1 -> nlist | atom
nlist -> number nlist | number
atom -> string | bool | number

verb -> ^[+\-*%!&|<>=~,^#_$?@.]
string -> ^"(\\.|[^"\\\r\n])*"?
number -> ^(-?0w|0N|-?\d+\.\d*|-?\d*\.?\d+)
```
