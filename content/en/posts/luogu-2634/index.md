---
title: 「国家集训队」聪聪可可-点分治
date: 2018-04-22 13:14:39
##-- post setting --##
categories:
- OI
- 题解
tags:
- 点分治
- 数据结构
- 树形结构
series:
- 国家集训队
libraries:
- mathjax 
##-- toc setting --##
hideToc: false
enableToc: true
enableTocContent: false
---


有一颗 $n$（$n<20000$）个节点的树，每条边都有边权。接下来由聪聪和可可分别随即选一个点，如果两点之间简单路径上的边权和是 $3$ 的倍数，则判聪聪赢，否则可可赢。

聪聪非常爱思考问题，希望知道对于这张图自己的获胜概率是多少。

<!--more-->

## 链接

[Luogu P2634](https://www.luogu.org/problemnew/show/P2634)

## 题解

点分治比较模版的一道题吧。

树上的路径问题，也可以提示我们点分治。

所以问题转化为：怎么在 $O(n)$ 或者 $O(n \log{n})$ 的时间内求出过一个点的所有，起点终点不在同一子树中，边权和为$3$的倍数的路径个数。

事实上，我们发现，这个问题不难解决。如果只有经过一个点这个条件，那么就很简单： dfs 一遍求出这个点到所有点的距离除 $3$ 余数，然后 $num[0] \times num[0] + num[1] \times num[2] + num[2] \times num[1]$ 即为所求。

比较难搞的是第二个条件，也就是我们要求这个路径的起点和终点不在一个子树内。我们可以考虑采用容斥原理。即对每一颗子树分别 dfs 求出 $3$ 个 $num'$ ，然后减去这个子树内过上面根节点的路径个数。这个个数我们上面好像已经求过了，事实上就是 $num'[0] \times num'[0] + num'[1] \times num'[2] + num'[2] \times num'[1]$ 。

所以我们就可以 $O(n)$ 的时间处理完这件事情了。再加上点分治，我们最终的复杂度就是 $O(n \log {n})$ 。

有一些比较容易错的地方，比如要注意开始的时候 $num[0]$ 要置做 $1$ ，而 $num'[0]$就不用。这是比较显然的，然而我还是错了好久...还有就是在加边的时候可以对 $3$ 取模...后面也要不断对 $3$ 取模...要不然会炸。

## 代码

```cpp
#include <cstdio>
#include <algorithm>
#define ll long long
using namespace std;

ll gcd(ll a,ll b){// a < b;
    return a == 0?b:gcd(b%a,a);
}

const int MAXN = 110000;

struct Edge{
    int from,to;
    int len,nex;
}edge[MAXN];int ecnt = 2;
int fir[MAXN];
void addedge(int a,int b,int l){
    edge[ecnt] = (Edge){a,b,l,fir[a]};
    fir[a] = ecnt++;
    edge[ecnt] = (Edge){b,a,l,fir[b]};
    fir[b] = ecnt++;
}
//----

int n,m;
int f[MAXN],siz[MAXN],vis[MAXN];
int rt,sz;
int num[3],tmp[3];
ll ans = 0;

void getroot(int nown,int fa){
    siz[nown] = 1,f[nown] = 0;
    for(int nowe = fir[nown];nowe;nowe = edge[nowe].nex){
        int v = edge[nowe].to;
        if(vis[v] || v == fa) continue;
        getroot(v,nown);
        siz[nown] += siz[v];
        f[nown] = max(f[nown],siz[v]); 
    }
    f[nown] = max(f[nown],sz - siz[nown]);
    if(f[nown] < f[rt]) rt = nown;
}

void getdeep(int nown,int fa,int d){
    num[d]++;
    for(int nowe = fir[nown];nowe;nowe = edge[nowe].nex){
        int v = edge[nowe].to,l = edge[nowe].len;
        if(vis[v] || v == fa) continue;
        getdeep(v,nown,(d+l)%3);
    }
}

void work(int nown){
    tmp[0] = 1;tmp[1] = tmp[2] = 0;
    for(int nowe = fir[nown];nowe;nowe = edge[nowe].nex){
        int v = edge[nowe].to,l = edge[nowe].len;
        if(vis[v]) continue;
        num[0] = num[1] = num[2] = 0;
        getdeep(v,nown,l);
        ans -= num[0]*num[0] + 2*num[1]*num[2];
        tmp[0] += num[0],tmp[1]+=num[1],tmp[2]+=num[2];
    }
    ans += tmp[0] * tmp[0] + 2*tmp[1] * tmp[2];
}

void solve(int nown){
    vis[nown] = 1;
    work(nown);
    for(int nowe = fir[nown];nowe;nowe = edge[nowe].nex){
        int v = edge[nowe].to;
        if(vis[v]) continue;
        f[rt = 0] = sz = siz[v];
        getroot(v,rt);
        solve(rt);
    }
}

void init(){
    scanf("%d",&n);
    int a,b,c;
    for(int i = 1;i<=n-1;i++){
        scanf("%d %d %d",&a,&b,&c);
        addedge(a,b,c%3);
    }
}

void solve(){
    f[rt = 0] = sz = n;
    getroot(1,rt);
    solve(rt);
    ll ans2 = n*n;
    printf("%lld/%lld\n",ans/gcd(ans,ans2),ans2/gcd(ans,ans2));
}

int main(){
    init();
    solve();
    return 0;
}
```



