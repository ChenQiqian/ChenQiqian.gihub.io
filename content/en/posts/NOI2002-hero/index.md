---
title: 「NOI2002」银河英雄传说-并查集
urlname: NOI2002-hero
date: 2018-02-11 16:27:45
tags:
- 数据结构
- 并查集
categories: 
- OI
- 题解
series:
- NOI
libraries:
- mathjax 
##-- toc setting --##
hideToc: false
enableToc: true
enableTocContent: false
---

初始时，第 $i$ 号战舰处于第 $i$ 列 $(i = 1, 2, …, 30000)$ 。

有两种指令：

合并指令为 `M i j` ，含义为将第 $i$ 号战舰所在的整个战舰队列，作为一个整体（头在前尾在后）接至第 $j$ 号战舰所在的战舰队列的尾部。

询问指令为 `C i j` 。该指令意思询问第 $i$ 号战舰与第 $j$ 号战舰当前是否在同一列中，如果在同一列中，那么它们之间布置有多少战舰。

<!--more-->

## 链接

[Luogu P1196](https://www.luogu.org/problemnew/show/P1196)

## 题解

一道并查集的题目。

因为快速的寻找两个战舰是否在同一列里面，我们可以使用并查集数据结构。但注意到题目还要询问两个战舰之间的距离，我们需要额外维护一些信息，所以我们需要用加权的并查集。

说的加权，事实上就是在每一个节点上额外维护一些信息。在这里，我们在节点上额外维护到父节点的距离，在根节点处维护这个集合的大小。

在寻找某个节点的时候，我们仍然可以进行路径压缩。只需要先对父节点递归完成后，把权值加上父节点的权值，然后就可以直接连到根上。

合并操作也差不多。为了使合并操作简单，我们需要保证父节点一定在子节点前面。这样，我们找到的根节点就是每个队列的最前方的节点。然后可以将后面接上的节点的父亲指向前面的节点，距离设为前面的集合的大小，就可以维护了。

查询距离的时候，只需要把两个节点到根的距离算出来，作差取绝对值，然后再减去1即可。

## 代码



```cpp
#include <cstdio>
#include <algorithm>
#define MAXN 30010
using namespace std;

int f[MAXN],d[MAXN],s[MAXN],t;
// f 维护父亲节点，d 维护于父亲节点的距离，s 在根节点处维护集合的元素数

int find(int x){
    if(f[x] == x){
        return x;
    }
    else{
        int w = find(f[x]);
        d[x] += d[f[x]];
        f[x] = w;
        return w;
    }
}

void un(int x,int y){
    int b = find(y),e = find(x);
    if(b == e){
        return;
    }
    else{
        d[e] = s[b],d[b] = 0;
        s[b] = s[b] + s[e],s[e] = 0;
        f[e] = b;
        return;
    }
}

int main(){
    scanf("%d",&t);
    for(int i = 1;i<MAXN;i++){
        f[i] = i,d[i] = 0,s[i] = 1;
    }
    for(int i = 1;i<=t;i++){
        char op[20];int a,b;
        scanf("%s",op);
        scanf("%d %d",&a,&b);
        if(op[0] == 'M'){
            un(a,b);
        }
        else{
            int a1 = find(a),b1 = find(b);
            if(a1!=b1){
                printf("-1\n");
            }
            else{
                printf("%d\n",abs(d[a]-d[b])-1);
            }
        }
    }
    return 0;
}

```