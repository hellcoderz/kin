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

  Kstate = enum # states of left and right node only
    lrnil=0,  # left and right node are both nil
    rnil=1,   # only right node is nil
    lnil=2    # only left node is nil
    rl=3,
    ll=4,
    llrl=5

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

  Katom* = ref object # main K object for AST
    case t: Ktype
    of knumber: v0*: float
    of kchar: v1*: int
    of ksymbol: v2*: string
    of klist:
      rank*: Katom
      ltype*: Ktype
      v3*: seq[Katom]
    of kdictionary: v4*: TableRef[Katom, Katom]
    of kfunction:
      left*, right*: Katom
      op*: Kverb
    of knil: v11: string

########################################
##### KATOM CREATATION FUNCTIONS #######
########################################
proc kn*(v: string): Katom = Katom(t: knil, v11: v) # create a knil Katom with string message
proc kn*(): Katom = Katom(t: knil, v11: "NIL") # create a knil Katom
proc kn*(v: float): Katom = Katom(t: knumber, v0: v) # create a knumber Katom with float as input
proc kn*(v: int): Katom = Katom(t: knumber, v0: v.toFloat) # create a knumber Katom with int as input
proc ks*(v: string): Katom = Katom(t: ksymbol, v2: v) # create a ksymbol Katom
proc kl*(v: seq[Katom]): Katom = Katom(t: klist, v3: v) # create a klist Katom with seq of any type of Katom
proc kc*(v: int): Katom = Katom(t: kchar, v1: v) # create a kchar Katom with ascii value as input
proc kc*(v: char): Katom = Katom(t: kchar, v1: int(v)) # create a kchar Katom with char as input
# create a klist Katom with seq of kchar Katom (represents string data type)
proc klc*(v: string): Katom = Katom(t: klist, ltype: kchar, rank: kn(1), v3: toSeq(v.items).map(proc(c: char): Katom = kc(c)))
# create a klist Katom with seq of knumber[float] katom
proc kln*(v: seq[float]): Katom = Katom(t: klist, ltype: knumber, rank: kn(1), v3: v.map(proc(n: float): Katom = kn(n)))
# create a klist Katom with seq of knumber[int] katom
proc kln*(v: seq[int]): Katom = Katom(t: klist, ltype: knumber, rank: kn(1), v3: v.map(proc(n: int): Katom = kn(n)))
# create a function nde with 2 children
proc kf*(v: Kverb, left: Katom, right: Katom): Katom = Katom(t: kfunction, left: left, right: right, op: v)
# create a function nde with right children only
proc kfr*(v: Kverb, right: Katom): Katom = Katom(t: kfunction, left: kn(), right: right, op: v)
# create a function nde with left children only
proc kfl*(v: Kverb, left: Katom): Katom = Katom(t: kfunction, left: left, right: kn(), op: v)

###################################
##### UTILITIES FUNCTION ##########
###################################
# check if Katom is of type knil
proc isNil*(x: Katom): bool = x.t == knil

# similar to toString() method in Java for pretty print to console
proc `$`*(x: Katom): string = 
  case x.t
  of knumber: return fmt"[t: {x.t}, v: {x.v0}]"
  of kchar: return fmt"[t: {x.t}, v: {x.v1}]"
  of ksymbol: return fmt"[t: {x.t}, v: {x.v2}]"
  of klist: return fmt"[t: {x.t}, v: {x.v3}]"
  of kdictionary: return fmt"[t: ${x.t}, v: {x.v4}]"
  of kfunction: return fmt"[t: {x.t}, v: {x.op}, left: {x.left}, right: {x.right}]"
  of knil: return fmt"[t: {x.t}, v: {x.v11}]"

# method to return length of all type Katom as knumber Katom (very powerfull APL style)
proc klen*(x: Katom): Katom =
  case x.t
  of knumber: return kn(1)
  of kchar: return kn(1)
  of ksymbol: return kn(1)
  of klist: return kn(x.v3.len)
  of kdictionary: return kn(x.v4.len)
  of kfunction: return kn(1)
  of knil: return kn(1)

