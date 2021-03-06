---
title: 「APIO2014」序列分割-动态规划-斜率优化
urlname: APIO2014-sequence
date: 2018-08-24 13:16:24
tags:
- 动态规划
- 斜率优化
categories:
- OI
- 题解
series:
- WC/CTSC/APIO
libraries:
- mathjax 
##-- toc setting --##
hideToc: false
enableToc: true
enableTocContent: false
---

你正在玩一个关于长度为 $n$ 的非负整数序列的游戏。这个游戏中你需要把序列分成 $k + 1$ 个非空的块。为了得到 $k + 1$ 块，你需要重复下面的操作 $k$ 次：

+ 选择一个有超过一个元素的块（初始时你只有一块，即整个序列）
  + 选择两个相邻元素把这个块从中间分开，得到两个非空的块。

每次操作后你将获得那两个新产生的块的元素和的乘积的分数。你想要最大化最后的总得分。

<!--more-->

## 链接

[Luogu P3648](https://www.luogu.org/problemnew/show/P3648)
$$
a(b+c) + bc = ab+ac+bc = (a+b)c + ab \rightarrow \text{三个数怎么切结果都一样}\\
a(b+c+d) + (bc+cd+ad) = ab + ac + ad + bc + bd + cd = (a+b+c)d + (ab+bc+ac)
$$
这个式子再推广的话，就告诉我们：切割方案的分数只与切割的位置有关。

令 $dp[i][w]$ 为前 $i$ 个数字切割w次能拿到的最小值 所以我们可以写出状态转移方程：
$$
dp[i][w] = \max _ {j=1}^{i-1}(dp[j][w-1] + sum[j] \times (sum[i]-sum[j]))
$$
然后如果 $k$ 比 $j$ 优秀，则有：
$$
dp[j][w-1] + sum[j] \times (sum[i]-sum[j]) < dp[k][w-1] + sum[k] \times (sum[i]-sum[k])\\
\frac{(dp[j][w-1]-{sum[j]}^2)-(dp[k][w-1]-{sum[k]}^2)}{sum[j]-sum[k]} > -sum[i]\\
$$
现在我们需要考虑 $sum[j] = sum[k]$ 的情况，我们注意到这个时候应该是 $ k$ 一定是不比 $j$ 坏的，但是我们由于要输出方案中，不能切在开头的位置，所以我们要尽量往后切，就必须令 $k$ 比 $j$ 优，就应该让这个式子返回无穷大。

因为 $sum$ 是单调的，就可以单调队列维护凸包了。

输出路径的话，就直接维护一个决策点，沿着决策点往回跳，然后输出就可以了。

## 代码

```cpp
#include <cstdio>
#include <algorithm>
#include <cstdlib>
#define ld long double
#define ll long long
using namespace std;

const int MAXN = 110000;

int n,k;
ll num[MAXN],sum[MAXN],a[MAXN],b[MAXN];
int last[MAXN][210];
ll *dp,*now;

ld calc(int i,int j){
  if(sum[i] == sum[j]) return 1e18;
  return (ld)(dp[i]-sum[i]*sum[i]-dp[j]+sum[j]*sum[j])/(ld)(sum[i]-sum[j]);
}

void init(){
  scanf("%d %d",&n,&k);
  for(int i = 1;i<=n;i++){
    scanf("%lld",&sum[i]);
    sum[i] += sum[i-1];
  }
}

void solve(){
  static int q[MAXN];
  dp = a,now = b;
  int fi = 0,la = 0;
  for(int x = 1;x<=k;x++){
    fi = la = 0;q[0] = 0;
    for(int i = 1;i<=n;i++){
      while(fi < la && calc(q[fi],q[fi+1]) >= -sum[i]) fi++;
      now[i] = dp[q[fi]] + (sum[i]-sum[q[fi]])*sum[q[fi]];
      last[i][x] = q[fi];
      while(fi < la && calc(q[la-1],q[la]) <= calc(q[la],i)) la--;
      q[++la] = i;
    }
    swap(dp,now);
  }
  printf("%lld\n",dp[n]);
  for(int i = k,t = n;i>=1;--i){
    printf("%d ",last[t][i]);
    t = last[t][i];
  }
  printf("\n");
}

int main(){
  init();
  solve();
  return 0;
}
```
