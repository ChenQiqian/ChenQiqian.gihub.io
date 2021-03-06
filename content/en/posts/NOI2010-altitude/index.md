---
title: 「NOI2010」海拔-网络流/最短路
urlname: NOI2010-altitude
date: 2018-08-21 21:53:16
tags:
- 最短路
- 网络流
- 对偶图
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


> 题面请点击**查看全文**

<!--more-->

$\text{YT}$ 市是一个规划良好的城市，城市被东西向和南北向的主干道划分为 $n\times n$ 个区域。简单起见，可以将 $\text{YT}$ 市看作一个正方形，每一个区域也可看作一个正方形。从而，$YT$ 城市中包括 $(n+1) \times (n+1)$ 个交叉路口和 $2n \times (n+1)$ 条双向道路（简称道路），每条双向道路连接主干道上两个相邻的交叉路口。

小 $\text{Z}$ 作为该市的市长，他根据统计信息得到了每天上班高峰期间 $\text{YT}$ 市每条道路两个方向的人流量，即在高峰期间沿着该方向通过这条道路的人数。每一个交叉路口都有不同的海拔高度值， $\text{YT}$ 市市民认为爬坡是一件非常累的事情，每向上爬 $h$ 的高度，就需要消耗 $h$ 的体力。如果 是下坡的话，则不需要耗费体力。因此如果一段道路的终点海拔减去起点海拔的值为 $h$ (注意 $h$ 可能是负数)，那么一个人经过这段路所消耗的体力是 $\max(0, h)$ 。

小 $\text{Z}$ 还测量得到这个城市西北角的交叉路口海拔为 $0$ ，东南角的交叉路口海拔为 $1$ ，但其它交叉路口的海拔高度都无法得知。小 $\text{Z}$ 想知道在最理想的情况下（即你可以任意假设其他路口的海拔高度），每天上班高峰期间所有人爬坡消耗的总体力和的最小值。

<!--more-->

## 链接

[Luogu P2046](https://www.luogu.org/problemnew/show/P2046)

## 题解

可以发现，应该所有点的海拔都要么是 $0$ ，要么是 $1$ ，可以取到最优解。而且分界线应该是一条连续的线，让我们联想到最小割。

但是这个数据范围太大了，直接跑最大流会超时，所以我们将这个图转化成对偶图，根据切割方向选择边的长度，然后跑最短路即可。注意不能用 $\text{SPFA}$ 。

## 代码


```cpp
#include <cstdio>
#include <queue>
#include <algorithm>
#include <cstring>
#define ll long long
using namespace std;

const int MAXN = 300000,MAXM = 2400000;
const int N = 510;

struct Edge{
    int from,to;
    ll len;int nex;
}edge[MAXM];

int n,m,s,t;
int fir[MAXN],ecnt = 2;
int a[N][N],b[N][N],c[N][N],d[N][N];


void addedge(int a,int b,int c){s
    edge[ecnt] = (Edge){a,b,c,fir[a]};
    fir[a] = ecnt++;
}

struct Point{
    int x;ll d;
    bool operator <(const Point &a)const{
        return d > a.d;
    }
};

ll dis[MAXN];
bool vis[MAXN];
priority_queue<Point> q;

void dij(){
    for(int i = 1;i<=n*n+2;i++) dis[i] = 2147483647;
    dis[s] = 0;
    q.push((Point){s,0});
    while(!q.empty()){
        Point now = q.top();q.pop();
        int nown = now.x,nowd = dis[nown];
        if(vis[nown]) continue;
        vis[nown] = 1;
        for(int nowe = fir[nown];nowe;nowe = edge[nowe].nex){
            int v = edge[nowe].to,l = edge[nowe].len;
            if(dis[v] > nowd + l){
                dis[v] = nowd + l;
                q.push((Point){v,dis[v]});
            }
        }
    }
}


int _hash(int i,int j){
    if(i <= 0 || j > n) return s;
    if(j <= 0 || i > n) return t;
    return (i-1)*n+j;
}

void init(){
    scanf("%d",&n);n++;
    for(int i = 1;i<=n;i++)
        for(int j = 1;j<=n-1;j++)
            scanf("%d",&a[i][j]);
    for(int i = 1;i<=n-1;i++)
        for(int j = 1;j<=n;j++)
            scanf("%d",&b[i][j]);
    for(int i = 1;i<=n;i++)
        for(int j = 2;j<=n;j++)
            scanf("%d",&c[i][j]);
    for(int i = 2;i<=n;i++)
        for(int j = 1;j<=n;j++)
            scanf("%d",&d[i][j]);
    n--;
}

void solve(){
    s = n*n+1,t = n*n+2;
    for(int i = 1;i<=n;i++){
        for(int j = 1;j<=n;j++){
 			addedge(_hash(i,j),_hash(i+1,j),a[i+1][j]);
 			addedge(_hash(i,j),_hash(i,j+1),d[i+1][j+1]);
 			addedge(_hash(i,j),_hash(i-1,j),c[i][j+1]);
 			addedge(_hash(i,j),_hash(i,j-1),b[i][j]);
        }
    }
    for(int i = 1;i<=n;i++){
        addedge(s,_hash(1,i),a[1][i]);
        addedge(s,_hash(i,n),b[i][n+1]);
        //addedge(,s,),addedge(,s,);
    }
    for(int i = 1;i<=n;i++){
        addedge(_hash(i,1),t,b[i][1]);
        addedge(_hash(n,i),t,a[n+1][i]);
        //addedge(t,,),addedge(t,,);
    }
    dij();
    printf("%lld\n",dis[t]);
}

signed main(){
    init();
    solve();
    return 0;
}
```

