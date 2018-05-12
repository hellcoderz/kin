import ./ok, unittest, macros, sequtils, strutils

suite "Testing Equality within Katoms":
    test "testing for knumber":
        check kn(1) == kn(1)
        check kn(1.0) == kn(1.0)
        check kn(1) == kn(1.0)
    
    test "testing for kchar":
        check kc('c') == kc('c')

    test "testing for ksymbol":
        check ks("name12") == ks("name12")

    test "testing for klist":
        check kl(@[kn(1.0), kn(2.0)]) == kl(@[kn(1.0), kn(2.0)])
        check klc("hello world") == klc("hello world")


suite "Testing dyadic plus":
    test "knumber + knumber":
        check d_plus(kn(2), kn(3)) == kn(5)
        check d_plus(kn(4.5), kn(5)) == kn(9.5)

    test "knumber + klist[knumber]":
        check d_plus(kn(1.5), kln(@[1,2,3,4,5])) == kln(@[2.5, 3.5, 4.5, 5.5, 6.5])

    test "klist[knumber] + knumber":
        check d_plus(kln(@[1,2,3,4,5]), kn(1.5)) == kln(@[2.5, 3.5, 4.5, 5.5, 6.5])

    test "klist[knumber] + klist[knumber]":
        check d_plus(kln(@[1,2,3,4,5]), kln(@[1,2,3,4,5])) == kln(@[2, 4, 6, 8, 10])