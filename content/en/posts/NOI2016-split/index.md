---
title: 「NOI2016」优秀的拆分-后缀数组
urlname: NOI2016-split
date: 2018-07-04 20:38:39
tags:
- 字符串
- 后缀数组
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


如果一个字符串可以被拆分为 $AABB$ 的形式，其中 $A$ 和 $B$ 是任意非空字符串，则我们称该字符串的这种拆分是优秀的。一个字符串可能没有优秀的拆分，也可能存在不止一种优秀的拆分。

现在给出一个长度为 $n$ 的字符串 $S$ ，我们需要求出，在它**所有**子串的**所有**拆分方式中，优秀拆分的总个数。这里的子串是指字符串中连续的一段。

以下事项需要注意：
+ 出现在不同位置的相同子串，我们认为是不同的子串，它们的优秀拆分均会被记入答案。
+ 在一个拆分中，允许出现 $A = B$。例如 $cccc$ 存在拆分 $A = B = c$。
+ 字符串本身也是它的一个子串。

<!--more-->

## 链接

[Luogu P1117](https://www.luogu.org/problemnew/show/P1117)
[BZOJ 4650](https://www.lydsy.com/JudgeOnline/problem.php?id=4650)

## 题解

下文字符串下标均为 $[0,n)$ 。

我们如果令 $l[i]$ 为在 $i$ 处开始的 AA 串的个数，$r[i]$ 为在 $i$ 处结束的 AA 串的个数，那么

$$
ans = \sum _ {i = 1}^{n-1} r[i-1] \times l[i]
$$

这个过程是 $O(n)$ 的，所以我们需要思考怎么求出 $l[i]$ 和 $r[i]$ 。

我们对每一个 AA 子串的循环节长度 $L$ 从 $1$ 到 $\frac{n}{2}$ 进行枚举考虑。如果在 $0,L,2L,...,nL$ 的地方设为关键点，那么 AA 的左半边的循环节因为长度为 $L$ ，一定过且仅过一个关键点，这也是我们下面考虑的基础。
- - -
我们正序、逆序建立两个后缀数组，来求得原字符串某两个后缀的LCP（最长公共前缀）或者某两个前缀的 LCS （最长公共后缀）。

如果这个 AA 子串的左半边过 $kL$ 这个关键点，那么这个时候的 AA 子串在 $kL$ 和 $(k+1)L$ 的位置必须相同，而且他们的$LCP+LCS$的长度必须能够接上这样一个 $L$ 的间隔，我们才能找到一段 $2L$ 的区间，满足 AA 串的条件。

这个时候，我们用差分的方法标记修改 $l$ 和 $r$ 即可。

注意要保证 AA 串(也就是我们枚举的串)左边的串的左端点、右端点都不触碰到其他的关键点，不然会重复计数。

具体看代码吧。`solve` 函数就是最终的这一过程。

时间复杂度 $O(n \log{n})$ 。

## 代码


```cpp
#include <bits/stdc++.h>
using namespace std;

const int MAXN = 210000;

struct SA{
int sa[MAXN],rk[MAXN],ht[MAXN],s[MAXN<<1],t[MAXN<<1];
int b[MAXN],cur[MAXN],p[MAXN];
#define pushS(x) sa[cur[s[x]]--] = x
#define pushL(x) sa[cur[s[x]]++] = x
#define inducedSort(v) \
    fill_n(b,m,0),fill_n(sa,n,-1);\
    for(int i = 0;i<n;i++) b[s[i]]++;\
    for(int j = 1;j<m;j++) b[j]+=b[j-1];\
    for(int j = 0;j<m;j++) cur[j] = b[j]-1;\
    for(int i=n1-1;~i;--i) pushS(v[i]);\
    for(int j = 1;j<m;j++) cur[j] = b[j-1];\
    for(int i = 0;i<n;i++) if(sa[i]>0 && t[sa[i]-1]) pushL(sa[i]-1);\
    for(int j = 0;j<m;j++) cur[j] = b[j]-1;\
    for(int i=n-1;~i;--i) if(sa[i]>0 && !t[sa[i]-1]) pushS(sa[i]-1);
void sais(int n,int m,int *s,int *t,int *p){
    int n1 = t[n-1] = 0,ch = rk[0] = -1,*s1 = s+n;
    for(int i = n-2;~i;--i) t[i] = (s[i]!=s[i+1])?s[i]>s[i+1]:t[i+1];
    for(int i = 1;i<n;i++) rk[i] = (!t[i]&&t[i-1])?(p[n1]=i,n1++):-1;
    inducedSort(p);
    for(int i=0,x,y;i<n;i++)if(~(x=rk[sa[i]])){
        if(ch < 1 || p[x+1]-p[x]!=p[y+1]-p[y]) ch++;
        else for(int j=p[x],k=p[y];j<=p[x+1];j++,k++)
            if((s[j]<<1|t[j])!=(s[k]<<1|t[k])){ch++;break;}
        s1[y=x]=ch;
    }
    if(ch+1 < n1) sais(n1,ch+1,s1,t+n,p+n1);
    else for(int i = 0;i<n1;i++) sa[s1[i]] = i;
    for(int i = 0;i<n1;i++) s1[i] = p[sa[i]];
    inducedSort(s1);
}
template<typename T>
int mapp(const T *str,int n){
    int m = *max_element(str,str+n);
    fill_n(rk,m+1,0);
    for(int i = 0;i<n;i++) rk[str[i]] = 1;
    for(int j = 0;j<m;j++) rk[j+1] += rk[j];
    for(int i = 0;i<n;i++) s[i] = rk[str[i]] - 1;
    return rk[m];
}
template<typename T>
void SuffixArray(const T *str,int n){
    int m = mapp(str,++n);
    sais(n,m,s,t,p);
}
void getheight(int n){
    for(int i = 0;i<=n;i++) rk[sa[i]] = i;
    for(int i = 0,h = ht[0] = 0;i<=n;i++){
        int j = sa[rk[i]-1];
        while(i+h<n&&j+h<n&&s[i+h]==s[j+h]) h++;
        if(ht[rk[i]] = h) --h;
    }
}
struct ST{
    int maxn[20][MAXN];
    void build(int *num,int n){
        for(int i = 1;i<=n;i++) maxn[0][i] = num[i];
        for(int j = 1,t=2;t<=n;j++,t<<=1)// st表取min！
            for(int i = 1;i+(t>>1)<=n;i++)
                maxn[j][i] = min(maxn[j-1][i],maxn[j-1][i+(t>>1)]);
    }
    int query(int l,int r){
        if(l > r) return -1;
        int t = log2(r-l+1);
        return min(maxn[t][l],maxn[t][r-(1<<t)+1]);// 取min！！！！
    }
}S;
int lcp(int x,int y,int n){
    x = rk[x],y = rk[y];
    if(x > y) swap(x,y);
    if(x == y) return n-x+1;
    return S.query(x+1,y);
}
template<typename T>
void solve(const T *str,int n){
    SuffixArray(str,n);
    getheight(n);
    S.build(ht,n);
}
}A,B;

int n;
char s[MAXN],tmp[MAXN];

void init(){
    scanf("%s",s);
    n = strlen(s);
    s[n] = 'a'-1;
    A.solve(s,n);
    for(int i = 0;i<n;i++) tmp[i] = s[n-i-1];
    tmp[n] = 'a'-1;
    B.solve(tmp,n);
}
// Longest Common Prefix
int lcp(int x,int y){
    return A.lcp(x,y,n);
}
// Longest Common Suffix
int lcs(int x,int y){
    return B.lcp(n-x-1,n-y-1,n);
}

long long solve(){
    static long long l[MAXN],r[MAXN];
    long long ans = 0;
    memset(l,0,sizeof(l)),memset(r,0,sizeof(r));
    for(int L = 1;L<=n/2;L++){
        for(int j = 0;j+L<n;j+=L){
            int ll = j,rr = j+L;
            if(s[ll] != s[rr]) continue;
            int x = ll-lcs(ll,rr)+1,y = ll + lcp(ll,rr) - 1;
            x = max(max(x,0),ll-L+1),y = min(ll+L-1,min(n-L-1,y));
            if(y-x+1 >= L){
                int cnt = (y-x+1)-L+1;
                l[x]++,l[x+cnt]--;
                r[x+2*L-1]++,r[x+2*L+cnt-1]--;
            }
        }
    }

    for(int i = 1;i<n;i++) l[i] += l[i-1],r[i] += r[i-1];
    for(int i = 0;i<n-1;i++) ans += r[i]*l[i+1];
    return ans;
}

int main(){
    int T;
    scanf("%d",&T);
    for(int i = 1;i<=T;i++){
        init();
        printf("%lld\n",solve());
    }
    return 0;
}
```

