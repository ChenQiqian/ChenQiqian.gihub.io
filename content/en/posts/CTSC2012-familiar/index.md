---
title: 「CTSC2012」熟悉的文章-广义后缀自动机
urlname: CTSC2012-familiar
date: 2019-01-18 22:51:41
tags:
- 字符串
- 后缀自动机
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

为了有说服力地向阿米巴展示阿米巴的作文是多么让人觉得“眼熟”，小强想出了一个评定作文 “熟悉程度”的量化指标：$L_0$ .小强首先将作文转化成一个 $01$ 串。之后，小强搜集了各路名家的文章，同样分别转化成 $01$ 串后，整理出一个包含了 $M$ 个 $01$ 串的“ 标准作文库 ”。

小强认为：如果一个 $01$ 串长度不少于 $L$ 且在 标准作文库 中的某个串里出现过（即，它是 标准作文库 的 某个串 的一个 连续子串 ），那么它是“ 熟悉 ”的。对于一篇作文（一个 $01$ 串）A，如果能够把 A 分割成若干段子串，其中“ 熟悉 ” 的子串的 长度总和 不少于 A 总长度的 $90\%$，那么称 A 是 “ 熟悉的文章 ”。 $L_0$ 是能够让 $A$ 成为 “ 熟悉的文章 ” 的 所有 $L$ 的最大值 （如果不存在这样的 $L$ ，那么规定 $L_0 = 0$ ）。

<!--more-->

## 链接

[Luogu P4022](https://www.luogu.org/problemnew/show/P4022)

## 题解

我们注意到首先外面可以套一个二分，单调性显然成立。

我们需要对这个地方所有的标准作文库建立一个广义 SAM （或者串一起也可以，基本上是等价的）。

然后我们的问题变成了存在性问题：是否存在一种分割方案，其中熟悉的子串的长度均不小于 $L$  且在标准作文库里面出现过，且和大于 $90\%$ 。

我们用一个 $dp[i]$ 表示在这种限制下在 $[1,i]$ 的子串的最大的熟悉的长度，然后我们明显有一个 $O(n^2)$ 的解法（需要预处理我们要判断的作文的每个位置在广义SAM上能够最长匹配的长度，这里用在SAM上跑+暴力跳 Fail 树，判断当前最长是不是在你要符合的区间，理论时间复杂度 $O(n \log n)$，不会证明）。

猜测存在决策单调性，事实上的确成立。用单调队列维护即可。

所以时间复杂度大约是： $O(n \log n)$ ~ $O(n \log^2 n)$ $\approx O(\text{能过})$ 。

后缀自动机的题啊，感觉时间复杂度对就行了，比如 NOID1T3 。多妙啊！

## 代码


```cpp
#include <bits/stdc++.h>
using namespace std;

const int MAXN = 2100000;

namespace SAM{
  int c[MAXN][2],l[MAXN],fa[MAXN],cnt,last,rt;
  void init(){rt = last = ++cnt;}
  int newnode(int x){l[++cnt] = x;return cnt;}
  int ins(int p,int x){
    if(c[p][x]){
      int q = c[p][x];
      if(l[q] == l[p] + 1) last = q;
      else{
        int nq = newnode(l[p]+1);last = nq;
        memcpy(c[nq],c[q],sizeof(c[q]));
        fa[nq] = fa[q];fa[q] = nq;
        for(;c[p][x] == q;p = fa[p]) c[p][x] = nq;
      }
    }
    else{
      int np = newnode(l[p]+1);last = np;
      for(;p && (!c[p][x]);p = fa[p]) c[p][x] = np;
      if(!p) fa[np] = rt;
      else{
        int q = c[p][x];
        if(l[q] == l[p]+1) fa[np] = q;
        else{
          int nq = newnode(l[p]+1);
          memcpy(c[nq],c[q],sizeof(c[q]));
          fa[nq] = fa[q];fa[q] = fa[np] = nq;
          for(;c[p][x] == q;p = fa[p]) c[p][x] = nq;
        }
      }
    }
    return last;
  }
  void ins(char *s){
    int n = strlen(s),p = rt;
    for(int i = 0;i<n;i++) p = ins(p,s[i]-'0');
  }
  void calmax(int n,char *s,int *res){
    int now = rt,cur = 0;
    for(int i = 0;i<n;i++){
      int x = s[i] - '0';
      if(c[now][x]){
        cur++,now = c[now][x];
      }
      else{
        while(now && !c[now][x]) now = fa[now];
        if(now == 0) now = rt,cur = 0;
        else cur = l[now] + 1,now = c[now][x];
      }
      res[i+1] = cur;
    }
  }
}

int n,m;
char s[MAXN];
int maxlen[MAXN];
int dp[MAXN];
int q[MAXN],fi,la;

bool check(int n,int L){// 长度为 L 的情况下是否可以实现
  fi = 0,la = -1;
  for(int i = 0;i < L;i++) dp[i] = 0;
  for(int i = L;i <= n;i++){
    // printf("%d:%d\n",i,maxlen[i]);
    dp[i] = dp[i-1];
    while(fi <= la && dp[q[la]] + (i-q[la]) <= dp[i-L] + (i-(i-L))) la--;
    q[++la] = i-L;
    while(fi <= la && q[fi] < i - maxlen[i]) fi++;
    if(fi <= la)
      dp[i] = max(dp[i],dp[q[fi]] + (i-q[fi]));
  }
  // printf("%d\n",dp[n]);
  return dp[n] * 10 >= n * 9;
}


int cal(char *s){
  int n = strlen(s);
  SAM::calmax(n,s,maxlen);
  int L = 1,R = 1000000;
  while(L != R){
    int mid = (L+R+1)/2;
    if(!check(n,mid)){
      R = mid-1;
    }
    else{
      L = mid;
    }
  }
  return L;
}


void init(){
  scanf("%d %d",&n,&m); 
  SAM::init();
  for(int i = 1;i <= m;i++){
    scanf("%s",s);
    SAM::ins(s);
  }
}

void solve(){
  for(int i = 1;i<=n;i++){
    scanf("%s",s);
    printf("%d\n",cal(s));
  }
}

int main(){
  init();
  solve();
  return 0;
}
```

