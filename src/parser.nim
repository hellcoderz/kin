import ./kin1, tables, strutils, sequtils, nre, strformat

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
var SPACEORNOT* = re"^\s*"

type ParseState = enum
    r_number, r_hexlit, r_bool,
    r_name, r_symbol, r_string, r_verb,
    r_assign, r_ioverb, r_adverb, r_semi,
    r_colon, r_view, r_cond, r_dict,
    r_open_b, r_open_p, r_open_c, r_close_b,
    r_close_p, r_close_c, r_spaceornot,
    p_start

type Token = ref object of RootObj
    tok: string
    tokType: ParseState

var state2regex = {
    r_number: NUMBER, r_hexlit: HEXLIT, r_bool: BOOL,
    r_name: NAME, r_symbol: SYMBOL, r_string: STRING, r_verb: VERB,
    r_assign: ASSIGN, r_ioverb: IOVERB, r_adverb: ADVERB, r_semi: SEMI,
    r_colon: COLON, r_view: VIEW, r_cond: COND, r_dict: DICT,
    r_open_b: OPEN_B, r_open_p: OPEN_P, r_open_c: OPEN_C, r_close_b: CLOSE_B,
    r_close_p: CLOSE_P, r_close_c: CLOSE_C, r_spaceornot: SPACEORNOT,
}.toTable

var stateTable = {
    p_start: @[@[r_number, r_verb, r_number]]
}.toTable


proc `$`(token: Token): string =
    return fmt"token: {token.tok}   tokenType: {token.tokType}"

proc parse(s: ParseState, p: string) =
    var np = p
    for and_states in stateTable[s]:
        for and_state in and_states:
            if and_state in state2regex:
                var match = np.find(state2regex[and_state])
                if match.isSome():
                    var token = Token(tok: match.get().`$`, tokType: and_state)
                    echo token
                    np = np[match.get().captureBounds[-1].get().b+1..<np.len].strip
                else:
                    echo "error parsing: " & np
                    break
            else:
                parse(and_state, np)

proc parse(p: string) =
    parse(p_start, p.strip)


if isMainModule:
    echo "Parsing Module for K Language implementation in Nim [v0.0.1]"
    parse("36.78   +   467.89")