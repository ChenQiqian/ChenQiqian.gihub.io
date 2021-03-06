---
title: 「网络流 24 题」最小路径覆盖-二分图最大匹配
urlname: loj6002
date: 2019-03-19 22:38:15
tags:
- 图论
- 网络流
- 二分图
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

给定有向图 $G = (V, E)$。设 $P$ 是 $G$ 的一个简单路（顶点不相交）的集合。如果 $V$ 中每个顶点恰好在 $P$ 的一条路上，则称 $P$ 是 $G$ 的一个路径覆盖。 $P$ 中路径可以从 $V$ 的任何一个顶点开始，长度也是任意的，特别地，可以为 $0$ 。 $G$ 的最小路径覆盖是 $G$ 的所含路径条数最少的路径覆盖。

设计一个有效算法求一个有向无环图 $G$ 的最小路径覆盖。

<!--more-->

## 链接

[LOJ6002](https://loj.ac/problem/6002)

## 题解

这个题可以转化成二分图匹配来做。

因为顶点不相交，所以每个顶点至多有一个入度 & 出度，所以如果两个边能接上，我们的答案就可以减掉一个 1 。

什么情况下答案可以减掉 1 ？就是我们能通过一条边连起来两个点的时候。然后放到原来的图上，连起来自然就是答案。那么这样的话，我们就可以构建一个二分图，把每个点拆成两个，原图上的边从左侧出，右侧入即可。

输出方案的话，就遍历每条边（就是二分图里面满流的边），记录一下每个点的往后走和往前走的节点是什么，然后找到所有链头一路往后跳就可以了。

## 代码

```cpp
#include <bits/stdc++.h>
#define inf 0x3f3f3f3f
using namespace std;

const int MAXN = 410,MAXM = MAXN*MAXN*2;

struct Edge{
  int from,to;
  int cap,flow;
  int nex;
}edge[MAXM];
int fir[MAXN],ecnt = 2;
void addedge(int a,int b,int c){
  edge[ecnt] = (Edge){a,b,c,0,fir[a]};fir[a] = ecnt++;
  edge[ecnt] = (Edge){b,a,0,0,fir[b]};fir[b] = ecnt++;
}

int dis[MAXN];
bool bfs(int s,int t){
  static queue<int> q;
  memset(dis,0,sizeof(dis));while(!q.empty()) q.pop();
  dis[s] = 1;q.push(s);
  while(!q.empty()){
    int x = q.front();q.pop();
    for(int e = fir[x];e;e = edge[e].nex){
      int v = edge[e].to;
      if(!dis[v] && edge[e].cap > edge[e].flow){
        dis[v] = dis[x] + 1,q.push(v);
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

int n,m,S,T;
int pre[MAXN],nxt[MAXN];

void print_chain(){
  for(int x = 1;x<=n;x++){
    for(int e = fir[x];e;e = edge[e].nex){
      int v = edge[e].to;
      if(!(n <= v && v <= 2*n)) continue;
      if(edge[e].flow == 1){
        pre[v-n] = x,nxt[x] = v-n;
      }
    }
  }
  for(int x = 1;x<=n;x++){
    if(pre[x] == 0){// 链子头
      for(int t = x;t;t = nxt[t]) printf("%d ",t);
      printf("\n");
    }
  }
}

void init(){
  scanf("%d %d",&n,&m);S = 2*n+1,T = S + 1;
  for(int i = 1;i<=m;i++){
    int a,b;
    scanf("%d %d",&a,&b);
    addedge(a,b+n,1);
  }
  for(int i = 1;i<=n;i++) addedge(S,i,1),addedge(i+n,T,1);
}

void solve(){
  int ans = n - dinic(S,T);
  print_chain();
  printf("%d\n",ans);
}

int main(){
  init(),solve();
  return 0;
}
```