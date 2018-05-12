import tables, sequtils

type
    Ktype = enum
      knumber=0,
      kchar=1,
      ksymbol=2,
      klist=3
      kdictionary=4,
      kfunction=5,
      # kview=6,
      # knameref=7,
      # kverb=8,
      # kadverb=9,
      # kreturn=10,
      # knil=11,
      # kcond=12,
      # kquote=13

    Ktuple = tuple[x: Katom, y: Katom]

    Katom = ref object
      case t: Ktype
      of knumber: v0: float
      of kchar: v1: char
      of ksymbol: v2: string
      of klist: v3: seq[Katom]
      of kdictionary: v4: TableRef[Katom, Katom]
      of kfunction:
        left, right: Katom
        v5: string

proc kn(v: float): Katom = Katom(t: knumber, v0: v)
proc kn(v: int): Katom = Katom(t: knumber, v0: v.toFloat)
proc ks(v: string): Katom = Katom(t: ksymbol, v2: v)
proc kl(v: seq[Katom]): Katom = Katom(t: klist, v3: v)


proc klen(x: Katom): Katom = 
        case x.t
        of knumber: return kn(1)
        of kchar: return kn(1)
        of ksymbol: return kn(1)
        of klist: return kn(x.v3.len)
        of kdictionary: return kn(x.v4.len)
        of kfunction: return kn(1)

proc zip(x: seq[Katom], y: seq[Katom]): seq[Ktuple] =
  if x.len == y.len:
    result = zip(x, y)
  else:
    echo "length error."
    result = @[]



proc d_plus(left: Katom, right: Katom): Katom =
  if left.t == knumber and right.t == knumber:
    result = kn(left.v0 + right.v0)
  elif left.t == knumber and right.t == klist:
    result = kl(map(right.v3, proc(x: Katom): Katom = d_plus(left, x)))
  elif left.t == klist and right.t == knumber:
    result = kl(map(left.v3, proc(x: Katom): Katom = d_plus(x, right)))
  elif left.t == klist and right.t == klist:
    if klen(left).v0 == klen(right).v0:
      result = kl(zip(left.v3, right.v3).map(proc(xy: Ktuple): Katom = d_plus(xy.x, xy.y)))