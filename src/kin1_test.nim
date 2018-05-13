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

echo applyverb("plus", x, y)
echo applyverb("plus", x, l1)
echo applyverb("plus", l1, l1)
echo applyverb("plus", l1, l2)

echo applyverb("minus", x, y)
echo applyverb("minus", x, l1)
echo applyverb("minus", l1, l1)
echo applyverb("minus", l1, l2)