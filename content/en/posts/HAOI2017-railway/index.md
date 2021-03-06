---
title: 「HAOI2017」八纵八横-线段树分治+线性基
urlname: HAOI2017-railway
date: 2019-04-05 13:07:59
tags:
- 数据结构
- 线段树分治
- 线性基
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

Anihc 国有 $n$ 个城市，这 $n$ 个城市从 $1$ ~ $n$ 编号，$1$ 号城市为首都。城市间初始时有 $m$ 条高速公路，每条高速公路都有一个非负整数的经济影响因子，每条高速公路的两端都是城市（可能两端是同一个城市)，保证任意两个城市都可以通过高速公路互达。

Anihc 国正在筹划「八纵八横」的高铁建设计划，计划要修建一些高速铁路，每条高速铁路两端也都是城市（可能两端是同一个城市)，也都有一个非负整数的经济影响因子。国家还计划在「八纵八横」计划建成之后，将「一带一路」扩展为「一带一路一环」，增加「内陆城市经济环」即选择一条从首都出发沿若一系列高铁与高速公路走的路径，每条高铁或高速公路可以经过多次，每座城市也可以经过多次，最后路径又在首都结束。令「内陆城市经济环」的 GDP 为依次将这条路径上所经过的高铁或高速公路的经济影响因子异或起来（一条路经过多次则会被计算多次）。

现在 Anihc 在会议上讨论「八纵八横」的建设计划方案，他们会不断地修改计划方案，希望你能实时反馈对于当前的「八纵八横」的建设计划的方案「内陆城市经济环」的最大是多少。

初始时，八纵八横计划中不包含任何—条高铁，有以下三种操作：

- `Add x y z` ：在计划中给在城市 $x$ 和城市 $y$ 之间建设一条高铁，其经济影响因子为 $z$ ，如果这是第 $k$ 个 Add 操作，则将这条高铁命名为 $k$ 号高铁。

- `Cancel k` ：将计划中的 $k$ 号高铁取消掉，保证此时 $k$ 号高铁一定存在。

- `Change k z` ：表示将第 $k$ 号高铁的经济影响因子更改为 $z$ ，保证此时 $k$ 号高铁一定存在。

<!--more-->

## 链接

