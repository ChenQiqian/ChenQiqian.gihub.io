---
title: 左偏树学习笔记
urlname: leftist-tree-notes
date: 2018-07-21 20:39:31
tags:
- 左偏树
- 数据结构
- 模板
categories: 
- OI
- 学习笔记
series:
libraries:
- mathjax 
##-- toc setting --##
hideToc: false
enableToc: true
enableTocContent: false
---

左偏树是一种以二叉树为基础的数据结构，可以用来实现可以在$O(\log n)$时间内合并的堆。

<!--more-->

## 定义

左偏树是一颗二叉树, 每个节点具有四个属性: 左儿子 ($lc$), 右儿子($rc$), 键值 ($key$), 距离 ($dis$)。

左偏树要求满足左右儿子的键值不小于该节点的键值 (小根堆时)。 节点 $i$ 的距离指的是从节点 $i$ 往下走, 最短的能走到外节点的路径长度。

这里的外节点指的是两个儿子不是均存在的节点。

## 性质

### 性质1

可以发现一个节点 $i$ 的距离等于以节点 $i$ 为根的子树的最右路径的
长度。

证明：递归证明即可。

### 性质2

如果一颗左偏树有 $n$ 个节点, 则该左偏树的距离不会超过
$⌊log(n + 1)⌋ − 1$。

证明：因为上面的$dis$层都需要填满，所以距离必须要小于$\log n$。

## 实现

### 合并

这个操作是左偏树的核心。


我们用$u$和$v$代表我们需要合并的两颗左偏树的根节点。

令$u.key < v.key$，那么我们先合并$u.rc$和$v$，将其作为$u$的右节点，然后检查$u.lc.dis$和$u.rc.dis$的大小关系并检查是否满足左偏树性质，然后再更新根结点的$u.dis = u.rc.dis + 1$。

复杂度的话，每次合并的时候至少有一棵子树的$dis$消减$1$，总共的$dis$是在$\log n$级别的，所以复杂度也就是$O(\log n)$。

### 插入

合并一个节点和一颗左偏树即可。

### 最值

直接取根节点的值即可。

### 删除最值

合并根节点的左右子树即可。

## 复杂度

一些复杂度：

+ 建堆：$O(n)$
+ 插入一个节点：$O(\log n)$
+ 查询最值：$O(1)$
+ 删除最值：$O(\log n)$
+ 删除任意节点：最坏$O(n)$，一般$O(\log n)$(存疑)
+ 合并两个堆：$O(\log n)$

一些事情：

左偏树的深度是可以到$O(n)$的，所以我们查询一个点所属的堆应该要再用一个并查集维护每个节点对应的最值点（根节点），复杂度才是正确的。**（下面的还没有改）**

## 代码

以[Luogu P3377【模板】左偏树（可并堆）](https://www.luogu.org/problemnew/show/P3377)为例。


```cpp
// luogu-judger-enable-o2
#include <cstdio>
#include <algorithm>
#include <cctype>
using namespace std;

namespace fast_io {
	// ...
}using namespace fast_io;

const int MAXN = 500000;

namespace Merge_Heap{
int v[MAXN],l[MAXN],r[MAXN],d[MAXN],f[MAXN];
bool vis[MAXN];
int __merge(int x,int y){
    if(x == y) return x;
    if(!x || !y) return x+y;
    if(v[x] > v[y] || (v[x] == v[y] && x > y))
        swap(x,y);
    r[x] = __merge(r[x],y);
    f[r[x]] = x;// 维护父亲
    if(d[l[x]] < d[r[x]])
        swap(l[x],r[x]);
    d[x] = d[r[x]] + 1;
    return x;
}
int __pop(int x){
    f[l[x]] = f[r[x]] = 0;
    int t =  __merge(l[x],r[x]);
    l[x] = r[x] = 0;
    return t;
}
int __find(int x){
    while(f[x]) x = f[x];
    return x;
}
void init(int n,int *num){
    for(int i = 1;i<=n;i++)
        v[i] = num[i];
}
void merge(int x,int y){
    if(vis[x]||vis[y]) return;
    __merge(__find(x),__find(y));
}
int pop(int x){
    if(vis[x]) return -1;
    int w = __find(x);
    vis[w] = 1;
    __pop(w);
    return v[w];
}
}

int n,m,num[MAXN];

void init(){
    read(n),read(m);
    for(int i = 1;i<=n;i++)
        read(num[i]);
    Merge_Heap::init(n,num);
}

void solve(){
    int op,x,y;
    for(int i = 1;i<=m;i++){
        read(op),read(x);
        if(op == 1)
            read(y),Merge_Heap::merge(x,y);
        else if(op == 2)
            print(Merge_Heap::pop(x)),print('\n');
    }
}

int main(){
    init();
    solve();
    flush();
    return 0;
}
```


## 应用

主要就是可并堆嘛。

[「JLOI2015」城池攻占-左偏树]({{< ref "posts/JLOI2015-fail/index.md" >}})
 

[「APIO2012」派遣-左偏树]({{< ref "posts/APIO2012-dispatching/index.md" >}})