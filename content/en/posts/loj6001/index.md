---
title: 「网络流 24 题」太空飞行计划-最大权闭合子图
urlname: loj6001
date: 2019-03-19 19:43:52
tags:
- 图论
- 最大权闭合子图
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


W 教授正在为国家航天中心计划一系列的太空飞行。每次太空飞行可进行一系列商业性实验而获取利润。现已确定了一个可供选择的实验集合 $E = \{ E_1, E_2, \cdots, E_m \}$ ，和进行这些实验需要使用的全部仪器的集合 $I = \{ I_1, I_2, \cdots, I_n \}$ 。实验 $E_j$ 需要用到的仪器是 $I$ 的子集 $R_j \subseteq I$ 。配置仪器 $I_k$ 的费用为 $c_k$ 美元。实验 $E_j$ 的赞助商已同意为该实验结果支付 $p_j$ 美元。W 教授的任务是找出一个有效算法，确定在一次太空飞行中要进行哪些实验并因此而配置哪些仪器才能使太空飞行的净收益最大。这里净收益是指进行实验所获得的全部收入与配置仪器的全部费用的差额。

对于给定的实验和仪器配置情况，编程找出净收益最大的试验计划。

<!--more-->

## 链接

[LOJ6001](https://loj.ac/problem/6001)

## 题解

这种问题事实上是一个最大权闭合子图的问题。

我们把一个实验抽象成一个点（编号 $1$ - $m$ ），一个仪器也抽象成一个点（编号 $m+1$ - $m+n$），再从每个实验往其需要的器材连一条有向边。

这个时候我们需要求出的是一个最大权的闭合子图，节点的权值可正可负（实验正，仪器负）。

这个时候我们怎么做呢？我们把 $S$ 向所有正权值的点连权值容量的边，所有原图中的边都连$\inf$ ，所有负权值的点都向 $T$ 连一个权值的绝对值容量的边。

这个时候所有正权值的和减去 $S$ 和 $T$ 的最小割就是答案。如何证明？我们考虑每次割都是一个代价，也就是选了负权和不选正权，都会带来一个代价，然后我们想让这个代价最小，所以就是最小割。

这个时候可以发现，和 $S$ 联通（能够通过非满流边到达）的都是要选的实验和仪器， dfs 一次即可完成。

## 代码

```cpp
#include <bits/stdc++.h>
#define inf 0x3f3f3f3f
using namespace std;

const int MAXN = 110,MAXM = MAXN*MAXN;

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

int n,m, dis[MAXN];

bool bfs(int s,int t){
  static queue<int> q;
  memset(dis,0,sizeof(dis));while(!q.empty()) q.pop();
  dis[s] = 1;q.push(s);
  while(!q.empty()){
    int x = q.front();q.pop();
    for(int e = fir[x];e;e = edge[e].nex){
      int v = edge[e].to;
      if(!dis[v] && edge[e].cap > edge[e].flow){
        dis[v] = dis[x] + 1;q.push(v);
      }
    }
  }
  return dis[t];
}

int dfs(int x,int t,int limit = inf){
  if(x == t || limit == 0) return limit;
  int sumf = 0;
  for(int e = fir[x];e;e = edge[e].nex){
    int v = edge[e].to;
    if(dis[v] == dis[x]+1 && edge[e].cap > edge[e].flow){
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



vector<int> node[MAXN];
int val[MAXN],cost[MAXN];
vector<int> ans1,ans2;

void dfs1(int x){
  if(1 <= x && x <= m) ans1.push_back(x);
  if(m+1 <= x && x <= m+n) ans2.push_back(x-m);
  int t = 0;swap(t,dis[x]);
  for(int e = fir[x];e;e = edge[e].nex){
    int v = edge[e].to;
    if(dis[v] == t+1) dfs1(v);
  }
}

void init(){
  scanf("%d %d",&m,&n);
  // 1 -> m 实验，m+1 -> m+n 物品
  static char s[MAXN*10];
  for(int i = 1;i<=m;i++){
    scanf("%d",&val[i]);
    int t;
    while(scanf("%[\n\r]",s)!=1){
      scanf("%d",&t);
      node[i].push_back(t);
    }
  }
  for(int i = 1;i<=n;i++) scanf("%d",&cost[i]);
}

void solve(){
  int S = n+m+1,T = S+1,sum = 0;
  for(int i = 1;i<=m;i++) addedge(S,i,val[i]),sum += val[i];
  for(int i = 1;i<=m;i++) for(auto x : node[i]) addedge(i,m+x,inf);
  for(int i = 1;i<=n;i++) addedge(m+i,T,cost[i]);
  int ans = sum - dinic(S,T);
  bfs(S,T);
  dfs1(S);
  sort(ans1.begin(),ans1.end()),sort(ans2.begin(),ans2.end());
  for(unsigned i = 0;i<ans1.size();i++){
    printf("%d",ans1[i]);putchar(i != ans1.size()-1?' ':'\n');
  }
  for(unsigned i = 0;i<ans2.size();i++){
    printf("%d",ans2[i]);putchar(i != ans2.size()-1?' ':'\n');
  }
  printf("%d\n",ans);
}

int main(){
  init();
  solve();
}
```


