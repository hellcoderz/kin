import ./parser, unittest, macros, sequtils, strutils

var
    p1 = "3+4"
    p2 = "3+1 2 3"
    p3 = "1 2 3+1 2 3"