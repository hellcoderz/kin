import./kin1

var
    x = ki(5)
    y = kf(5.6)
    # s1 = Klist(v: @[Kchar(v: 45), Kchar(v: 56)])
    l1 = kl(@[ki(1), ki(2)])
    l2 = kl(@[ki(1), ki(2), kf(4.5)])

echo x
echo y
echo kstr("hello world")

echo applyverb(kplus, x, y)
echo applyverb(kplus, x, l1)
echo applyverb(kplus, l1, l1)
echo applyverb(kplus, l1, l2)

echo applyverb(kminus, x, y)
echo applyverb(kminus, x, l1)
echo applyverb(kminus, l1, l1)
echo applyverb(kminus, l1, l2)

var
    plusfn = kf(kplus, x, y)
    minusfn = kf(kminus, x, y)
    plusplusfn = kf(kplus, kf(kplus, x, y), kf(kplus, x, y))

echo eval(plusfn)
echo eval(minusfn)
echo eval(plusplusfn)