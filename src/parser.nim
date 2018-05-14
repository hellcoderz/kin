import ./kin1, tables, strutils, sequtils, nre

var NUMBER*  = re"^(-?0w|0N|-?\d+\.\d*|-?\d*\.?\d+)"
var HEXLIT*  = re"(^0x[a-zA-Z\d]+)"
var BOOL*    = re"(?i:^[01]+b)"
var NAME*    = re"(?i:^[a-z][a-z\d]*)"
var SYMBOL*  = re"(?i:^`([a-z.][a-z0-9.]*)?)"
var STRING*  = re""" ^"(\\.|[^"\\\r\n])*" """
var VERB*    = re"^[+\-*%!&|<>=~,^#_$?@.]"
var ASSIGN*  = re"^[+\-*%!&|<>=~,^#_$?@.]:"
var IOVERB*  = re"^\d:"
var ADVERB*  = re"^['\\\/]:?"
var SEMI*    = re"^;"
var COLON*   = re"^:"
var VIEW*    = re"^::"
var COND*    = re"^\$\["
var DICT*    = re"(?i:^\[[a-z]+:)"
var OPEN_B*  = re"^\["
var OPEN_P*  = re"^\("
var OPEN_C*  = re"^{"
var CLOSE_B* = re"^\]"
var CLOSE_P* = re"^\)"
var CLOSE_C* = re"^}"

if isMainModule:
    echo "Parsing Module for K Language implementation in Nim [v0.0.1]"