---
title: 「ZJOI2007」仓库建设-斜率优化
urlname: ZJOI2007-warehouse
date: 2018-10-18 19:49:43
tags:
- 动态规划
- 斜率优化
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

L 公司有 $N$ 个工厂，由高到底分布在一座山上。工厂 $1$ 在山顶，工厂 $N$ 在山脚。 

由于地形的不同，在不同工厂建立仓库的费用可能是不同的。第 $i$  个工厂目前已有成品 $P_i$ 件，在第 $i$ 个工厂位置建立仓库的费用是 $C_i$ 。

对于没有建立仓库的工厂，其产品应被运往其他的仓库进行储藏，而由于 L 公司产品的对外销售处设置在山脚的工厂 $N$ ，故产品只能往山下运（即只能运往编号更大的工厂的仓库），当然运送产品也是需要费用的，假设一件产品运送 $1$ 个单位距离的费用是 $1$ 。

假设建立的仓库容量都都是足够大的，可以容下所有的产品。你将得到以下数据：

-   工厂 $i$ 距离工厂 $1$ 的距离 $X_i$（其中 $X_1=0$ ）;
-   工厂 $i$ 目前已有成品数量 $P_i$ ;
-   在工厂 $i$ 建立仓库的费用 $C_i$ ;

请你帮助 L 公司寻找一个仓库建设的方案，使得总的费用（建造费用+运输费用）最小。

<!--more-->

## 链接

[Luogu P2120](https://www.luogu.org/problemnew/show/P2120)

## 题解

暴力搞搞式子：

$$
dp[i] = \min _ {j=0}^{i-1}(dp[j] + c_i +\sum _ {w=j+1}^{i} (x_i - x_w)\times p_w)\\
dp[i] = \min _ {j=0}^{i-1}(dp[j] + c_i +\sum _ {w=j+1}^{i} (x_i \times p_w - x_w \times p_w) )\\
dp[i] = \min _ {j=0}^{i-1}(dp[j]  +x_i \sum _ {w=j+1}^{i}p_w - \sum _ {w=j+1}^{i} x_w \times p_w) ) + c_i $$

令 $a_i = \sum _ {w=1}^{i} p_w$ ， $b_i = \sum _ {w=1}^{i} x_w \times p_w$，原式化为

$$
dp[i] = \min _ {j=0}^{i-1}(dp[j]  +x_i \times(a_i-a_j) - (b_i-b_j) ) + c_i 
$$

如果令 $j < k < i$ ，则 $k$ 比 $j$ 优等价于：

$$
dp[j]  +x_i \times(a_i-a_j) - (b_i-b_j) \geq dp[k]  +x_i \times(a_i-a_k) - (b_i-b_k)\\
dp[j] - x_i \times a_j  + b_j \geq dp[k]  -x_i \times a_k + b_k\\
(dp[j]+b_j) - (dp[k] + b_k) \geq x_i(a_j-a_k)
$$

因为 $a_j < a_k$ ，即 $a_j - a_k < 0$ ，所以有

$$
\frac{(dp[j]+b_j) - (dp[k] + b_k)}{a_j-a_k} \leq x_i
$$

注意到 $x_i$ 单调递增，即如果在某个时刻 $k$ 比 $j$ 优，则以后其会一直更优，单调队列维护即可。

## 代码


```cpp

```


