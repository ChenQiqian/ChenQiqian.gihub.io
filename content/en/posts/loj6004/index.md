---
title: 「网络流 24 题」圆桌聚餐-网络最大流
urlname: loj6004
date: 2019-03-20 21:12:17
tags:
- 图论
- 网络流
categories:
- OI
- 题解
series:
- 网络流 24 题
libraries:
- mathjax 
##-- toc setting --##
hideToc: false
enableToc: true
enableTocContent: false
---

假设有来自 $m$ 个不同单位的代表参加一次国际会议。每个单位的代表数分别为 $r_i$ 。会议餐厅共有 $n$ 张餐桌，每张餐桌可容纳 $c_i$ 个代表就餐。

为了使代表们充分交流，希望从同一个单位来的代表不在同一个餐桌就餐。

试设计一个算法，给出满足要求的代表就餐方案。

<!--more-->

## 链接

[LOJ6004](https://loj.ac/problem/6004)

## 题解

我们可以把这个题转化成网络最大流解决。

每个单位一个点 $1$ ～ $m$ ，每个餐桌一个点 $m+1$ ～ $m+n$ ，源点向单位连边，餐桌向汇点连边，分别是对应容量；每个单位向每个餐桌连边，容量为 $1$ 。 如果最大流等于人数，就有解，否则无解。

输出方案我们考虑对每个单位的点，遍历出边，找出连向餐桌的有流量的边的另一段，对应餐桌的就是单位的每个人去的餐桌。

## 代码

```cpp
#include <bits/stdc++.h>
#define inf 0x3f3f3f3f
using namespace std;

const int MAXN = 500,MAXM = MAXN*MAXN*2;

struct Edge{
  int from,to;
  int cap,flow;
  int nex;
}edge[MAXM];
int fir[MAXN],ecnt = 2;
void addedge(int a,int b,int c){
  edge[ecnt] = (Edge){a,b,c,0,fir[a]},fir[a] = ecnt++;
  edge[ecnt] = (Edge){b,a,0,0,fir[b]},fir[b] = ecnt++;
}

int dis[MAXN];
bool bfs(int s,int t){
  static queue<int> q;
  memset(dis,0,sizeof(dis));while(!q.empty()) q.pop();
  dis[s] = 1,q.push(s);
  while(!q.empty()){
    int x = q.front();q.pop();
    for(int e = fir[x];e;e = edge[e].nex){
      int v = edge[e].to;
      if(!dis[v] && edge[e].cap > edge[e].flow){
        dis[v] = dis[x]+1;q.push(v);
      }
    }
  }
  return dis[t];
}

int dfs(int x,int t,int limit = inf){
  if(limit == 0 || x == t) return limit;
  int sumf = 0;
  for(int e = fir[x];e;e = edge[e].nex){
    int v = edge[e].to;
    if(dis[v] == dis[x] + 1){
      int f = dfs(v,t,min(limit,edge[e].cap - edge[e].flow));
      if(f){
        sumf += f,limit -= f;
        edge[e].flow += f,edge[e^1].flow -= f;
      }
      if(limit == 0) break;
    }
  }
  return sumf;
}

int dinic(int s,int t){
  int ans = 0;
  while(bfs(s,t)) ans += dfs(s,t);
  return ans;
}

int n,m;
int sa[MAXN],sb[MAXN];
vector<int> ANS[MAXN];

void init(){
  scanf("%d %d",&m,&n);
  for(int i = 1;i<=m;i++) scanf("%d",&sb[i]);
  for(int i = 1;i<=n;i++) scanf("%d",&sa[i]);
}

void solve(){
  int S = n+m+1,T = S+1,sum = 0;
  for(int i = 1;i<=m;i++) addedge(S,i,sb[i]),sum += sb[i];
  for(int i = 1;i<=n;i++) addedge(m+i,T,sa[i]);
  for(int i = 1;i<=m;i++){
    for(int j = 1;j<=n;j++){
      addedge(i,m+j,1);
    }
  }
  int ans = dinic(S,T);
  if(ans != sum) return (printf("0\n"),void(0));
  printf("1\n");
  for(int x = 1;x<=m;x++){
    for(int e = fir[x];e;e = edge[e].nex){
      int v = edge[e].to;
      if(edge[e].flow == 1) printf("%d ",v-m);
    }
    printf("\n");
  }
}

int main(){
  init();
  solve();
}
```