---
title: 「JLOI2011」飞行路线-分层图最短路
urlname: JLOI2011-flight
date: 2018-10-26 23:29:36
tags:
- 图论
- 最短路
- 分层图
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

Alice 和 Bob 现在要乘飞机旅行，他们选择了一家相对便宜的航空公司。该航空公司一共在 $n$ 个城市设有业务，设这些城市分别标记为 $0$ 到 $n-1$，一共有 $m$ 种航线，每种航线连接两个城市，并且航线有一定的价格。

Alice和Bob现在要从一个城市沿着航线到达另一个城市，途中可以进行转机。航空公司对他们这次旅行也推出优惠，他们可以免费在最多 $k$ 种航线上搭乘飞机。那么Alice和Bob这次出行最少花费多少？



<!--more-->

## 链接

[**Luogu P4568**](https://www.luogu.org/problemnew/show/P4568)

## 题解

建出 $k+1$ 层图，$i$ 层往 $i+1$ 层在原图边上的位置加边权为 $0$ 的边，其余每层正常加边，第一层的 $s$ 向 $k+1$ 层的 $t$ 跑最短路即可。

数组要开够emmm

## 代码



```cpp
#include <bits/stdc++.h>
using namespace std;

const int MAXN = 510000,MAXM = 4010000;

struct Edge{
    int to,len,nex;
}edge[MAXM];int ecnt = 2;
int fir[MAXN];
void addedge(int a,int b,int c){
    edge[ecnt] = (Edge){b,c,fir[a]};
    fir[a] = ecnt++;
}

int n,m,k,s,t;

int _hash(int nown,int c){
    return (c-1) * n + nown;
}

void init(){
    scanf("%d %d %d %d %d",&n,&m,&k,&s,&t);
    s++,t++;
    for(int i =  1;i<=m;i++){
        int a,b,c;
        scanf("%d %d %d",&a,&b,&c);
        a++,b++;
        for(int w = 1;w<=k+1;w++){
            addedge(_hash(a,w),_hash(b,w),c);
            addedge(_hash(b,w),_hash(a,w),c);
            if(w != k+1){
                addedge(_hash(a,w),_hash(b,w+1),0);
                addedge(_hash(b,w),_hash(a,w+1),0);
            }
        }
    }
}

int dis[MAXN],vis[MAXN];

struct Node{
    int x,d;	
    bool operator < (const Node &_n)const{
        return d > _n.d;
    }
};

priority_queue<Node> q;

void dij(){
    while(!q.empty()) q.pop();
    memset(dis,0x3f,sizeof(dis));
    memset(vis,0,sizeof(vis));
    int ss = _hash(s,1),tt = _hash(t,k+1);
    dis[ss] = 0;
    q.push((Node){ss,0});
    while(!q.empty()){
        Node now = q.top();q.pop();
        int nown = now.x,nowd = now.d;
        if(vis[nown] == 1) continue;
        vis[nown] = 1,dis[nown] = nowd;
        for(int nowe = fir[nown];nowe;nowe = edge[nowe].nex){
            int v = edge[nowe].to,len = edge[nowe].len;
            if(nowd + len < dis[v]){
                dis[v] = nowd + len;
                q.push((Node){v,dis[v]});
            }
        }
    }
}

void solve(){
    dij();
    printf("%d\n",dis[_hash(t,k+1)]);
}

int main(){
    init();
    solve();
    return 0;
}
```


