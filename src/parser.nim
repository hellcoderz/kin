import ./kin, tables, strutils, sequtils, nre, strformat, rdstdin

var NUMBER*  = re"^(-?0w|0N|-?\d+\.\d*|-?\d*\.?\d+)"
var HEXLIT*  = re"(^0x[a-zA-Z\d]+)"
var BOOL*    = re"(?i:^[01]+b)"
var NAME*    = re"(?i:^[a-z][a-z\d]*)"
var SYMBOL*  = re"(?i:^`([a-z.][a-z0-9.]*)?)"
var STRING*  = re"""^"(\\.|[^"\\\r\n])*"?"""
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

type TokenType = enum
    r_number, r_hexlit, r_bool,
    r_name, r_symbol, r_string, r_verb,
    r_assign, r_ioverb, r_adverb, r_semi,
    r_colon, r_view, r_cond, r_dict,
    r_open_b, r_open_p, r_open_c, r_close_b,
    r_close_p, r_close_c, r_spaceornot,
    t_start, t_atom, t_list, tnlist, t_slist,
    t_blist

type Token = ref object of RootObj
    tok: string
    tokType: TokenType

type TokenTuple = tuple[tokens: seq[Token], left: string, found: bool]

var tokenType2regex = {
    r_number: NUMBER, r_hexlit: HEXLIT, r_bool: BOOL,
    r_name: NAME, r_symbol: SYMBOL, r_string: STRING, r_verb: VERB,
    r_assign: ASSIGN, r_ioverb: IOVERB, r_adverb: ADVERB, r_semi: SEMI,
    r_colon: COLON, r_view: VIEW, r_cond: COND, r_dict: DICT,
    r_open_b: OPEN_B, r_open_p: OPEN_P, r_open_c: OPEN_C, r_close_b: CLOSE_B,
    r_close_p: CLOSE_P, r_close_c: CLOSE_C, r_spaceornot: SPACEORNOT,
}.toTable

# Tokenizer Grammar for producing correct tokens
var grammar = {
    t_start: @[
        @[t_list, r_verb, r_adverb, t_start],
        @[t_list, r_verb, t_start],
        @[t_list]],
    t_list: @[
        @[r_open_p, r_close_p], # emply list rule
        @[r_open_p, t_blist, r_close_p],
        @[t_nlist],
        @[t_atom]],
    t_blist: @[@[t_list, r_semi, t_blist], @[t_list]],
    t_atom: @[@[r_string], @[r_bool], @[r_number]],
    t_nlist: @[@[r_number, t_nlist], @[r_number]],
}.toTable

proc getTokenStates*(tokens: seq[Token]): seq[TokenType] = 
    if tokens.len > 0:
        return tokens.map(proc(token: Token): TokenType = token.tokType)
    else:
        return @[]

proc `$`*(token: Token): string = fmt"token: {token.tok}   tokenType: {token.tokType}"
proc `$`*(tokenTypes: seq[TokenType]): string = 
    if tokenTypes.len > 0:
        return tokenTypes.map(proc(tokenType: TokenType): string = tokenType.`$`).foldl(a & "|" & b)
    else:
        return ""

proc tokenize(s: TokenType, p: string, tokens: seq[Token], path: seq[TokenType]): TokenTuple =
    # echo fmt"s={s} p={p}"
    var np = p.strip
    var ntokens = tokens
    var found = false
    if np.len == 0:
        return (tokens: ntokens, left: np, found: true)
    
    block b1:
        var i = -1
        for and_states in grammar[s]:
            i = i + 1
            # echo fmt"   {np}   {and_states}"
            block b2:
                var j = -1
                found = true
                for and_state in and_states:
                    j = j + 1
                    # echo fmt"       {np}   {and_state}"
                    # echo fmt"s={s} np={np} ass={and_states} as={and_state}"
                    if np.len == 0:
                        return (tokens: ntokens, left: np, found: true)
                    if and_state in tokenType2regex:
                        var match = np.find(tokenType2regex[and_state])
                        if match.isSome():
                            var token = Token(tok: match.get().`$`, tokType: and_state)
                            # echo token
                            ntokens = ntokens.concat(@[token])
                            np = np[match.get().captureBounds[-1].get().b+1..<np.len].strip
                        else:
                            np = p
                            ntokens = tokens
                            found = false
                            break b2
                    else:
                        var res = tokenize(and_state, np, ntokens, path.concat(@[and_state]))
                        if res.found == false:
                            np = p
                            ntokens = tokens
                            found = false
                            break b2
                        ntokens = res.tokens
                        np = res.left
            if found:
                break b1
    if np.len < p.len:
        return (tokens: ntokens, left: np, found: found)
    else:
        return (tokens: ntokens, left: np, found: found)

proc tokenize*(p: string): seq[Token] =
    var tokensTuple = tokenize(t_start, p.strip, @[], @[t_start])
    return tokensTuple.tokens


if isMainModule:
    echo "Parsing Module for K Language implementation in Nim [v0.0.1]"

    var programs = @[
        "36.78   +   467.89",
        "45.67",
        "\"hello world\"",
        "1+\"hello\"",
        "1 2 3 4 5",
        "1 2 3 4 + 1",
        "1+ 232.54 1 2 3 4",
        "1 2 3 4 + 1 45.6 -67.7",
        "1+2+3",
        "1 2 3 45.5 + 5 6 7 4 + 4 5 6 23.45",
        "(1 2 3 4)",
        "(1 ; 3)",
        "(1 2 3  ; 34 5  6 66 6)",
        "(1 2 3  ; 34 5  6 66 6; 23 -45.565)",
        "(1 2 3  ; 34 5  6 66 6; 23 -45.565; (1 2 3;3 4; \"stringfsfsfsf\") ; 3 4 5 6)",
        "(\"dadadd\" ; \"adadadadadad\")",
        "(   )",
        "1     +     /    1 2 3 4"
    ]

    for program in programs:
        echo program & " => " & tokenize(program).getTokenStates().`$`

    # echo "======================================================"
    # while true:
    #     var program = readLineFromStdin("> ")
    #     if program.strip != "quit":
    #         echo tokenize(program).getTokenStates().`$`
    #     else:
    #         echo "BYE."
    #         break