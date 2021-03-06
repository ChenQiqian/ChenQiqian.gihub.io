---
title: 「SCOI2015」情报传递-树链剖分-主席树
urlname: SCOI2015-intelligence
date: 2018-10-02 09:33:57
tags:
- 数据结构
- 树链剖分
- 主席树
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

给定一个 $n$ 个节点的有根树，开始时每个节点的权值都为 $0$ 。一共有 $q$ 个时刻，每个时刻可能有如下两个操作之一：

1. 给定一个节点 $x$ ，从下一个时刻起每个时刻都给该节点的权值 $+1$（每个节点只会有一次该操作）；

2. 给定两个节点 $x,y$ 以及一个数 $C$ ，求这两个节点的简单路径上权值大于 $C$ 的节点个数，以及简单路径上的所有节点个数。

<!--more-->

## 链接

[Luogu P4216](https://www.luogu.org/problemnew/show/P4216)

## 题解

设目前时刻 $t$，那么第二个操作事实上可以转化成进行一操作时间在 $t-C$ 之前的节点个数，那么我们可以离线操作，建一棵以树链剖分 $\text{dfs}$  序为序列下标的主席树，在结合树链剖分，我们可以在 $O(log^2 n)$ 的时间内回答询问。

## 代码

```cpp
#include <cstdio>
#include <vector>
#include <algorithm>
using namespace std;

const int MAXN = 200100,logn = 17;

int n,q;
vector<int> edge[MAXN];
int rt,fa[MAXN];
int dep[MAXN],siz[MAXN],son[MAXN];
int top[MAXN],id[MAXN],last[MAXN],cnt;
int ti[MAXN];

struct Query{
    int t,x,y,c;
}Q[MAXN*2];int qcnt;

void init(){
    scanf("%d",&n);
    int p;
    for(int i = 1;i<=n;i++){
        scanf("%d",&p);
        if(p != 0){
            edge[p].push_back(i);
            fa[i] = p;
        }
        else{
            rt = i;
        }
    }
    scanf("%d",&q);
    for(int i = 1;i<=q;i++){
        int op,x,y,c;
        scanf("%d",&op);
        if(op == 1){
            scanf("%d %d %d",&x,&y,&c);
            Q[++qcnt] = (Query){i,x,y,c};
        }
        else{
            scanf("%d",&x);
            ti[x] = i;
        }
    }
}

void dfs1(int nown,int depth){
    siz[nown] = 1,dep[nown] = depth;
    for(unsigned i = 0;i<edge[nown].size();i++){
        int v = edge[nown][i];
        dfs1(v,depth+1);
        siz[nown] += siz[v]; 
        if(siz[v] > siz[son[nown]])
            son[nown] = v;
    }
}

void dfs2(int nown,int topf){
    top[nown] = topf;id[nown] = ++cnt;
    last[cnt] = nown;
    if(!son[nown]) return;
    dfs2(son[nown],topf);
    for(unsigned i = 0;i<edge[nown].size();i++){
        int v = edge[nown][i];
        if(v == son[nown]) continue;
        dfs2(v,v);
    }
}

namespace prSegTree{
    int ls[MAXN*logn],rs[MAXN*logn],sumn[MAXN*logn],cnt;
    #define mid ((l+r)>>1)
    void insert(int &nown,int pre,int l,int r,int pos,int val){
        nown = ++cnt;ls[nown] = ls[pre],rs[nown] = rs[pre],sumn[nown] = sumn[pre];
        if(l == r){
            sumn[nown] += val;
        }
        else{
            if(pos <= mid)
                insert(ls[nown],ls[pre],l,mid,pos,val);
            if(pos >= mid+1)
                insert(rs[nown],rs[pre],mid+1,r,pos,val);
            sumn[nown] = sumn[ls[nown]] + sumn[rs[nown]];
        }
    }
    int query(int nown,int l,int r,int ql,int qr){
    	if(ql > qr) return 0;
        if(ql <= l && r <= qr){
            return sumn[nown];
        }
        else{
            int ans = 0;
            if(ql <= mid){
                ans += query(ls[nown],l,mid,ql,qr);
            }
            if(qr >= mid+1){
                ans += query(rs[nown],mid+1,r,ql,qr);
            }
            return ans;
        }
    }
}

int root[MAXN];

int query_tree(int l,int r,int c){
    return prSegTree::query(root[r],1,q+1,1,c) - prSegTree::query(root[l-1],1,q+1,1,c);
}

void build(){
    dfs1(rt,1);
    dfs2(rt,rt);

    for(int i = 1;i<=n;i++){
    	if(ti[last[i]])
        	prSegTree::insert(root[i],root[i-1],1,q+1,ti[last[i]]+1,1);
        else
        	root[i] = root[i-1];
    }
}

void query(int x,int y,int c,int &tot,int &ans){
    ans = 0;tot = 0;
    while(top[x] != top[y]){
        if(dep[top[x]] < dep[top[y]]) swap(x,y);
        tot += dep[x] - dep[top[x]] + 1;
        ans += query_tree(id[top[x]],id[x],c);
        x = fa[top[x]]; 
    }
    if(dep[x] > dep[y]) swap(x,y);
    tot += dep[y] - dep[x] + 1;
    ans += query_tree(id[x],id[y],c);
}

void solve(){
    int ans = 0,tot = 0;
    for(int i = 1;i<=qcnt;i++){
        Query & qq = Q[i];
        query(qq.x,qq.y,qq.t-qq.c,tot,ans);
        printf("%d %d\n",tot,ans);
    }
}

int main(){
    init();
    build();
    solve();
    return 0;
}
```

