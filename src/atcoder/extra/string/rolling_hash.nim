when not declared ATCODER_ROLLING_HASH_HPP:
  const ATCODER_ROLLING_HASH_HPP* = 1
  import sequtils
  
  template MASK*(n:static[int]):auto = (1'u shl n.uint) - 1
  
  const base* = 1000000007'u
  
  type RH_Base*[Mod:static[uint], base:static[uint]] = object
    h:uint
  
  type RH* = RH_Base[(1'u shl 61) - 1, base]
  
  converter toRH*(t:SomeInteger or char):RH = RH(h:t.uint)
  
  proc multRaw*(a, b:RH):RH =
    let
      au = a.h shr 31
      ad = a.h and MASK(31)
      bu = b.h shr 31
      bd = b.h and MASK(31)
      mid = ad * bu + au * bd
      midu = mid shr 30
      midd = mid and MASK(30)
    RH(h:au * bu * 2 + midu + (midd shl 31) + ad * bd)
  
  proc calcMod*[T:RH](x:T):T =
    let
      xu = x.h shr 61
      xd = x.h and MASK(61)
    result = RH(xu + xd)
    if result.h >= T.Mod: result.h -= T.Mod
  
  proc `*=`*(a: var RH, b:RH) =  a = calcMod(multRaw(a, b))
  proc `*`*(a, b:RH):RH = result = a;result *= b
  proc `==`*(a, b:RH):bool = a.h == b.h
  proc `+=`*(a:var RH, b:RH) =
    a.h += b.h
    if a.h >= RH.Mod: a.h -= RH.Mod
  proc `+`*(a, b:RH):RH = result = a;result += b
  proc `-=`*(a:var RH, b:RH) =
    a.h += RH.Mod - b.h
    if a.h >= RH.Mod: a.h -= RH.Mod
  proc `-`*(a, b:RH):RH = result = a;result -= b
  proc `&=`*(a:var RH, c:SomeInteger or char) =
    a = multRaw(a, RH(base))
    a += RH(c)
    a = a.calcMod()
  proc `&`*(a:RH, c:SomeInteger or char):RH = result = a;result &= c
  
  import hashes
  proc hash*(a:RH):Hash = a.h.hash
  
  type RollingHash*[RH] = object
    hashed, power: seq[RH]
  
  proc initRollingHash*(s:string):auto =
    var
      sz = s.len
      hashed = newSeqWith(sz + 1, RH(0))
      power = newSeqWith(sz + 1, RH(0))
    power[0] = 1'u
    for i in 0..<sz:
      power[i + 1] = power[i] * RH(base)
      hashed[i + 1] = calcMod(multRaw(hashed[i], RH(base)) + RH(s[i]))
  #    if hashed[i + 1] >= MOD: hashed[i + 1] -= MOD
    return RollingHash[RH](hashed: hashed, power: power)
  
  proc `[]`*(self: RollingHash; s:Slice[int]):RH =
    result = RH(self.hashed[s.b+1].h + (RH.MOD shl 2) - multRaw(self.hashed[s.a], self.power[s.len]).h)
    result = result.calcMod()
  
  proc connect*(self: RollingHash; h1, h2:uint, h2len:int):RH =
    result = multRaw(RH(h1), self.power[h2len]) + RH(h2)
    result = result.calcMod
  
  proc LCP*(self, b:RollingHash; p1, p2:Slice[int]):int =
    var
      len = min(p1.len, p2.len)
      low = -1
      high = len + 1
    while high - low > 1:
      let mid = (low + high) div 2
      if self[p1.a..<p1.a + mid] == b[p2.a..<p2.a + mid]: low = mid
      else: high = mid
    return low
