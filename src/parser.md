## Tokenizer Grammar
```
start -> list verb start | list
list -> "(" list ")" | "(" list ";" list ")" | nlist | atom
nlist -> number nlist | number
atom -> string | bool | number

verb -> ^[+\-*%!&|<>=~,^#_$?@.]
string -> ^"(\\.|[^"\\\r\n])*"?
number -> ^(-?0w|0N|-?\d+\.\d*|-?\d*\.?\d+)
```