# method to zip 2 array into tuples
proc kzip*(x: seq[Katom], y: seq[Katom]): seq[tuple[a: Katom, b: Katom]] =
  if x.len == y.len:
    result = zip(x, y)
  else:
    echo "length error."
    result = @[]

# equality check for testing
proc `==`*(x: Katom, y: Katom): bool = 
  if x.t != y.t:
    return false
  else:
    case x.t
    of knumber: return x.v0 == y.v0
    of kchar: return x.v1 == y.v1
    of ksymbol: return x.v2 == x.v2
    of klist:
      if klen(x) != klen(y):
        return false
      else:
        return kzip(x.v3, y.v3).map(proc(xy: tuple[a: Katom, b: Katom]): bool = xy.a == xy.b).count(true) == klen(x).v0.toInt
    of kdictionary: return false # TODO
    of kfunction: 
      if x.op == x.op: 
        return (x.left == y.left and x.right == y.right)
      else: 
        return false
    of knil: return x.v11 == y.v11

# check left and right nodes and return one state enum
proc cs(left: Katom, right: Katom): Kstate =
  if left.isNil and right.isNil:
    return lrnil
  elif left.isNil:
    return lnil
    # TODO
  else:
    return rnil

proc cl(left: Katom, right: Katom): bool = klen(left) == klen(right)

##################################
##### K verbs ################
##################################

# plus verb with only right node
proc vplusR(right: Katom): Katom =
  return right

# plus op with only right node
proc vplusL(left: Katom): Katom =
  return kfl(kplus, left)

proc vplus*(left: Katom, right: Katom): Katom =
  if left.isNil and right.isNil:
    result = kn("domain error.") 
  if left.isNil:
    result = vplusR(right)
  if right.isNil:
    result = vplusL(left)
  elif left.t == knumber and right.t == knumber:
    result = kn(left.v0 + right.v0)
  elif left.t == knumber and right.t == klist:
    result = kl(map(right.v3, proc(x: Katom): Katom = vplus(left, x)))
  elif left.t == klist and right.t == knumber:
    result = kl(map(left.v3, proc(x: Katom): Katom = vplus(x, right)))
  elif left.t == klist and right.t == klist:
    if klen(left).v0 == klen(right).v0:
      result = kl(zip(left.v3, right.v3).map(proc(xy: tuple[a: Katom, b: Katom]): Katom = vplus(xy.a, xy.b)))
    else:
      result = kn("length error.")
  else:
    result = kn("domain error.")
  return result

# proc vplus*(left: Katom, right: Katom): Katom =
#   case cs(left, right)
#   of lrnil: return kn("domain error.")
#   of rnil: return vplusL(left)
#   of lnil: return vplusR(right)
#   of lnrn: return kn(left.v0 + right.v0)
#   of lnrl: return kl(right.v3.map(proc(x: Katom): Katom = vplus(left, x)))
#   of llrn: return kl(left.v3.map(proc(x: Katom): Katom = vplus(x, right)))
#   of llrl:
#     if cl(left, right):
#       return kl(zip(left.v3, right.v3).map(proc(xy: tuple[a: Katom, b: Katom]): Katom = vplus(xy.a, xy.b)))
#     else:
#       return kn("length error.")
#   else: return kn("domain error.")

# method to apply functions to left, right nodes of ast
proc applyfunction(f: Katom, left: Katom, right: Katom): Katom =
  if f.op == kplus:
    return vplus(left, right)
  else:
    return kn()

# maineval method on top of ast
proc eval*(node: Katom): Katom =
  if node.t == kfunction:
    if not node.left.isNil and not node.right.isNil:
      return applyfunction(node, eval(node.left), eval(node.right))
    elif node.left.isNil:
      return node.right
    else:
      return node
  return node


# start the main module
if isMainModule:
  echo "K Language implementation in Nim [v0.0.1]"