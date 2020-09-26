when not declared ATCODER_SEGTREE_HPP:
  const ATCODER_SEGTREE_HPP* = 1
  import atcoder/internal_bit
  import std/sugar, std/sequtils

  type segtree*[S; p:static[tuple]] = object
    n, size, log:int
    d: seq[S]

  proc update[ST:segtree](self: var ST, k:int) {.inline.} =
    let op = ST.p.op
    self.d[k] = op(self.d[2 * k], self.d[2 * k + 1])

  proc init*[ST:segtree](self: var ST, v:seq[ST.S]) =
    let
      n = v.len
      log = ceil_pow2(n)
      size = 1 shl log
    self.n = n
    self.size = size
    self.log = log
    let e = ST.p.e
    self.d = newSeqWith(2 * size, e())
    for i in 0..<n: self.d[size + i] = v[i]
    for i in countdown(size - 1, 1): self.update(i)
  proc init*[ST:segtree](self: var ST, n:int) =
    let e = ST.p.e
    self.init(newSeqWith(n, e()))
  proc init*[ST:segtree](self: typedesc[ST], v:seq[ST.S]):auto =
    result = ST()
    result.init(v)
  proc init*[ST:segtree](self: typedesc[ST], n:int):auto =
    let e = ST.p.e
    self.init(newSeqWith(n, e()))
  proc initSegTree*[S](v:seq[S], op:static[(S,S)->S], e:static[()->S]):auto =
    result = segtree[S, (op:op, e:e)]()
    result.init(v)
  proc initSegTree*[S](n:int, op:static[(S,S)->S], e:static[()->S]):auto =
    result = segtree[S, (op:op, e:e)]()
    result.init(newSeqWith(n, e()))

  proc set*[ST:segtree](self:var ST, p:int, x:ST.S) {.inline.} =
    assert p in 0..<self.n
    var p = p + self.size
    self.d[p] = x
    for i in 1..self.log: self.update(p shr i)

  proc get*[ST:segtree](self:ST, p:int):ST.S {.inline.} =
    assert p in 0..<self.n
    return self.d[p + self.size]

  proc prod*[ST:segtree](self:ST, p:Slice[int]):ST.S {.inline.} =
    var (l, r) = (p.a, p.b + 1)
    assert 0 <= l and l <= r and r <= self.n
    let e = ST.p.e
    var sml, smr = e()
    l += self.size; r += self.size
    while l < r:
      let op = ST.p.op
      if (l and 1) != 0: sml = op(sml, self.d[l]);l.inc
      if (r and 1) != 0: r.dec;smr = op(self.d[r], smr)
      l = l shr 1
      r = r shr 1
    let op = ST.p.op
    return op(sml, smr)

  proc all_prod*[ST:segtree](self:ST):ST.S = self.d[1]

#  proc max_right*[ST:segtree, f:static[proc(s:ST.S):bool]](self:ST, l:int):auto = self.max_right(l, f)
  proc max_right*[ST:segtree](self:ST, l:int, f:proc(s:ST.S):bool):int =
    assert l in 0..self.n
    let e = ST.p.e
    let f = f
    assert f(e())
    if l == self.n: return self.n
    var
      l = l + self.size
      sm = e()
    while true:
      while l mod 2 == 0: l = l shr 1
      let op = ST.p.op
      let f = f
      if not f(op(sm, self.d[l])):
        while l < self.size:
          l = (2 * l)
          let op = ST.p.op
          let f = f
          if f(op(sm, self.d[l])):
            let op = ST.p.op
            sm = op(sm, self.d[l])
            l.inc
        return l - self.size
      sm = op(sm, self.d[l])
      l.inc
      if not ((l and -l) != l): break
    return self.n

#  proc min_left*[ST:segtree, f:static[proc(s:ST.S):bool]](self:ST, r:int):auto = self.min_left(r, f)
  proc min_left*[ST:segtree](self:ST, r:int, f:proc(s:ST.S):bool):int =
    assert r in 0..self.n
    let e = ST.p.e
    let f = f
    assert f(e())
    if r == 0: return 0
    var
      r = r + self.size
      sm = e()
    while true:
      r.dec
      while r > 1 and (r mod 2 != 0): r = r shr 1
      let op = ST.p.op
      let f = f
      if not f(op(self.d[r], sm)):
        while r < self.size:
          r = (2 * r + 1)
          let op = ST.p.op
          let f = f
          if f(op(self.d[r], sm)):
            let op = ST.p.op
            sm = op(self.d[r], sm)
            r.dec
        return r + 1 - self.size
      sm = op(self.d[r], sm)
      if not ((r and -r) != r): break
    return 0
