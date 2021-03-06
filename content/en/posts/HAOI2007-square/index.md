---
title: 「HAOI2007」理想的正方形-单调队列
urlname: HAOI2007-square
date: 2018-05-18 18:52:06
tags:
- 单调队列
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

有一个 $a \times b$ 的整数组成的矩阵，现请你从中找出一个 $n\times n$ 的正方形区域，使得该区域所有数中的最大值和最小值的差最小，输出这个最小的差值。

<!--more-->

## 链接

[Luogu P2216](https://www.luogu.org/problemnew/show/P2216)

## 题解

单调队列的一道有趣的题。

事实上我们可以发现，需要找出的区域是正方形，而且大小固定，所以我们可以想到用单调队列来解决这个问题。

但这个问题是二维的，怎么把单调队列转化成二维的呢？

可以这么考虑。用 $a$ 个单调队列维护 **每一行**在 $[j-n+1,j]$ 的位置中的最大值和最小值。

每次我们计算正方形的最大值或最小值的时候，对于这 $a$ 个单调队列中的最大值或者最小值，我们新开一个单调队列，其中维护在 $a$ 个单调队列中 $[i-n+1,i]$ 这个范围里的最大值或者最小值。然后就可以用最大值减去最小值，并尝试更新答案。

可以证明，复杂度是 $O(n^2)$ 的。

实在偷懒，单调队列用了 $deque$ ，不开`O2`极慢。

## 代码


```cpp
#include <cstdio>
#include <queue>
#include <cctype>
#include <algorithm>
#define pp pair<int,int>
using namespace std;

const int MAXN = 1100;

namespace fast_io {
    //...
}using namespace fast_io;

int n,m,k;
int num[MAXN][MAXN];

deque<pp> max1[MAXN],min1[MAXN];
deque<pp> max2,min2;

void init(){
    read(n),read(m),read(k);
    for(int i = 1;i<=n;i++)
        for(int j = 1;j<=m;j++)
            read(num[i][j]);
}


void solve(){
    int ans = 0x3f3f3f3f;
    static int minn[MAXN],maxn[MAXN];
    int tmin,tmax;
    for(int i = 1;i<=n;i++){
        //printf("i %d:\n",i);
        for(int j = 1;j<=m;j++){
            //max
            while(!max1[j].empty()&&max1[j].begin()->second < num[i][j])
                max1[j].pop_front();
            max1[j].emplace_front(i,num[i][j]);
            while(!max1[j].empty()&&max1[j].rbegin()->first <= i-k)
                max1[j].pop_back();
            tmax = max1[j].rbegin()->second;
            maxn[j] = tmax;
            //min
            while(!min1[j].empty()&&min1[j].begin()->second > num[i][j])
                min1[j].pop_front();
            min1[j].emplace_front(i,num[i][j]);
            while(!min1[j].empty()&&min1[j].rbegin()->first <= i-k)
                min1[j].pop_back();
            tmin = min1[j].rbegin()->second;
            minn[j] = tmin;
        }
        max2.clear(),min2.clear();
        for(int j = 1;j<=m;j++){
            //max
            while(!max2.empty()&&max2.begin()->second < maxn[j])
                max2.pop_front();
            max2.emplace_front(j,maxn[j]);
            while(!max2.empty()&&max2.rbegin()->first <= j-k)
                max2.pop_back();
            tmax = max2.rbegin()->second;
            //min
            while(!min2.empty()&&min2.begin()->second > minn[j])
                min2.pop_front();
            min2.emplace_front(j,minn[j]);
            while(!min2.empty()&&min2.rbegin()->first <= j-k)
                min2.pop_back();
            tmin = min2.rbegin()->second;
            if(i>=k && j>=k)//保证解合法
                ans = min(tmax-tmin,ans);
        }
    }
    printf("%d\n",ans);
}

int main(){
    init();
    solve();
    return 0;
}
```

