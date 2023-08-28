# ハンガリアン法

割当問題をハンガリアンで解きます

```nim
var (ans, p) = hungarian[T](a:seq[seq[T]]):(T, seq[int])
```

$N$人の人と$N$個の仕事があり、それぞれ$0,1,\ldots,N-1$の番号が与えられていて、各人に1つの仕事を与えることを考えます。
`a[i][j]`に人$i$が仕事$j$を行ったときのパフォーマンスを入力しパフォーマンスの合計を最大化します。
上記のように呼び出すことで`ans`にパフォーマンスの最大値、`p[i]`に人$i$に与えるべき仕事の番号を表します。

**@{keyword.constraints}**

- $0 \leq N \leq 10^8$

**@{keyword.complexity}**

- $O(N^3)$