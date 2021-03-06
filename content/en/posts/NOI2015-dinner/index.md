---
title: 「NOI2015」寿司晚宴-状压dp
urlname: NOI2015-dinner
date: 2018-08-28 22:58:15
tags:
- 动态规划
- 状压dp
categories: 
- OI
- 题解
series:
- NOI
libraries:
- mathjax 
##-- toc setting --##
hideToc: false
enableToc: true
enableTocContent: false
---


为了庆祝 $NOI$ 的成功开幕，主办方为大家准备了一场寿司晚宴。小 $G$ 和小 $W$ 作为参加 $NOI$ 的选手，也被邀请参加了寿司晚宴。

在晚宴上，主办方为大家提供了 $n−1$ 种不同的寿司，编号 $1,2,3,⋯,n-1$ ，其中第种寿司的美味度为 $i+1$（即寿司的美味度为从 $2$ 到 $n$ ）。

现在小 $G$ 和小 $W$ 希望每人选一些寿司种类来品尝，他们规定一种品尝方案为不和谐的当且仅当：小 $G$ 品尝的寿司种类中存在一种美味度为 $x$ 的寿司，小 $W$ 品尝的寿司中存在一种美味度为 $y$ 的寿司，而 $x$ 与 $y$ 不互质。

现在小 $G$ 和小 $W$ 希望统计一共有多少种和谐的品尝寿司的方案（对给定的正整数 $p$ 取模）。注意一个人可以不吃任何寿司。

<!--more-->

## 链接

[Luogu P2150](https://www.luogu.org/problemnew/show/P2150)

## 题解

难死了qaq

对于没有什么特殊背景的计数题，很大可能上都是 $dp$ ，所以我们来如何 $dp$ 。

这里面最难满足的条件是：

> 小 $G$ 品尝的寿司种类中存在一种美味度为 $x$ 的寿司，小 $W$ 品尝的寿司中存在一种美味度为 $y$ 的寿司，而 $x$ 与 $y$ 不互质。

两个数不互质的情况即为：两个数分解质因数之后有相同的质因子，而且与该质因子出现 $1$ 次还是 $2$ 次无关。

然后我们有注意到所有的 $n$ 均小于 $500$ ，这意味着最多只会有一个质因子大于 $\sqrt {500} \approx 22.36 < 23$ ，小于 $23$ 的质数一共有 $8$ 个： $2,3,5,7,11,13,17,19$ ，所以我们可以压位存储这些质因数有没有出现，对于可能出现的最后一个大质因数，我们再用一个 `int` 存储（没有则为 $1$ ），这样的话我们就用一个简单比较的方式存储了这个数所有对选取造成影响的内容。

------

然后我们思考如何表示状态。

显然，我们不可能将大质数表示进状态里面，否则的话是非常难以转移而且空间大约是开不下的。

所以我们思考一下如何避免大质数的影响。

如果某些数字都具有一个大质因子，那么这些数字必然是不能同时选的，那么只有两种可能性：

- 只有小 $\text{G}$ 选了具有这个大质因子的数中的某些数
- 只有小 $\text{W}$ 选了具有这个大质因子的数中的某些数
- 两个人都没选这两个组中的任何一个数

那么我们考虑这样分类。

那么我们分别对每一个大质因数进行讨论（没有大质因数的时候，就是每一个数就相当于大质因数的改变，因为一个数不能被两个人同时选）：

设 $g[k][0/1][S_i][S_j]$ 为当前已经考虑完该组的前 $k-1$ 个数，由小 $\text{G}$ 或者小 $\text{W}$ 取具有这个大质数的数，目前的小 $\text{G}$ 的小质数集合是 $S_i$ ，小 $\text{W}$ 的小质数集合是 $S_j$ ，第 $k$ 个数的小质数集合为 $N_k$，那么我们有如下的转移：
$$
g ([k+1])[0][S_i \cap N_k][S_j]  = g([k])[0][S_i \cap N_k][S_j] + g([k])[0][S_i][S_j]\\
g ([k+1])[1][S_i][S_j \cap N_k]  = g([k])[1][S_i][S_j \cap N_k] + g([k])[1][S_i][S_j]
$$
也就是对于两种情况都有两种决策：取或者不取这个数。

这里需要用滚动数组，所以第一维都打上了括号，这里需要逆序转移。

------

为了从分组计算转换到最后的答案，我们需要再设计一组状态，就是表达在这若干组之间的一个关系。

比如我们设 $f[k][S_i][S_j]$ 表示考虑完前 $k-1$ 组，由小 $\text{G}$ 或者小 $\text{W}$ 取具有这个大质数的数，目前的小 $\text{G}$ 的小质数集合是 $S_i$ ，小 $\text{W}$ 的小质数集合是 $S_j$ ，第 $k$ 组的数的数目是 $num _ {k}$ 那么我们有如下的转移：
$$
f([k])[S_i][S_j] = g([num_k])[0][S_i][S_j] + g([num_k])[1][S_i][S_j] - f([k-1])[S_i][S_j]
$$
而且这个时候**$g([0])[0/1][S_i][S-j] = f([k-1])[S_i][S_j]$**  ，这个意思就是：让小 $\text{G}$  选这一组，或者让小 $\text{W}$ 选这一组。但是它们都有可能很谦虚一个都不选，那么我们最后要剪掉一个两个都不选的数目。

$f$ 数组也可以用滚动数组优化。

最后空间复杂度是 $O(n \times 2^{16})$ ，空间复杂度 $O(2\times 2^{16})$ 。

## 代码

 

```
#include <cstdio>
#include <cstring>
#include <algorithm>
using namespace std;
#define pii pair<int,int>
#define ll long long

const int MAXN = 256;

int prime[8] = {2,3,5,7,11,13,17,19};

ll n,p;
ll f[MAXN][MAXN],g[2][MAXN][MAXN];
pii s[MAXN*2];


void init(){
    scanf("%lld %lld",&n,&p);
    for(int i = 2;i<=n;i++){
        int t = i;
        for(int j = 0;j<8;j++){
        while(t % prime[j] == 0){
                s[i].second |= (1<<j);
                t/=prime[j];
            }
        }
        s[i].first = t;
    }
    sort(s+2,s+n+1);
//	for(int i = 2;i<=n;i++){
//		printf("%d:%d %d\n",i,s[i].first,s[i].second);
//	}
}

void calc(){
    f[0][0] = 1;
    for(int i = 2;i<=n;i++){
        if(i==2||s[i].first==1||s[i].first != s[i-1].first){
            memcpy(g[0],f,sizeof(f)),memcpy(g[1],f,sizeof(f));
        }
        for(int j = MAXN-1;~j;--j){
            for(int k = MAXN-1;~k;--k){
                if((k & s[i].second) == 0)
                    (g[0][j|s[i].second][k] += g[0][j][k])%=p;
                if((j & s[i].second) == 0)
                    (g[1][j][k|s[i].second] += g[1][j][k])%=p;
            }
        }
        if(i==n || s[i].first==1||s[i].first != s[i+1].first){
            for(int j = 0;j<MAXN;j++){
                for(int k = 0;k<MAXN;k++){
                    if((j&k)==0)
                        f[j][k] = (g[0][j][k] + g[1][j][k] - f[j][k])%p;
                }
            }
        }
    }
}

void output(){
    ll ans = 0;
    for(int i = 0;i<MAXN;i++){
        for(int j = 0;j<MAXN;j++){
            if((i&j)==0) (ans += f[i][j])%=p;
        }
    }
    printf("%lld\n",(ans%p+p)%p);
}

int main(){
    init();
    calc();
    output();
    return 0;
}
```