[LOJ2312](https://loj.ac/problem/2312)

[Luogu P3733](https://www.luogu.org/problemnew/show/P3733)

## 题解

P.S. 八纵八横赛艇啊！

没有加边/删边/改权值的话，这个题就是 WC2011 最大 XOR 路径。

有了修改怎么办？我们对时间分治/分块就会好很多。

我们考虑对时间建立线段树，那么每条路都会有一个出现的时间区间，我们用线段树的方法把这个区间分到 $\log Q$ 个节点上。这样总共有 $O(Q \log Q)$ 个节点上存在一个修改。

对于线性基的问题，我们考虑在线段树上解决这个问题。在一个长度为 $len$ 的线性基（ `bitset` 优化）里面插入一个数的复杂度是：$O(\frac{len^2}{w})$ ，复制一个线性基的代价是 $O(\frac{len^2}{w})$ 。我们考虑在线段树上dfs（感觉是），然后我们需要维护这个叶子到原点的链上的线性基即可。那么我们一共要复制 $O(Q)$ 次线性基，累计插入 $O(Q \log Q)$ 次，查询一次的复杂度也是 $O(\frac{len^2}{w})$ ，所以最后的主要的时间复杂度应该是 $O(Q \log Q \frac{len^2}{w})$ 。

对于环的获得，我们考虑到可以先搞出原图的一个生成树（dfs 即可），然后把所有非树边加进去即可。每次改变一个边，我们都只加入一个环：`dis[x]^dis[y]^v` ，其实就是生成树上的环。其他的环都可以并出来。

居然跑的这么快orz

## 代码

```cpp
#include <bits/stdc++.h>
#define bs bitset<MAXN>
using namespace std;

const int MAXN = 1500,LOGN = 15;

void char_to_bs(char *s,bs &res){
  int l = strlen(s);reverse(s,s+l);
  res.reset();
  for(int i = 0;i<l;i++){
    if(s[i] == '1') res[i] = 1;
    else if(s[i] == '0') res[i] = 0;
    else assert(0);
  }
}
void bs_to_char(bs &s){int flag = 0;
  for(int i = MAXN-1;i>=0;i--){
    if(s[i] == 1) flag = 1;
    if(flag) putchar(s[i]+'0');
  }if(!flag) putchar('0');
}

struct LB{
  bs basis[MAXN];
  void clear(){for(int i = 0;i<MAXN;i++) basis[i].reset();}
  void ins(bs x){
    for(int i = MAXN-1;i>=0;--i){
      if(x[i] == 0) continue;
      if(basis[i].any()) x ^= basis[i];
      else         {basis[i] = x;break;}
    }
  }
  bs query(){
    bs res;
    for(int i = MAXN-1;i>=0;--i) if(!res[i]) res ^= basis[i];
    return res;
  }
}BS[LOGN];

namespace SegTree{
  vector<bs> v[MAXN<<2];
  #define lson (x<<1)
  #define rson (x<<1|1)
  #define mid ((l+r)>>1)
  void update(int x,int l,int r,int ql,int qr,bs val){
    if(ql <= l && r <= qr) v[x].push_back(val);
    else{
      if(ql <= mid) update(lson,l,mid,ql,qr,val);
      if(qr >= mid+1) update(rson,mid+1,r,ql,qr,val);
    }
  }
  void solve(int x,int l,int r,int level,bs *ans){
    BS[level] = BS[level-1];
    for(int i = 0;i < (int)(v[x].size());i++) BS[level].ins(v[x][i]);
    if(l == r) ans[l] = BS[level].query();
    else{
      solve(lson,l,mid,level+1,ans);
      solve(rson,mid+1,r,level+1,ans);
    }
  }
}

struct Edge{
  int to,nex;bs v;
}edge[MAXN*2];
int fir[MAXN],ecnt = 2;
void addedge(int a,int b,bs c){
  edge[ecnt] = (Edge){b,fir[a],c},fir[a] = ecnt++;
}

int n,m,q,k;
int a[MAXN],b[MAXN],tim[MAXN];bs c[MAXN];
int vis[MAXN];bs dis[MAXN];
bs ans[MAXN];

void dfs(int x,int fa){
  vis[x] = 1;
  for(int e = fir[x];e;e = edge[e].nex){
    int v = edge[e].to;
    if(v == fa) continue;
    if(vis[v] == 1)
      SegTree::update(1,0,q,0,q,dis[x]^dis[v]^edge[e].v);
    else{
      dis[v] = dis[x] ^ edge[e].v;
      dfs(v,x);
    }
  }
}

void init(){
  scanf("%d %d %d",&n,&m,&q);
  static char ss[MAXN];
  for(int i = 1;i<=m;i++){
    scanf("%d %d",&a[i],&b[i]);
    scanf("%s",ss);char_to_bs(ss,c[i]);
    addedge(a[i],b[i],c[i]),addedge(b[i],a[i],c[i]);
  }
}

void solve(){
  static char op[20],ss[MAXN];int t;bs tmp;
  for(int i = 1;i<=q;i++){
    scanf("%s",op);
    if(op[0] == 'A'){++k; // Add
      tim[k] = i;
      scanf("%d %d",&a[k],&b[k]);
      scanf("%s",ss);char_to_bs(ss,c[k]);
    }
    else if(op[1] == 'a'){// Cancel
      scanf("%d",&t);
      SegTree::update(1,0,q,tim[t],i-1,c[t]^dis[a[t]]^dis[b[t]]);
      tim[t] = -i;
    }
    else if(op[1] == 'h'){// Change
      scanf("%d",&t);
      scanf("%s",ss);char_to_bs(ss,tmp);
      SegTree::update(1,0,q,tim[t],i-1,c[t]^dis[a[t]]^dis[b[t]]);
      c[t] = tmp,tim[t] = i;
    }
    else assert(0);
  }
  for(int i = 1;i<=k;i++)if(tim[i] > 0){
    SegTree::update(1,0,q,tim[i],q,c[i]^dis[a[i]]^dis[b[i]]);
  }
  SegTree::solve(1,0,q,1,ans);
}

void output(){for(int i = 0;i<=q;i++) bs_to_char(ans[i]),putchar('\n');}

int main(){
  init();
  dfs(1,0);
  solve();
  output();
  return 0;
}
```


