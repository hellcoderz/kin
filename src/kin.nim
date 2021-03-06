import tables, sequtils, strformat

type
    Ktype* = enum # K built-in and only supported datatypes
        # knumber,
        # kchar,
        katom,
        # ksymbol,
        klist,
        # kdictionary,
        kfunction,
        knil,
        
        # kview=6,
        # knameref=7,
        # kverb=8,
        # kadverb=9,
        # kreturn=10,
        # knil=11,
        # kcond=12,
        # kquote=13

    KatomType* = enum
        kcharatom=0,
        kintatom=1,
        kfloatatom=2
    
    Kadverb* = enum # K build-in verbs
        kfslash=0
        # TODO: add more

    Kobj* = ref object of RootObj
        t: Ktype
    Katom* = ref object of Kobj
        at: KatomType
    Kfloat* = ref object of Katom
        v: float
    Kint* = ref object of Katom
        v: int
    Kchar* = ref object of Katom
        v: int
    Ksymbol* = ref object of Kobj
        v: string
    Klist* = ref object of Kobj
        v: seq[Kobj]
    Kfunction* = ref object of Kobj
        v: string
        a: Kadverb
        left: Kobj
        right: Kobj
    Knil* = ref object of Kobj
        v: string

proc kl*(x: seq[Kobj]): Kobj = Klist(t: klist, v: x)                # create list obj "1 2 3"
proc ki*(x: int): Kobj = Kint(t: katom, at:kintatom, v: x)          # create int obj "1"
proc kf*(x: float): Kobj = Kfloat(t: katom, at: kfloatatom, v: x)   # create float obj "1.5"
proc kc*(x: char): Kobj = Kchar(t: katom, at: kcharatom, v: int(x)) # create char obj "'c'"
proc kn*(): Kobj = Knil(t:knil, v: "NIL.")                          # create nil obj
proc kn*(x: string): Kobj = Knil(t: knil, v: x)                     # create nil obj with message

proc f*(x: int): float = x.toFloat                                  # convert int object to float

proc kstr*(s: string): Kobj = Klist(t: klist, v: s.map(proc(c: char): Kobj = kc(c)))
proc ks*(s: string): Kobj = Ksymbol(v: s)

proc kfn*(v: string, left: Kobj, right: Kobj): Kobj = Kfunction(t: kfunction, v: v, left: left, right: right)

proc klen*(x: Klist): int = x.v.len
proc klen*(x: Kobj): int = 
    case x.t
    of klist: return Klist(x).klen
    else: return 1

# method to zip 2 array into tuples
proc kzip*(x: seq[Kobj], y: seq[Kobj]): seq[tuple[a: Kobj, b: Kobj]] = return zip(x, y)

# printing utilities
proc `$`*(x: Kfloat): string = x.v.`$` & " "
proc `$`*(x: Kint): string = x.v.`$` & " "
proc `$`*(x: Kchar): string = char(x.v).`$`
proc `$`*(x: Kfunction): string = x.v.`$`

proc `$`*(x: Katom): string =
    case x.at
    of kcharatom: return Kchar(x).`$`
    of kintatom: return Kint(x).`$`
    of kfloatatom: return Kfloat(x).`$`

proc `$`*(x: Kobj): string =
    # echo x.t
    case x.t
    of katom: return Katom(x).`$`
    of klist: return Klist(x).v.map(proc(k: Kobj): string = k.`$`).foldl(a & b)
    of knil: return Knil(x).v
    of kfunction: return Kfunction(x).`$`
    return "PRINT ERROR."


##### FUNCTION TABLES ########
var fn_kchar_kchar* = initTable[string, proc(x: Kchar, y: Kchar): Kobj]()
var fn_kint_kint* = initTable[string, proc(x: Kint, y: Kint): Kobj]()
var fn_kfloat_kfloat* = initTable[string, proc(x: Kfloat, y: Kfloat): Kobj]()

var fn_kchar_kint* = initTable[string, proc(x: Kchar, y: Kint): Kobj]()
var fn_kint_kchar* = initTable[string, proc(x: Kint, y: Kchar): Kobj]()

var fn_kchar_kfloat* = initTable[string, proc(x: Kchar, y: Kfloat): Kobj]()
var fn_kfloat_kchar* = initTable[string, proc(x: Kfloat, y: Kchar): Kobj]()

var fn_kint_kfloat* = initTable[string, proc(x: Kint, y: Kfloat): Kobj]()
var fn_kfloat_kint* = initTable[string, proc(x: Kfloat, y: Kint): Kobj]()

###### VERBS #########
# plus: +
proc plus*(x: Kchar, y: Kchar): Kobj = ki(x.v + y.v)
proc plus*(x: Kint, y: Kint): Kobj = ki(x.v + y.v)
proc plus*(x: Kfloat, y: Kfloat): Kobj = kf(x.v + y.v)

