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