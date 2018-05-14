import ./kin1, tables, strutils, sequtils, pegs

var grammar = peg"""
    expr <- symbol (verb / adverb) expr / function / number verb expr / number / \s expr
    function <- "{" expr "}"
    symbol <- {[`]?[A-Za-z][A-Za-z0-9_]*}
    number <- float / int
    int <- {\d+}
    float <- {\d+ '.' \d+}
    verb <- { ["+-*%"] }
    adverb <- { [":/\\'"] }
"""

var programs = @[
    "34+45.5",
    "45",
    "{3+44}",
    "mean: 3+4"
]

for program in programs:
    discard program =~ grammar
    echo matches

if isMainModule:
    echo "Parsing Module for K Language implementation in Nim [v0.0.1]"