---
title: 「APIO2008」免费道路-生成树+并查集
urlname: APIO2008-road
date: 2018-08-18 20:44:05
tags:
- 图论
- 生成树
- 数据结构
- 并查集
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

给定一个 $n$ 个点，$m$ 条边的无向图，每条边有两种权值： $0$ 或者 $1$ 。

先询问能不能找出一个生成树，使得其中恰有 $k$ 条 $0$ 边，若存在，输出任意一个方案，否则输出 `no solution` 。


<!--more-->

## 链接

[Luogu P3623](https://www.luogu.org/problemnew/show/P3623)

## 题解

不太会其实。首先将 $0$ 边作为大边，然后做一次最小生成树，得到必须加入的最少的 $0$ 边，此时如果这个 $0$ 边的数目大于 $k$ ，那么就无解；

然后我们先将所有的 $0$ 边尝试加入，如果能满足不成环且最后恰好能到 $k$ 条边，就加入剩下的 $1$ 边，构成生成树即可。

## 代码


```cpp
#include <cstdio>
#include <algorithm>
#include <cstring>
using namespace std;

const int MAXN = 110000;

int n,m,k;
struct Edge{
    int from,to,len;
}edge[MAXN];

bool cmp(Edge a,Edge b){
    return a.len < b.len;
}

int f[MAXN];
void init(int n){
    for(int i = 1;i<=n;i++) f[i] = i;
}
int find(int x){
    return f[x] == x?x:f[x] = find(f[x]);
}

void solve(){
    static Edge ans[MAXN];
    int tot = 0;
    init(n);
    
    sort(edge+1,edge+m+1,cmp);
    for(int i = 1;i<=m;i++){
        Edge &e = edge[i];
        int fx = find(e.from),fy = find(e.to);
        if(fx != fy){
            f[fx] = fy;
            if(e.len == 1){
                tot++;
                ans[tot] = e;
            }
        }
        if(e.len == 1){
            e.len = -1;
        }	
    }
    init(n);
    sort(edge+1,edge+m+1,cmp);
    if(tot > k){
        printf("no solution\n");
        return;
    }
    for(int i = 1;i<=tot;i++){
        int fx = find(ans[i].from),fy = find(ans[i].to);
        //printf("%d %d\n",ans[i].from,ans[i].to);
        f[fx] = fy;
    }
    for(int i = 1;i<=m;i++){
        Edge &e = edge[i];
        if(tot == n-1) break;
        int fx = find(e.from),fy = find(e.to);
        if(tot == k && e.len == -1) continue;
        if(tot < k && e.len != -1){
            printf("no solution\n");
            return;          
        }
        if(fx != fy){
            f[fx] = fy;
            ans[++tot] = e;
        }
    }	
    if(tot!=n-1){
        printf("no solution\n");
        return;         
    }
    for(int i = 1;i<=n-1;i++){
        printf("%d %d %d\n",ans[i].from,ans[i].to,1-abs(ans[i].len));
    }
}

void init(){
    scanf("%d %d %d",&n,&m,&k);
    for(int i = 1;i<=m;i++){
        scanf("%d %d %d",&edge[i].from,&edge[i].to,&edge[i].len);
        edge[i].len^=1;
    }
}

int main(){
    init();
    solve();
    return 0;
}
```

