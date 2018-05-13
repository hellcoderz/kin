import./kin1

var
    x = ki(5)
    y = kf(5.6)
    # s1 = Klist(v: @[Kchar(v: 45), Kchar(v: 56)])
    l1 = kl(@[ki(1), ki(2)])
    l2 = kl(@[ki(1), ki(2), kf(4.5)])
    l3 = kl(@[kf(6.7), l1, l2])

echo x
echo y
echo kstr("hello world")

echo applyverb("+", x, y)
echo applyverb("+", x, l1)
echo applyverb("+", l1, l1)
echo applyverb("+", l1, l2)

echo applyverb("-", x, y)
echo applyverb("-", x, l1)
echo applyverb("-", l1, l1)
echo applyverb("-", l1, l2)

echo applyverb("+", ki(1), l3)

var
    plusfn = kfn("+", x, y)
    minusfn = kfn("-", x, y)
    plusplusfn = kfn("+", kfn("+", x, y), kfn("+", x, y))

echo eval(plusfn)
echo eval(minusfn)
echo eval(plusplusfn)