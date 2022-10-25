# 組み合わせライブラリ

これ一つで階乗、階乗の逆元、ならし$O(1)$の逆元、組み合わせ($nCr$, $nPr$, $nHr$)のすべてが求められるライブラリです。
配列の確保更新は倍々に自動で行うので、不要です。

## 階乗
```nim
T.fact(n:int):T
```

$n!$の値を計算します。

**@{keyword.complexity}**

- ならし$O(1)$

## 階乗の逆元
```nim
T.rfact(n:int):T
T.invfact(n:int):T
```

$n!$の逆元の値を計算します。

**@{keyword.complexity}**

- ならし$O(1)$

## 逆元
```nim
T.inv(n:int):T
```

$n$の逆元の値を計算します。返り値は```T(1) / T(n)```あるいは```T(n).inv()```と同じですが、例えばTがmodintの場合前者はならし$O(1)$で計算できるのに対して、後者は毎回$O(log n)$かかります。$n$が小さくてたくさん呼ぶときなどは前者が便利です。

**@{keyword.complexity}**

- ならし$O(1)$

## 順列・組み合わせ
順列、組み合わせを$O(n)$のサイズの配列を作ることで実現します。
atcoderの時間・領域のリミットを考えると$n$は$10^7$以下程度が限界です。それより大きい場合は下記の大きい数の場合をご検討ください。
$C, H, R$の定義は高校の教科書などを参考にしてください。
### 順列
```nim
T.P(n, r:int):T
```

$nPr$の値を$T$型で計算します。

**@{keyword.complexity}**

- ならし$O(1)$


### 組み合わせ
```nim
T.C(n, r:int):T
```

$nCr$の値を$T$型で計算します。

**@{keyword.complexity}**

- ならし$O(1)$

### 重複組み合わせ
```nim
T.H(n, r:int):T
```

$nHr$の値を$T$型で計算します。

**@{keyword.complexity}**

- ならし$O(1)$

## 大きい数について
上記と同じですが、$n$が大きい数の場合に$O(r)$かけて計算することができます。
「大きい数」の目安は長さ$n$の配列が作れない、つまり$10^7$以上程度です。
### 順列
```nim
T.P_large(n, r:int):T
```

$nPr$の値を$T$型で計算します。

**@{keyword.complexity}**

- $O(r)$


## 組み合わせ
```nim
T.C_large(n, r:int):T
```

$nCr$の値を$T$型で計算します。

**@{keyword.complexity}**

- $O(r)$

## 重複組み合わせ
```nim
T.H_large(n, r:int):T
```

$nHr$の値を$T$型で計算します。

**@{keyword.complexity}**

- ならし$O(r)$

## データのリセット
```nim
T.resetCombination()
```

確保した配列を一度リセットします。dynamic modintなどでmodを変えた場合に一度リセットしてください。
リセットせず前のmodでの計算結果をベースに呼び出した場合の動作は未定義です。