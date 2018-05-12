import ./parser, unittest, macros, sequtils, strutils

suite "Katom test":
    test "knumber(s) as input":
        check 1 == 1