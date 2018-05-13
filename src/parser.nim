import ./kin, tables, strutils, sequtils

proc parse(program: string): Katom =
    return kf("+", kn(), kn())

if isMainModule:
    echo "Parsing Module for K Language implementation in Nim [v0.0.1]"