proc plus*(x: Kchar, y: Kint): Kobj = ki(x.v + y.v)
proc plus*(x: Kint, y: Kchar): Kobj = ki(x.v + y.v)

proc plus*(x: Kchar, y: Kfloat): Kobj = kf(f(x.v) + y.v)
proc plus*(x: Kfloat, y: Kchar): Kobj = kf(x.v + f(y.v))

proc plus*(x: Kint, y: Kfloat): Kobj = kf(f(x.v) + y.v)
proc plus*(x: Kfloat, y: Kint): Kobj = kf(x.v + f(y.v))

fn_kchar_kchar["+"] = plus
fn_kint_kint["+"] = plus
fn_kfloat_kfloat["+"] = plus

fn_kchar_kint["+"] = plus
fn_kint_kchar["+"] = plus

fn_kchar_kfloat["+"] = plus
fn_kfloat_kchar["+"] = plus

fn_kint_kfloat["+"] = plus
fn_kfloat_kint["+"] = plus

# plus: -
proc minus*(x: Kchar, y: Kchar): Kobj = ki(x.v - y.v)
proc minus*(x: Kint, y: Kint): Kobj = ki(x.v - y.v)
proc minus*(x: Kfloat, y: Kfloat): Kobj = kf(x.v - y.v)

proc minus*(x: Kchar, y: Kint): Kobj = ki(x.v - y.v)
proc minus*(x: Kint, y: Kchar): Kobj = ki(x.v - y.v)

proc minus*(x: Kchar, y: Kfloat): Kobj = kf(f(x.v) - y.v)
proc minus*(x: Kfloat, y: Kchar): Kobj = kf(x.v - f(y.v))

proc minus*(x: Kint, y: Kfloat): Kobj = kf(f(x.v) - y.v)
proc minus*(x: Kfloat, y: Kint): Kobj = kf(x.v - f(y.v))

fn_kchar_kchar["-"] = minus
fn_kint_kint["-"] = minus
fn_kfloat_kfloat["-"] = minus

fn_kchar_kint["-"] = minus
fn_kint_kchar["-"] = minus

fn_kchar_kfloat["-"] = minus
fn_kfloat_kchar["-"] = minus

fn_kint_kfloat["-"] = minus
fn_kfloat_kint["-"] = minus

#### APLLY VERB FUNCTION ######
proc applyverb*(verb: string, x: Kobj, y: Kobj): Kobj
proc applyverb*(verb: string, x: Katom, y: Katom): Kobj = 
    # echo x.at
    case x.at
    of kcharatom:
        # echo y.at
        case y.at
        of kcharatom: return fn_kchar_kchar[verb](Kchar(x), Kchar(y))
        of kintatom: return fn_kchar_kint[verb](Kchar(x), Kint(y))
        of kfloatatom: return fn_kchar_kfloat[verb](Kchar(x), Kfloat(y))
    of kintatom:
        # echo y.at
        case y.at
        of kcharatom: return fn_kint_kchar[verb](Kint(x), Kchar(y))
        of kintatom: return fn_kint_kint[verb](Kint(x), Kint(y))
        of kfloatatom: return fn_kint_kfloat[verb](Kint(x), Kfloat(y))
    of kfloatatom:
        # echo y.at
        case y.at
        of kcharatom: return fn_kfloat_kchar[verb](Kfloat(x), Kchar(y))
        of kintatom: return fn_kfloat_kint[verb](Kfloat(x), Kint(y))
        of kfloatatom: return fn_kfloat_kfloat[verb](Kfloat(x), Kfloat(y))

proc applyverb*(verb: string, x: Klist, y: Klist): Kobj = 
        case x.klen == y.klen
        of true: return kl(kzip(x.v, y.v).map(proc(xy: tuple[a: Kobj, b: Kobj]): KObj = applyverb(verb, xy.a, xy.b)))
        of false: return kn("LENGTH ERROR.")

proc applyverb*(verb: string, x: Kobj, y: Kobj): Kobj =
    case x.t
    of katom:
        case y.t
        of katom: return applyverb(verb, Katom(x), Katom(y))
        of klist: return kl(Klist(y).v.map(proc(k: Kobj): Kobj = applyverb(verb, x, k)))
        of knil: return x
        else: return kn("DOMAIN ERROR.")
    of klist:
        case y.t
        of katom: return kl(Klist(x).v.map(proc(k: Kobj): Kobj = applyverb(verb, k, y)))
        of klist: return applyverb(verb, Klist(x), Klist(y))
        of knil: return x
        else: return kn("DOMAIN ERROR.")
    of knil:
        case y.t
        of katom: return y
        of klist: return y
        of knil: return y
        else: return kn("DOMAIN ERROR.")
    else: return kn("DOMAIN ERROR.")

proc eval*(ast: Kobj): Kobj =
    case ast.t
    of kfunction: 
        var node = Kfunction(ast)
        return applyverb(node.v, eval(node.left), eval(node.right))
    else: return ast