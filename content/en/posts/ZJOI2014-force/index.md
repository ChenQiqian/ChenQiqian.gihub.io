---
title: 「ZJOI2014」力-快速傅立叶变换
urlname: ZJOI2014-force
date: 2018-07-19 18:00:39
tags:
- 快速傅立叶变换
- 数学
categories: 
- OI
- 题解
series:
- 各省省选
libraries:
- mathjax 
##-- toc setting --##
hideToc: false
enableToc: true
enableTocContent: false
---

给出 $n$ 个数 $q_i$ ，给出 $F_j$ 定义为：

$$
F_j = \sum _ {i < j}\frac{q_i q_j}{(i-j)^2} - \sum _ {i > j}\frac{q_i q_j}{(i-j)^2}
$$

令 $E_i = \frac{F_i}{q_i}$ ，求 $E_i$ 的值。

<!--more-->

## 链接

[Luogu P3338](https://www.luogu.org/problemnew/show/P3338)


## 题解

先化简：
$$
E_j = \sum _ {i < j}\frac{q_i}{(i-j)^2} - \sum _ {i > j}\frac{q_i}{(i-j)^2}
$$

注意到我们只需要求：
$$
E_j' = \sum _ {i = 1}^{j-1}\frac{q_i}{(i-j)^2} 
$$

注意到卷积的形式：

$$
(f * g)[i] = \sum _ {j = 0}^{i} f[j]\,g[i-j]
$$

在上式中，令 $f[i] = q_i,g[i] = i^{-2}$ ，由卷积的定义可以发现：

$$
E_i' = (f * g)[i]
$$

这个过程可以用快速傅立叶变换优化，达到 $O(n \log n)$ 的复杂度。

然后把序列反转，再做一遍，组合一下就是最后的答案。

## 代码


```cpp
#include <bits/stdc++.h>
using namespace std;
const int MAXN = 500000;
typedef complex<double> complex_t;

namespace FFT{
const double PI = acos(-1.0);
// n = 2^k
void fft(complex_t *P,int n,int op){
    static int r[MAXN];
    int len = log2(n);
    for(int i = 0;i<n;i++)
        r[i] = (r[i>>1]>>1)|((i&1)<<(len-1));
    for(int i = 0;i<n;i++)
        if(i < r[i]) swap(P[i],P[r[i]]);
    for(int i = 1;i<n;i<<=1){
        complex_t x(cos(PI/i),sin(PI/i)*op);
        for(int j = 0;j<n;j+=(i<<1)){
            complex_t y(1,0);
            for(int k = 0;k<i;k++,y*=x){
                complex_t p = P[j+k],q = y*P[i+j+k];
                P[j+k] = p+q,P[i+j+k] = p-q; 
            }
        }
    }
}
void mul(double *a,double *b,double *res,int n){
    static complex_t c[MAXN],d[MAXN];
    for(int i = 0;i<n;i++) c[i] = d[i] = 0;
    for(int i = 0;i<n;i++)
        c[i] = a[i],d[i] = b[i];
    fft(c,n,1),fft(d,n,1);
    for(int i = 0;i<n;i++)
        c[i] *= d[i];
    fft(c,n,-1);
    for(int i = 0;i<n;i++)
        res[i] = double(c[i].real())/double(n);
}
}

int n;
double q[MAXN];

void init(){
    scanf("%d",&n);
    for(int i = 1;i<=n;i++)
        scanf("%lf",&q[i]);
}

void solve(){
    static double ans[MAXN],tmp[MAXN],a[MAXN],b[MAXN];
    int m = 1;
    for(;m<=2*n;m<<=1);
    // 注意这里的b[i]一定只能到n！
    for(int i = 1;i<=n;i++) 
        a[i] = q[i],b[i] = (1.0/double(i))/double(i);// 这里可能会爆一点什么东西

    FFT::mul(a,b,tmp,m);
    for(int i = 1;i<=n;i++) ans[i] += tmp[i];
    reverse(a+1,a+n+1);
    
    FFT::mul(a,b,tmp,m);
    for(int i = 1;i<=n;i++) ans[i] -= tmp[n-i+1];
    for(int i = 1;i<=n;i++) printf("%lf\n", ans[i]);
}

int main(){
    init();
    solve();
    return 0;
}
```

