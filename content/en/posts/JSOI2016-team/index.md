---
title: 「JSOI2016」最佳团体-树上背包+0/1分数规划
urlname: JSOI2016-team
date: 2018-06-18 09:34:03
tags:
- 0/1分数规划
- 树形结构
- 树形dp
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
`JSOI` 信息学代表队一共有 $N$ 名候选人，这些候选人从 $1$ 到 $N$ 编号。方便起见，`JYY` 的编号是 $0$ 号。每个候选人都由一位编号比他小的候选人$R_i$推荐。如果 $R_i = 0$ ，则说明这个候选人是 `JYY` 自己看上的。

为了保证团队的和谐，`JYY` 需要保证，如果招募了候选人 $i$，那么候选人 $R_i$ 也一定需要在团队中。当然了，`JYY` 自己总是在团队里的。每一个候选人都有一个战斗值 $P_i$ ，也有一个招募费用 $S_i$。`JYY` 希望招募 $K$ 个候选人（`JYY` 自己不算），组成一个性价比最高的团队。也就是，这 $K$ 个被 `JYY` 选择的候选人的总战斗值与总招募费用的比值最大。

<!--more-->

## 链接

[Luogu P4322](https://www.luogu.org/problemnew/show/P4322)

## 代码

这题看着很高端...事实上就是一个0/1分数规划+树形dp...

0/1分数规划的过程，就是二分选择一个答案 $ans$ ，然后去验证能不能取到若干个 $P_i - ans \times S_i$ 大于0。

能不能取到这个大于 $0$ 的东西，用 $O(n^2)$ 的树形dp验证一下就好了。

我这个代码好像有点锅，不开O2就RE...懒得找了...就这样吧...

这里的初始化也要注意一下，还有就是循环的边界，因为这里父节点必须取，第一层循环就不能到 $0$ ...

## 代码


```cpp
#include <cstdio>
#include <vector>
#include <cstring>
using namespace std;


const int MAXN = 3000;
const double eps = 1e-4;
int n,m;
double s[MAXN],p[MAXN];
int siz[MAXN];
double dp[MAXN][MAXN];
vector<int> edge[MAXN];

double k;

double tmp[MAXN];

void dfs(int x){
    for(int j = 0;j < MAXN;j++)
        dp[x][j] = -1e9;
    siz[x] = 1;dp[x][0] = 0;dp[x][1] = p[x] - k*s[x];
    for(int i = 0;i<edge[x].size();i++){
        int v = edge[x][i];
        dfs(v);
        for(int j = 0;j<=siz[x] + siz[v];j++)
            tmp[j] = -1e9;
        for(int j = 0;j<=siz[x];j++)
            tmp[j] = dp[x][j];
        for(int j = siz[x];j >= 1;--j)
            for(int w = siz[v];w >= 0;--w)
                if(j+w <= m)
                    tmp[j+w] = max(tmp[j+w],dp[x][j] + dp[v][w]);
        memcpy(dp[x],tmp,sizeof(double)*(siz[x] + siz[v]+1));
        siz[x] += siz[v];
    }
}

bool check(double num){
    k = num;
    dfs(0);
    return dp[0][m] > -eps;
}

int main(){
    scanf("%d %d",&m,&n);m++;
    int f;
    for(int i = 1;i<=n;i++){
        scanf("%lf %lf %d",&s[i],&p[i],&f);
        edge[f].push_back(i);
    }
    double l = 0,r = 10000;
    while(r - l > eps){
        double mid = (l+r)/2;
        if(check(mid))
            l = mid;
        else
            r = mid;
    }
    printf("%.3lf\n",l);
    return 0;
}
```

