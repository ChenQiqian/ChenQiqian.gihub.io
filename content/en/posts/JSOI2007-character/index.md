---
title: 「JSOI2007」字符加密-后缀数组
urlname: JSOI2007-character
date: 2018-09-11 21:13:17
tags:
- 字符串
- 后缀数组
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

喜欢钻研问题的 $JS$ 同学，最近又迷上了对加密方法的思考。一天，他突然想出了一种他认为是终极的加密办法：把需要加密的信息排成一圈，显然，它们有很多种不同的读法。

例如 `JSOI07` ，可以读作： `JSOI07` `SOI07J` `OI07JS` `I07JSO` `07JSOI` `7JSOI0` ，把它们按照字符串的大小排序：

+ `07JSOI` 
+ `7JSOI0` 
+ `I07JSO` 
+ `JSOI07` 
+ `OI07JS` 
+ `SOI07J` 

读出最后一列字符：`I0O7SJ`，就是加密后的字符串。 但是，如果想加密的字符串实在太长，你能写一个程序完成这个任务吗？

<!--more-->

## 链接

[Luogu P4051](https://www.luogu.org/problemnew/show/P4051)

## 题解

复制字符串，然后跑 $SA$ ，得到 $sa$ 数组，然后在上面顺序扫描，扫描到最前面 $n$ 个在 $1$ 到 $n$ 之间开始的后缀，然后获取其第 $n$ 个字符即可。

## 代码


```cpp
#include <cstdio>
#include <cstring>
using namespace std;

const int MAXN = 210000;

namespace SA{
  int s[MAXN],sa[MAXN],rk[MAXN],x[MAXN],y[MAXN],cnt[MAXN];
  void get_sa(int n,int m){
    for(int i = 0;i<m;i++) cnt[i] = 0;
    for(int i = 0;i<n;i++) cnt[s[i]] ++;
    for(int i = 1;i<m;i++) cnt[i] += cnt[i-1];
    for(int i = n-1;~i;--i) sa[--cnt[s[i]]] = i;
    m = rk[sa[0]] = 0;
    
    for(int i = 1;i<n;i++) rk[sa[i]] = s[sa[i]] == s[sa[i-1]] ? m : ++m;
    for(int j = 1;;j<<=1){
      if(++m == n) return;
      //printf("!!!\n");
      for(int i = 0;i<j;i++) y[i] = n-j+i;
      for(int i = 0,k=j;i<n;i++) if(sa[i] >= j) y[k++] = sa[i] - j;
      for(int i = 0;i<n;i++) x[i] = rk[y[i]];
      for(int i = 0;i<m;i++) cnt[i] = 0;
      for(int i = 0;i<n;i++) cnt[x[i]]++;
      for(int i = 1;i<m;i++) cnt[i] += cnt[i-1];
      for(int i = n-1;~i;--i) sa[--cnt[x[i]]] = y[i],y[i] = rk[i];
      m = rk[sa[0]] = 0;
      for(int i = 1;i<n;i++) rk[sa[i]] = (y[sa[i]]==y[sa[i-1]]&&y[sa[i]+j]==y[sa[i-1]+j])?m:++m;
    }
  }
  void solve(char *str,int n){
    for(int i = 0;i<n;i++){
      s[i] = str[i];
    }
    s[n] = 0;
    get_sa(++n,127);
  }
  void get_ans(char *ans,int n){
    int cnt = 0;
    for(int i = 1;i<=2*n;i++){
      int t = sa[i];
      if(t < n){
        ans[cnt++] = s[t+n-1];
      }
    }
  }
}

int n;
char s[MAXN];
char ans[MAXN];

void init(){
  scanf("%s",s);
  n = strlen(s);
}

void solve(){
  for(int i = 0;i<n;i++)
    s[n+i] = s[i];
  SA::solve(s,2*n);
  SA::get_ans(ans,n);
  printf("%s\n",ans);
}

int main(){
  init();
  solve();
  return 0;
}
```

