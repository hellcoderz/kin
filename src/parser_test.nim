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