type
    Ksymbol = string
    Klist = array[]
    Ktype = enum
      knumber=0,
      kchar=1,
      ksymbol=2,
      klist=3
      kdictionary=4,
      kfunction=5,
      kview=6,
      knameref=7,
      kverb=8,
      kadverb=9,
      kreturn=10,
      knil=11,
      kcond=12,
      kquote=13


proc getType(x: float): Ktype = knumber
proc getType(x: char): Ktype = kchar
proc getType(x: Ksymbol): Ktype = ksymbol
proc getType(x: Klist): Ktype =  klist

proc kplus(x: float, y: float): float = x + y
proc kminus(x: float, y: float): float = x - y


