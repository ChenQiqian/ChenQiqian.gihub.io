---
title: 「AHOI2013」作业-莫队
urlname: AHOI2013-homework
date: 2018-09-15 22:38:10
tags:
- 莫队
- 数据结构
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

给定了一个长度为 $n$ 的数列和 $m$ 个询问。

每个询问给定数列的一个区间 $[l,r]$ ，你要回答两个问题：

+ 该区间内大于等于 $a$ ，小于等于 $b$ 的数的个数，
+ 所有大于等于 $a$ ，小于等于 $b$ 的，且在该区间中出现过的数值的个数。

<!--more-->

## 链接

[Luogu P4396](https://www.luogu.org/problemnew/show/P4396)

## 题解

接近莫队模版题...

这个题的关键在于，你维护每一个数出现的 $times[i]$ 和是否出现 $vis[i]$ 都可以做到 $O(1)$ 更新，但是这个时候你要 $O(1)$ 查询这两个的数列的 $[a,b]$ 区间内的和就比较困难。

我们想到可以用树状数组来维护，但是这样的话 $O( (n+m) \sqrt n \log n)$ 的复杂度有点虚...

注意到我们总共有 $O((n+m) \sqrt n)$ 次修改，但只有 $O(m)$ 次查询，所以我们如果维护一个支持 $O(1)$ 单点修改， $O(1)$ 单点求和， $O(\sqrt n)$ 区间求和的值域分块，那么复杂度就降到 $O((n+m) \sqrt n)$ ，充分可过。

注意需要离散化。

## 代码


```cpp
#include <cstdio>
#include <cmath>
#include <cstring>
#include <algorithm>
#include <map>
using namespace std;

const int MAXN = 110000,MAXQ = 4000;

struct FQ{
  int num[MAXN],sumn[MAXQ],n,Q;
  int block[MAXN],lb[MAXQ],rb[MAXQ];
  void init(int _n){
    memset(num,0,sizeof(num));
    memset(block,0,sizeof(block));
    memset(lb,0,sizeof(lb));
    memset(rb,0,sizeof(rb));
    memset(sumn,0,sizeof(sumn));
    n = _n,Q = sqrt(n)+1;
    for(int i = 1;i<=n;i++){
      block[i] = (i/Q)+1;
      if(block[i] != block[i-1]){
        lb[block[i]] = i;
        rb[block[i-1]] = i-1;
      }
    }
    rb[block[n]] = n;
  }
  void build(int n,int *_num = NULL){
    init(n);
    if(_num){
      for(int i = 1;i<=n;i++){
        num[i] = _num[i];
        sumn[block[i]] += num[i];
      }
    }
  }
  void update(int pos,int v){
    num[pos] += v;
    sumn[block[pos]] += v;
  }
  int query(int l,int r){
    int ll = block[l],rr = block[r],ans = 0;
    if(l > r) return 0;
    if(ll == rr){
      for(int i = l;i<=r;i++) ans += num[i];
      return ans;
    }
    else{
      for(int i = ll + 1;i<rr;i++) ans += sumn[i];
      for(int i = l;i<=rb[ll];i++) ans += num[i];
      for(int i = lb[rr];i<=r;i++) ans += num[i];
    }
    return ans;
  }
}A,B;

int n,m,Q;
int num[MAXN];
int back[MAXN];
int ans1[MAXN],ans2[MAXN];

map<int,int> S;

struct Query{
  int id,l,r,a,b;
}q[MAXN];

bool cmp(Query &_a,Query &_b){
  if(_a.l/Q == _b.l/Q)
    return _a.r < _b.r;
  else
    return _a.l/Q < _b.l/Q;
}

void init(){
  scanf("%d %d",&n,&m);
  Q = sqrt(n)+1;
  for(int i = 1;i<=n;i++){
    scanf("%d",&num[i]);
    S[num[i]] = 0;
  }
  for(int i = 1;i<=m;i++){
    scanf("%d %d %d %d",&q[i].l,&q[i].r,&q[i].a,&q[i].b);
    q[i].id = i;
  }
  int cnt = 0;
  for(map<int,int>::iterator it = S.begin();it!=S.end();it++){
    it->second = ++cnt;
    back[cnt] = it->first;
  }
  for(int i = 1;i<=n;i++){
    num[i] = S[num[i]];
  }
  for(int i = 1;i<=m;i++){
    q[i].a = lower_bound(back+1,back+cnt+1,q[i].a) - (back);
    q[i].b = upper_bound(back+1,back+cnt+1,q[i].b) - (back+1);
  }
  sort(q+1,q+m+1,cmp);
}

void add(int pos){
  if(A.query(num[pos],num[pos]) == 0)
    B.update(num[pos],1);
  A.update(num[pos],1);
}

void del(int pos){
  A.update(num[pos],-1);
  if(A.query(num[pos],num[pos]) == 0)
    B.update(num[pos],-1);
}

void solve(){
  A.build(n),B.build(n);
  int L = 1,R = 0;
  for(int i = 1;i<=m;i++){
    while(q[i].l < L) add(--L); 
    while(R < q[i].r) add(++R);
    while(L < q[i].l) del(L++);
    while(q[i].r < R) del(R--);
    ans1[q[i].id] = A.query(q[i].a,q[i].b);
    ans2[q[i].id] = B.query(q[i].a,q[i].b);
  }
  for(int i = 1;i<=m;i++){
    printf("%d %d\n",ans1[i],ans2[i]);
  }
}

int main(){
  init();
  solve();
  return 0;
}
```

