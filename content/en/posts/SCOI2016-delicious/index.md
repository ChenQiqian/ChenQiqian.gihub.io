---
title: 「SCOI2016」美味-可持久化线段树
urlname: SCOI2016-delicious
date: 2018-12-11 21:16:36
tags:
- 数据结构
- 线段树
- 可持久化主席树
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

一家餐厅有 $n$ 道菜，编号 $1,\dots,n$ ，大家对第 $i$ 道菜的评价值为 $a_i(1 \leq i \leq n)$。有 $m$ 位顾客，第 $i$ 位顾客的期望值为 $b_i$，而他的偏好值为 $x_i$ 。因此，第 $i$ 位顾客认为第 $j$ 道菜的美味度为 $b_i\ \text{XOR}\ (a_j+x_i)$ ，$\text{XOR}$ 表示异或运算。

第 $i$ 位顾客希望从这些菜中挑出他认为最美味的菜，即美味值最大的菜，但由于价格等因素，他只能从第 $l_i$ 道到第 $r_i$ 道中选择。请你帮助他们找出最美味的菜。

<!--more-->

## 链接

[Luogu P3293](https://www.luogu.org/problemnew/show/P3293)

## 题解

我们观察到区间限制，很容易让我们想到主席树，再观察到异或运算、最大，很容易联想到 0/1 Trie 树。

所以我们就按照主席树的方法建一颗 0/1 可持久化 Trie 树。

如果没有 $x_i$ 的运算，上面的解法就可以解决了。我们直接按照 $a_j$ 从高往低每位贪心取反即可，但我们注意到有了一个 $(a_j + x_i)$ 的限制。

这个问题中，我们需要建立一个权值线段树（可持久化），再每位贪心，但是我们需要再线段树上把那一段找出来，然后再走向左右区间。

时间复杂度是两个 $log$ ，因为其特殊性不能在线段树上直接二分，因此复杂度：$O(m \log^2 10^5 )$。

## 代码


```cpp
#include <bits/stdc++.h>
using namespace std;

const int MAX = 210000;
const int MAXN = 210000,logn = 19;
int n,m,a[MAXN],rt[MAXN];

namespace prSegTree{
  int sumn[MAXN*logn],ls[MAXN*logn],rs[MAXN*logn],cnt;
  #define mid ((l+r)>>1)
  void update(int &nown,int pre,int l,int r,int pos,int v){
    nown = ++cnt;ls[nown] = ls[pre],rs[nown] = rs[pre],sumn[nown] = sumn[pre];
    if(l == r)
      sumn[nown] += v;
    else{
      if(pos <= mid) update(ls[nown],ls[pre],l,mid,pos,v);
      if(pos >= mid+1) update(rs[nown],rs[pre],mid+1,r,pos,v);
      sumn[nown] = sumn[ls[nown]] + sumn[rs[nown]];
    }
  }  
  int query(int nown,int l,int r,int ql,int qr){
    if(!nown) return 0;
    if(ql <= l && r <= qr){
      return sumn[nown];
    }
    else{
      int ans = 0;
      if(ql <= mid) ans += query(ls[nown],l,mid,ql,qr);
      if(qr >= mid+1) ans += query(rs[nown],mid+1,r,ql,qr);
      return ans;
    }
  }
  int query(int lx,int rx,int ql,int qr){
    ql = max(1,ql),qr = min(qr,MAX);
    if(ql > qr) return 0;
    return query(rx,1,MAX,ql,qr) - query(lx,1,MAX,ql,qr);
  }
}

void init(){
  scanf("%d %d",&n,&m);
  for(int i = 1;i<=n;i++)
    scanf("%d",&a[i]);
  for(int i = 1;i<=n;i++)
    prSegTree::update(rt[i],rt[i-1],1,MAX,a[i],1);
}

int query(int b,int x,int l,int r){
  int ans = 0,tmp = 0;
  for(int i = 20;i>=0;i--){//该考虑 (1<<i) 的位置
    if(b&(1<<i)){
      if(prSegTree::query(rt[l-1],rt[r],tmp-x,tmp+(1<<i)-x-1) > 0)
        ans += (1<<i);
      else
        tmp += (1<<i);
    }
    else{
      if(prSegTree::query(rt[l-1],rt[r],tmp+(1<<i)-x,tmp+(1<<(i+1))-x-1) > 0) 
        ans += (1<<i),tmp += (1<<i);
    }
  }
  return ans;
}

void solve(){
  for(int i = 1;i<=m;i++){
    int b,x,l,r;
    scanf("%d %d %d %d",&b,&x,&l,&r);
    printf("%d\n",query(b,x,l,r));
  }
}

int main(){
  init();
  solve();
  return 0;
}
```

