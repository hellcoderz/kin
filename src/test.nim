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


# echo klc("hello world")
# echo kzip(klc("abc").v3, klc("nfd").v3)
# echo @[true, false].count(true) == 2
# echo d_plus(kn(10), kn(-45.7))
# echo d_plus(kn(10), kl(@[kn(1), kn(2)]))