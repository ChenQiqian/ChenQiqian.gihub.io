---
title: 「NOI2015」软件包管理器-树链剖分
urlname: NOI2015-manager
date: 2018-04-09 21:07:03
tags:
- 数据结构
- 树链剖分
- 线段树
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



你决定设计你自己的软件包管理器。如果软件包 A 依赖软件包 B ，那么安装软件包 A 以前，必须先安装软件包 B 。同时，如果想要卸载软件包 B ，则必须卸载软件包 A 。现在你已经获得了所有的软件包之间的依赖关系。除 $0$ 号软件包以外，所有软件包都会依赖一个且仅一个软件包，而 $0$ 号软件包不依赖任何一个软件包。依赖关系不存在环。

现在有一些安装或卸载软件包的操作，需要求出这个操作实际上会改变多少个软件包的安装状态（即安装操作会安装多少个未安装的软件包，或卸载操作会卸载多少个已安装的软件包）。

<!--more-->

## 链接

[Luogu P2146](https://www.luogu.org/problemnew/show/P2146)


## 题解

可以说应该还是一道比较裸的树链剖分了。

先树链剖分，然后根据编号构建一颗线段树。线段树每个节点维护当前区间已经安装的软件包的个数。需要一个 `lazy` 标记，为 $1$ 意味着这个区间被全部卸载，为 $2$ 意味着这个区间被全部安装。

对于 `install` 操作，明显可以看出我们的需求包是从 $0$ 号节点到 $x$ 号节点的链上的所有节点，所以我们先求出在这条路径上的安装的软件包的个数，然后再求出这个路径的节点个数，并对整个路径进行修改，最后相减得到答案。

对于 `uninstall` 操作，很明显可以看出只要把以 $x$ 为根节点的子树的节点全都给卸载就可以了。
所有我们求出在这个子树中的安装个数（注意到一颗子树的 $id$ 应当是连续的），这个就是查询的答案，然后我们将这个子树给卸载掉就可以了。

复杂度大约是 $O(n \; log^2{n})$ 或者稍小一些吧。

## 代码



```cpp
#include <cstdio>
#include <cstring>
#include <cctype>
#include <vector>
#include <algorithm>
using namespace std;

namespace fast_io {
    ...
}using namespace fast_io;

struct seg_tree{
    #define lson (nown<<1)
    #define rson ((nown<<1)|1)
    #define mid ((l+r)>>1)
    static const int MAXN = 110000;
    int sumn[MAXN<<2],lazy[MAXN<<2];
    seg_tree(){
        memset(sumn,0,sizeof(sumn));
        memset(lazy,0,sizeof(lazy));
    }
    //添加标记
    inline void add_tag(int nown,int l,int r,int t){
        if(t == 1)
            sumn[nown] = 0,lazy[nown] = 1;
        if(t == 2)
            sumn[nown] = r-l+1,lazy[nown] = 2;
    }
    //下传区间标记
    inline void push_down(int nown,int l,int r){
        if(l == r) return;
        if(lazy[nown]){
            add_tag(lson,l,mid,lazy[nown]);
            add_tag(rson,mid+1,r,lazy[nown]);
            lazy[nown] = 0;
        }
    }
    //维护区间和
    inline void maintain(int nown){
        sumn[nown] = sumn[lson] + sumn[rson];
    }
    //区间更新为安装（tag == 2）或未安装（tag == 2）
    inline void update(int nown,int l,int r,int ql,int qr,int tag){
        if(ql <= l && r<=qr)
            add_tag(nown,l,r,tag);
        else{
            push_down(nown,l,r);
            if(ql <= mid)
                update(lson,l,mid,ql,qr,tag);
            if(qr >= mid+1)
                update(rson,mid+1,r,ql,qr,tag);
            maintain(nown);
        }
    }
    //区间查询安装的个数
    inline int query(int nown,int l,int r,int ql,int qr){
        if(ql <= l && r <= qr)
            return sumn[nown];
        else{
            push_down(nown,l,r);
            int ans = 0;
            if(ql<=mid)
                ans+=query(lson,l,mid,ql,qr);
            if(qr >= mid+1)
                ans+=query(rson,mid+1,r,ql,qr);
            return ans;
        }
    }
}tree;
//线段树

const int MAXN = 110000;
int n,m;
int cnt = 0;
int dep[MAXN],id[MAXN],son[MAXN],fa[MAXN],top[MAXN],siz[MAXN];

vector<int> edge[MAXN];

//树链剖分
void dfs1(int nown,int f,int depth){
    siz[nown] = 1,fa[nown] = f;
    dep[nown] = depth;
    int maxsum = -1;
    for(int i = 0;i<edge[nown].size();i++){
        int to = edge[nown][i];
        if(to == fa[nown]) continue;
        dfs1(to,nown,depth+1);
        siz[nown]+=siz[to];
        if(siz[to] > maxsum)
            son[nown] = to,maxsum = siz[to];
    }
}

void dfs2(int nown,int topf){
    id[nown] = ++cnt,top[nown] = topf;
    if(!son[nown]) return;
    dfs2(son[nown],topf);
    for(int i = 0;i<edge[nown].size();i++){
        int to = edge[nown][i];
        if(to == fa[nown] || to == son[nown]) continue;
        dfs2(to,to);
    }
}

//查询x到y的路径上的安装的个数
inline int query(int x,int y){
    int ans = 0;
    while(top[x]!=top[y]){
        if(dep[top[x]] < dep[top[y]]) swap(x,y);
        ans+=tree.query(1,1,n,id[top[x]],id[x]);
        x = fa[top[x]];
    }
    if(dep[x] > dep[y]) swap(x,y);
    ans+=tree.query(1,1,n,id[x],id[y]);
    return ans;
}

//将x到y路径上的点标记为安装或者卸载
inline int update(int x,int y,int t){
    int ans = 0;
    while(top[x]!=top[y]){
        if(dep[top[x]] < dep[top[y]]) swap(x,y);
        ans+=id[x]-id[top[x]]+1;
        tree.update(1,1,n,id[top[x]],id[x],t);
        x = fa[top[x]];
    }
    if(dep[x] > dep[y]) swap(x,y);
    ans+=id[y]-id[x]+1;tree.update(1,1,n,id[x],id[y],t);
    return ans;
}
//安装
inline int install(int x){
    int b = query(1,x);
    int e = update(1,x,2);
    return e-b;
}
//卸载
inline int uninstall(int x){
    int b = tree.query(1,1,n,id[x],id[x]+siz[x]-1);
    tree.update(1,1,n,id[x],id[x]+siz[x]-1,1);
    return b;
}

inline void init(){
    read(n);
    int tmp;
    for(int i = 2;i<=n;i++){
        read(tmp);
        edge[i].push_back(tmp+1);
        edge[tmp+1].push_back(i);
    }
    dfs1(1,0,1);
    dfs2(1,1);
}

inline void solve(){
    read(m);
    char op[20];int x;
    for(int i = 1;i<=m;i++){
        read(op),read(x);
        if(op[0] == 'u')
            print(uninstall(x+1)),print('\n');
        else if(op[0] == 'i')
            print(install(x+1)),print('\n');
    }
}

int main(){
    init();
    solve();
    flush();
    return 0;
}
```


