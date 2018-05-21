### Regexes
- PCRE grammar for regexes is used `nre` library in Nim

### Tokenizer Grammar
```
start -> list verb start | list verb adverb start | list
list -> "(" ")" | "(" blist ")" | nlist | atom
blist -> list semi blist | list
nlist -> number nlist | bool | number
atom -> string | bool | number

verb -> ^[+\-*%!&|<>=~,^#_$?@.]
string -> ^"(\\.|[^"\\\r\n])*"?
number -> ^(-?0w|0N|-?\d+\.\d*|-?\d*\.?\d+)
adverb -> ^['\\\/]:?
bool -> (?i:^[01]+b)
```
