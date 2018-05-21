import ./parser, unittest, macros, sequtils, strutils, nre, ./programs

suite "Testing Regexes":
    test "NUMBER":
        check "56".find(NUMBER).get().`$` == "56"
        check "564242".find(NUMBER).get().`$` == "564242"
        check "56.2423".find(NUMBER).get().`$` == "56.2423"
        check "-56".find(NUMBER).get().`$` == "-56"
        check "0N".find(NUMBER).get().`$` == "0N"
        check "-342.2342".find(NUMBER).get().`$` == "-342.2342"
        check "-.3232".find(NUMBER).get().`$` == "-.3232"
        check "0w".find(NUMBER).get().`$` == "0w"

    test "HEXLIT":
        check "0xadadsad".find(HEXLIT).get().`$` == "0xadadsad"

    test "BOOL":
        check "010101b".find(BOOL).get().`$` == "010101b"
        check "001011B".find(BOOL).get().`$` == "001011B"

    test "NAME":
        check "mean1231".find(NAME).get().`$` == "mean1231"
        check "m23n23nMMMafsfs".find(NAME).get().`$` == "m23n23nMMMafsfs"
    
    test "SYMBOL":
        check "`".find(SYMBOL).get().`$` == "`"
        check "`vavva3232".find(SYMBOL).get().`$` == "`vavva3232"

    test "SPACEORNOT":
        check " ".find(SPACEORNOT).get().`$` == " "
        check "              ".find(SPACEORNOT).get().`$` == "              "
        check "".find(SPACEORNOT).get().`$` == ""

    test "STRING":
        check "\"hello world\"".find(STRING).get().`$` == "\"hello world\""

suite "Tokenizer Test":
    test "testing r_atom only":
        check tokenize("45.56").getTokenStates().`$` == "r_number"
        check tokenize("454243").getTokenStates().`$` == "r_number"
        check tokenize("-45.56").getTokenStates().`$` == "r_number"
        check tokenize("45").getTokenStates().`$` == "r_number"
        check tokenize("010101b").getTokenStates().`$` == "r_bool"
        check tokenize("\"hello world 343432\"").getTokenStates().`$` == "r_string"

    test "testin r_atom r_verb r_atom":
        check tokenize("45.56+43.56").getTokenStates().`$` == "r_number|r_verb|r_number"

suite "Tokenizer Samples tests":
    test "Samples Set 1":
        check tokenize("36.78   +   467.89").getTokenStates().`$` == "r_number|r_verb|r_number"
        check tokenize("45.67").getTokenStates().`$` == "r_number"
        check tokenize("\"hello world\"").getTokenStates().`$` == "r_string"
        check tokenize("1+\"hello\"").getTokenStates().`$` == "r_number|r_verb|r_string"
        check tokenize("1 2 3 4 5").getTokenStates().`$` == "r_number|r_number|r_number|r_number|r_number"
        check tokenize("1 2 3 4 + 1").getTokenStates().`$` == "r_number|r_number|r_number|r_number|r_verb|r_number"
        check tokenize("1+ 232.54 1 2 3 4").getTokenStates().`$` == "r_number|r_verb|r_number|r_number|r_number|r_number|r_number"
        check tokenize("1 2 3 4 + 1 45.6 -67.7").getTokenStates().`$` == "r_number|r_number|r_number|r_number|r_verb|r_number|r_number|r_number"
        check tokenize("1+2+3").getTokenStates().`$` == "r_number|r_verb|r_number|r_verb|r_number"
        check tokenize("1 2 3 45.5 + 5 6 7 4 + 4 5 6 23.45").getTokenStates().`$` == "r_number|r_number|r_number|r_number|r_verb|r_number|r_number|r_number|r_number|r_verb|r_number|r_number|r_number|r_number"
        check tokenize("(1 2 3 4)").getTokenStates().`$` == "r_open_p|r_number|r_number|r_number|r_number|r_close_p"
        check tokenize("(1 ; 3)").getTokenStates().`$` == "r_open_p|r_number|r_semi|r_number|r_close_p"
        check tokenize("(1 2 3  ; 34 5  6 66 6)").getTokenStates().`$` == "r_open_p|r_number|r_number|r_number|r_semi|r_number|r_number|r_number|r_number|r_number|r_close_p"
        check tokenize("(1 2 3  ; 34 5  6 66 6; 23 -45.565)").getTokenStates().`$` == "r_open_p|r_number|r_number|r_number|r_semi|r_number|r_number|r_number|r_number|r_number|r_semi|r_number|r_number|r_close_p"
        check tokenize("(1 2 3  ; 34 5  6 66 6; 23 -45.565; (1 2 3;3 4; \"stringfsfsfsf\") ; 3 4 5 6)").getTokenStates().`$` == "r_open_p|r_number|r_number|r_number|r_semi|r_number|r_number|r_number|r_number|r_number|r_semi|r_number|r_number|r_semi|r_open_p|r_number|r_number|r_number|r_semi|r_number|r_number|r_semi|r_string|r_close_p|r_semi|r_number|r_number|r_number|r_number|r_close_p"
        check tokenize("(\"dadadd\" ; \"adadadadadad\")").getTokenStates().`$` == "r_open_p|r_string|r_semi|r_string|r_close_p"
        check tokenize("(   )").getTokenStates().`$` == "r_open_p|r_close_p"
        check tokenize("1     +     /    1 2 3 4").getTokenStates().`$` == "r_number|r_verb|r_adverb|r_number|r_number|r_number|r_number"
        check tokenize("0101010b + 1 2 3 4 5 - 10101010b").getTokenStates().`$` == "r_bool|r_verb|r_number|r_number|r_number|r_number|r_number|r_verb|r_bool"
        check tokenize("(1+2)+3").getTokenStates().`$` == "r_open_p|r_number|r_verb|r_number|r_close_p|r_verb|r_number"