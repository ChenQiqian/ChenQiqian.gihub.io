---
title: 「SDOI2008」仪仗队-欧拉函数
urlname: SDOI2008-guard
date: 2018-09-09 20:29:47
tags:
- 数学
- 数论
- 欧拉函数
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

作为体育委员， $C$ 君负责这次运动会仪仗队的训练。仪仗队是由学生组成的 $N \times N$ 的方阵，为了保证队伍在行进中整齐划一， $C$ 君会跟在仪仗队的左后方，根据其视线所及的学生人数来判断队伍是否整齐(如下图)。 

![](1.jpg)

现在， $C$ 君希望你告诉他队伍整齐时能看到的学生人数。

<!--more-->

## 链接

[Luogu P2158](https://www.luogu.org/problemnew/show/P2158)

## 题解

学了一年 $\text{OI}$ 才会做这道题，退役退役QAQ

我们观察右下三角形的情况，答案只要再做一些简单的加减乘除就可以了。

$(x,y)$ 从 $(0,0)$ 能被看见的条件，就是在这两个点之间没有其他整点。可以发现，如果有不少于一个整点，那么必然这个区间会被整点若干等分（这若干个整点之间斜率相同），所以也就是满足 $\gcd(x,y) > 1$ ，所以我们只需要求：
$$
\sum _ {i = 1}^{n-1} \sum _ {j=1}^{n-1} [\gcd(i,j) = 1]
$$
两个循环相同，直接用欧拉函数求解就好。

时间复杂度：$O(n)$ 。

## 代码



```cpp
#include <cstdio>
using namespace std;

const int MAXN = 100000;

bool flag[MAXN];
int prime[MAXN],cnt;
int phi[MAXN];

void sieve(int n){
    phi[1] = 1;flag[1] = 1;
    for(int i = 2;i<=n;i++){
        if(flag[i] == 0){
            prime[++cnt] = i,phi[i] = i-1;
        }
        for(int j = 1;j<=cnt && i * prime[j] <= n;j++){
            flag[i*prime[j]] = 1;
            if(i % prime[j]){
                phi[i * prime[j]] = phi[i] * (prime[j]-1);
            }
            else{
                phi[i * prime[j]] = phi[i] * prime[j];
                break; 
            }
        }
    }
}

int main(){
    int n;
    scanf("%d",&n);
    sieve(n);
    long long ans = 0;
    for(int i = 2;i<=n-1;i++){
        ans += phi[i];
    }
    printf("%lld\n",n==1?0:ans*2+3);
    return 0;
} 
```




