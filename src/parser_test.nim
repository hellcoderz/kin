import ./parser, unittest, macros, sequtils, strutils, nre, ./programs

suite "Testing Regexes":
    test "NUMBER":
        echo "56".find(NUMBER)
        echo "564242".find(NUMBER)
        echo "56.2423".find(NUMBER)
        echo "-56".find(NUMBER)
        echo "0N".find(NUMBER)
        echo "-342.2342".find(NUMBER)
        echo "-.3232".find(NUMBER)
        echo "0w".find(NUMBER)

    test "HEXLIT":
        echo "0xadadsad".find(HEXLIT)

    test "BOOL":
        echo "010101b".find(BOOL)
        echo "001011B".find(BOOL)

    test "NAME":
        echo "mean1231".find(NAME)
        echo "m23n23nMMMafsfs".find(NAME)
    
    test "SYMBOL":
        echo "`".find(SYMBOL)
        echo "`vavva3232".find(SYMBOL)

    test "SPACEORNOT":
        echo " ".find(SPACEORNOT)
        echo "              ".find(SPACEORNOT)
        echo "".find(SPACEORNOT)

    test "STRING":
        echo "\"hello world\"".find(STRING)