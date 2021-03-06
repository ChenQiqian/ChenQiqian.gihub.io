---
title: 「AHOI2013」联通图-线段树分治+并查集
urlname: AHOI2013-graph
date: 2019-04-05 17:15:43
tags:
- 数据结构
- 线段树分治
- 并查集
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

给定一个 $n$ 个点 $m$ 条边的无向连通图 $G$ 和若干个小集合 $S$，每个小集合包含 $c(1 \le c \le 4)$ 条边，对于每个集合，你需要确定将集合中的边删掉后改图是否保持联通。

集合间的询问相互独立。

<!--more-->

## 链接

[LuoguP5227](https://www.luogu.org/problemnew/show/P5227)

## 题解

感觉现在有一点能感受到线段树分治的精华了。

我们考虑到，维护一个无论啥玩意，一个图不断删去一条边之后我们不能知道这个图是否联通；但是如果我们用并查集维护联通性，那么我们可以在 $O(n\log n)$ 的时间内加边，同时知道这个图是否联通。

所以我们先将问题转化成类似加边的问题，实则其实是维护每条边的出现的区间。

我们发现，任意时刻的删边，都会使这个边由一个大区间的出现变成两个小区间的出现，因为总共的删边在 $O(k)$ 量级，所以说我们就会产生 $O(k)$  个区间，然后我们可以把这些区间撒到线段树上，就有总共 $O(k \log k)$  个操作。

所以我们需要一个可以撤销的并查集？~~我只会可持久化 ，~~但是时间复杂度需要 $O(n \log n)$ 一下，所以我们考虑想办法删除边即可。

我们按秩合并，然后记录一下改了哪些，每次撤销即可。

时间复杂度 ：$O(k \log k \log n)$ 。

## 代码

```cpp
#include <bits/stdc++.h>
using namespace std;

const int MAXN = 210000;

struct Edge{int u,v;}e[MAXN];
int n,m,k,ans[MAXN];

namespace BCJ{
  int f[MAXN],d[MAXN],r;
  pair<int,int> stack[MAXN];int cnt;// 第一个存id，第二个存原来的秩
  void init(int n){for(int i = 1;i<=n;i++) f[i] = i,d[i] = 1;}
  int find(int x){return f[x] == x?x:find(f[x]);}
  void un(int x,int y){
    int fx = find(x),fy = find(y);
    if(fx == fy) return;
    r++;
    if(d[fx] < d[fy]) swap(x,y),swap(fx,fy);
    stack[++cnt] = make_pair(fy,d[fy]);
    stack[++cnt] = make_pair(fx,d[fx]);
    f[fy] = fx;
    if(d[fy] == d[fx]) d[fx]+=1;
  }
  void undo(int lim){// 
    while(cnt > lim){
      int i = cnt,x = stack[i].first,pred = stack[i].second;
      if(f[x] != x) r--;
      f[x] = x,d[x] = pred;cnt--;
    }
  }
}

namespace SegTree{
  vector<int> v[MAXN<<2];
  #define lson (x<<1)
  #define rson (x<<1|1)
  #define mid ((l+r)>>1)
  void update(int x,int l,int r,int ql,int qr,int val){
    if(ql > qr) return;
    if(ql <= l && r <= qr) v[x].push_back(val);
    else{
      if(ql <= mid) update(lson,l,mid,ql,qr,val);
      if(qr >= mid+1) update(rson,mid+1,r,ql,qr,val);
    }
  }
  void solve(int x,int l,int r,int *ans){
    int lim = BCJ::cnt;
    for(int i = 0;i < int(v[x].size());i++) BCJ::un(e[v[x][i]].u,e[v[x][i]].v);
    if(l == r) ans[l] = (BCJ::r == n-1);
    else solve(lson,l,mid,ans),solve(rson,mid+1,r,ans); 
    BCJ::undo(lim);
  }
}

void init(){
  static int tim[MAXN];
  scanf("%d %d",&n,&m);BCJ::init(n);
  int a,b;
  for(int i = 1;i<=m;i++) scanf("%d %d",&a,&b),e[i] = (Edge){a,b};
  scanf("%d",&k);
  for(int i = 1;i<=k;i++){
    scanf("%d",&a);
    for(int w = 1;w<=a;w++){
      scanf("%d",&b);
      SegTree::update(1,1,k,tim[b]+1,i-1,b);
      tim[b] = i;
    }
  }
  for(int i = 1;i<=m;i++) SegTree::update(1,1,k,tim[i]+1,k,i);
}

void solve(){
  SegTree::solve(1,1,k,ans);
  for(int i = 1;i<=k;i++) printf(ans[i]?"Connected\n":"Disconnected\n");
}

int main(){
  init(),solve();
  return 0;
}
```