import tables, sequtils, strformat

type
    Kverb* = enum # K build-in verbs
        kplus=0,
        kminus=1,
        kmul=2,
        kpercent=3,
        khash=4,
        kbang=5,
        # TODO: add more
    
    Kadverb* = enum # K build-in verbs
        kfslash=0
        # TODO: add more

    Kobj = ref object of RootObj
    Knumber = ref object of Kobj
        v: float
    Kint = ref object of Kobj
        v: int
    Kchar = ref object of Kobj
        v: int
    Ksymbol = ref object of Kobj
        v: string
    Klist = ref object of Kobj
        v: seq[Kobj]
    Kfunction = ref object of Kobj
        v: Kverb
        a: Kadverb
        left: Kobj
        right: Kobj   

    Ktype* = enum # K built-in and only supported datatypes
        knumber=0,
        kchar=1,
        ksymbol=2,
        klist=3
        kdictionary=4,
        kfunction=5,
        knil=6,
        # kview=6,
        # knameref=7,
        # kverb=8,
        # kadverb=9,
        # kreturn=10,
        # knil=11,
        # kcond=12,
        # kquote=13

var
    x = Kint(v: 5)
    y = Knumber(v: 5.6)
    s1 = Klist(v: @[Kchar(v: 45)])

echo x.v.toFloat + y.v