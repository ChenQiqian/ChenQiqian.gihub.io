---
title: NOIp2018 游记&题解
urlname: noip2018
date: 2018-11-11 23:12:52
tags:
categories: 
- OI
- 游记
series:
libraries:
- mathjax 
##-- toc setting --##
hideToc: false
enableToc: true
enableTocContent: false
---

垃圾 CCF
毁我青春 

<!--more-->

## Day 0

讲评试卷，旷掉了。在机房刷模板题，晚上刷不动了就开始疯狂预测后两天的题目：

胡乱预测了一些非常神奇的东西：T1数论/模拟，T2/T3背包、树形dp、基环树、图论+缩点+倍增。

我是不是要被禁赛一年了啊。

## Day 1

sb Day1，不做评论。

### T1：铺设道路

#### 题面

春春是一名道路工程师，负责铺设一条长度为  $n$  的道路。

铺设道路的主要工作是填平下陷的地表。整段道路可以看作是  $n$  块首尾相连的区域，一开始，第  $i$  块区域下陷的深度为  $d_i$  。

春春每天可以选择一段连续区间 $[L,R]$ ，填充这段区间中的每块区域，让其下陷深度减少  $1$ 。在选择区间时，需要保证，区间内的每块区域在填充前下陷深度均不为  $0$ 。

春春希望你能帮他设计一种方案，可以在最短的时间内将整段道路的下陷深度都变为  $0$ 。


#### 题解

开始看题居然早了一些，被喝止关上题面的时候已经记下来这道题了，于是在开考前就脑补出了这道题的解法...开考5分钟敲完过大样例...

我们维护一个差分数组 $c[i] = d[i] - d[i-1]$ ，如果 $c[i] > 0$ 我们就将其累加到贡献中。

正确性似乎十分显然，你不可能找到一个更小的方案来覆盖了。

赛后得知该题是NOIp2013原题，似乎模拟赛里我还做过这道题（不过当时还WA了

耗时5分钟。

期望得分：100，实际得分：100

### T2：货币系统

#### 题面

在网友的国度中共有  $n$  种不同面额的货币，第  $i$  种货币的面额为  $a[i]$ ，你可以假设每一种货币都有无穷多张。为了方便，我们把货币种数为  $n$ 、面额数组为  $a[1..n]$  的货币系统记作  $(n,a)$。

在一个完善的货币系统中，每一个非负整数的金额  $x$  都应该可以被表示出，即对每一个非负整数  $x$ ，都存在  $n$ 个非负整数  $t[i]$  满足  $a[i] \times t[i]$  的和为  xx。然而， 在网友的国度中，货币系统可能是不完善的，即可能存在金额 $x$ 不能被该货币系统表示出。例如在货币系统  $n=3$,  $a=[2,5,9]$ 中，金额  $1,3$  就无法被表示出来。

两个货币系统  $(n,a)$  和  $(m,b)$  是等价的，当且仅当对于任意非负整数  $x$，它要么均可以被两个货币系统表出，要么不能被其中任何一个表出。

现在网友们打算简化一下货币系统。他们希望找到一个货币系统  $(m,b)$，满足  $(m,b)$ 与原来的货币系统  $(n,a)$ 等价，且  $m$  尽可能的小。他们希望你来协助完成这个艰巨的任务：找到最小的  $m$。

#### 题解

开始还往数论的方面考虑了一波，甚至想到刚学的线性基，事实上并没有什么卵用......本质上就是一个贪心+类似背包dp的东西吧。

首先考虑一些性质。

首先发现不可能出现在这 $n$ 个货币面额之外面额的货币，其次发现最小的货币必然要取到，然后我们考虑到，取一个更小的货币一定对于你凑出一个大的面值更有帮助，所以我们从小往大的贪心。

维护一个数组 $vis[i]$，表示 $i$ 面值能不能被之前的货币凑出来。首先判断新加入的数能不能用已经有的面额凑出，如果能就可以跳过这个面值，否则就必须加入新的最小货币系统。

我们如何更新 $vis$ 数组呢？稍有背包dp经验（或者满脑子背包的人）就会通过物品无限联想到完全背包。

扫描数组用低位更新高位即可。

时间复杂度$O(T \times n \cdot \text{MAXV})$。

此时刚刚 9:05 。

期望得分：100，实际得分：100

### T3：赛道修建

也还算一道好题吧，只不过位置非常尴尬...(来自一个几乎想对算法然后挂掉的选手的怨念)

#### 题意

C 城将要举办一系列的赛车比赛。在比赛前，需要在城内修建  $m$  条赛道。

C 城一共有  $n$  个路口，这些路口编号为  $1,2,…,n$，有  $n−1$ 条适合于修建赛道的双向通行的道路，每条道路连接着两个路口。其中，第  $i$  条道路连接的两个路口编号为  $a_i$  和  $b_i$​，该道路的长度为  $l_i$。借助这  $n-1$  条道路，从任何一个路口出发都能到达其他所有的路口。

一条赛道是一组互不相同的道路  $e_1,e_2,…,e_k$​，满足可以从某个路口出发，依次经过 道路  $e_1,e_2,…,e_k$​（每条道路经过一次，不允许调头）到达另一个路口。一条赛道的长度等于经过的各道路的长度之和。为保证安全，要求每条道路至多被一条赛道经过。

目前赛道修建的方案尚未确定。你的任务是设计一种赛道修建的方案，使得修建的  $m$ 条赛道中长度最小的赛道长度最大（即  $m$  条赛道中最短赛道的长度尽可能大）

#### 题解

考场上的做法有锅以至于大样例都过不了...然后信仰rand交上去了...发现数据随机的话很难卡掉...所以我事实上应该少rand几次...没准还能混到95...

正解的做法如下：

二分非常显然，然后就变成判断不小于 $x$ 的不相交路径有多少条。

对于每一个子树分别考虑的话，发现每个子树最多只有一条从根出发的路径能被祖先节点使用，再加上菊花图的暗示，大概能够得到以下的思路，贪心的使仅在子树里能够拼出来的路径最多的情况下，能往上传递的链的长度最大。

这个可以用一个 `pair<int,int>` 维护。我们注意到我们在考虑每个子树返回的路径时，如果 `f[v] + len >= TAR` ，那么说明这个路径可以自己成一条赛道，直接累加贡献即可；剩下的扔到一个multiset/vector里面，现在我们就有了若干条长度小于 `TAR` 的路径，我们要组合出最多的不小于 `TAR` 的路径，而且还要求出这个情况下能返回的最长的过当前子树根节点的链的长度。

我们有两种处理方法：

一种是 `multiset` 处理，我们从短往长贪心的考虑每条边，lower_bound 查出最小能不小于 `TAR` 的另一条链，然后把他们俩都删掉，计算贡献。直到找不到能匹配的边，就将 `multiset` 里面的最大值作为返回最长链的答案。（正确性不显然，但是我们机房讨论没有叉掉，所以大约是对的）。

还有一种是再二分的处理。

先考虑如何线性计算出最多的贡献，就是用双指针贪心即可，固定的是大的链。然后我们二分往回的边是哪条，显然有单调性，然后每次线性计算下是否贡献能达到最大值就可以了。

时间复杂度：$O(n \log^2 n)$。

期望得分： $55-80$，实际得分：50

### Day1总结

做完前两题恍然觉得自己变强了好多啊，轻松一天200+...结果第三题死活没调出来。回家写了写，发现考场上错误的算法（又写了一遍仍然没过大样例...）Luogu/nowcoder自测也能拿95...我为什么要rand...我是不是傻子...

Day 2之后刷知乎发现出题人 immortalCO 又说数据很弱...

暴怒...

期望得分：100+100+55~80 = 255~280，实际得分：100+100+50 = 250

## Day 2

考试前某神仙在pyq里面调侃：Day1 一时爽，Day2 火葬场。

感觉又要被禁赛一年了。

### T1：旅行

#### 题面

小 Y 是一个爱好旅行的 OIer。她来到 X 国，打算将各个城市都玩一遍。

小Y了解到， X 国的  $n$  个城市之间有  $m(m \leq n)$  条双向道路。每条双向道路连接两个城市。 不存在两条连接同一对城市的道路，也不存在一条连接一个城市和它本身的道路。并且， 从任意一个城市出发，通过这些道路都可以到达任意一个其他城市。小 Y 只能通过这些 道路从一个城市前往另一个城市。

小 Y 的旅行方案是这样的：任意选定一个城市作为起点，然后从起点开始，每次可 以选择一条与当前城市相连的道路，走向一个没有去过的城市，或者沿着第一次访问该 城市时经过的道路后退到上一个城市。当小 Y 回到起点时，她可以选择结束这次旅行或 继续旅行。需要注意的是，小 Y 要求在旅行方案中，每个城市都被访问到。

为了让自己的旅行更有意义，小 Y 决定在每到达一个新的城市（包括起点）时，将 它的编号记录下来。她知道这样会形成一个长度为  $n$  的序列。她希望这个序列的字典序 最小，你能帮帮她吗？ 对于两个长度均为 $n$ 的序列  $A$ 和  $B$，当且仅当存在一个正整数  $x$，满足以下条件时， 我们说序列  $A$  的字典序小于  $B$。

-   对于任意正整数  $1 \leq i < x$，序列  $A$  的第  $i$  个元素  $A_i$  和序列  $B$  的第  $i$  个元素  $B_i$​  相同。
-   序列  $A$  的第  $x$  个元素的值小于序列  $B$  的第  $x$  个元素的值。

#### 题解

开始没看见 $m \leq n$，恍然以为不可做...

然后又没看见 $n \leq 5000$，再次觉得不可做...

据说有线性做法...我只想到一个 $n^2$ 做法

发现小 Y 事实上就是在dfs...我们熟悉树上的那套理论，我们发现树上的这个东西是很好求的，贪心dfs即可...

带环的树也可以用类似的贪心做到 $O(n)$ 的复杂度，只不过我还不太会...

$O(n^2)$ 的话，枚举断边，dfs即可...最后判下全部到达即可。

我们还发现一点，这里需要对边排序来保证复杂度，如果我们每次都遍历在sort很有可能TLE...所以我们在外面逆序sort好后再加边即可...

然后赛后自测的是否发现自己很有可能有个地方忘开两倍数组...感觉自己要凉... -= 32 分...不过luogu自测上面都能过最后三个点，也不知道为什么...

期望分数：68-100（万一我开了2倍呢...），实际得分：100

### T2：填数游戏

#### 题面

麻烦死了，不复制了，链接：[**Luogu P5023**  填数游戏](https://www.luogu.org/problemnew/show/P5023)

#### 题解

考场上一看数据范围：高啊，一看就是状压dp+矩阵快速幂...于是推了推转移矩阵 码码码 * n...然后发现 `n=3,m=3` 都过不了...纠结一个小时也没能调完...咕咕咕...最后写了一个暴力搜索和 n = 2 的特殊情况...考后听各路神仙做法都不太一样...

目前听到的一种做法是这样的...

首先你发现一个规律...当  $m \geq n+2$ 时， $F(n,m) = 3F(n,m-1)$。

然后你暴搜出来 $F(n,n+1)$ 的答案即可。直接暴力搜索会TLE，考虑一些微小的优化，比如对角线的单调性，比如子矩阵的必然合法啥的。

 具体没写呢...最好的方法貌似是打表？等过几天再来填。

考场上大概只有50分可以拿到。其实机灵点可以发现 n = 3,m=4和n=3,m=5 的规律的，然后大概可以多拿 $15$ 分..?

[wxh的做法](https://www.zhihu.com/question/293059610/answer/529373474)

期望得分：50，实际得分：20（模数多打一个0的悲伤QAQ）

### T3：保卫王国

又tm一道树形dp...

#### 题面：

Z 国有 $n$ 座城市，$n - 1$ 条双向道路，每条双向道路连接两座城市，且任意两座城市 都能通过若干条道路相互到达。

Z 国的国防部长小 Z 要在城市中驻扎军队。驻扎军队需要满足如下几个条件：

-   一座城市可以驻扎一支军队，也可以不驻扎军队。
-   由道路直接连接的两座城市中至少要有一座城市驻扎军队。
-   在城市里驻扎军队会产生花费，在编号为i的城市中驻扎军队的花费是 $p_i$。

小 Z 很快就规划出了一种驻扎军队的方案，使总花费最小。但是国王又给小 Z 提出 了 $m$ 个要求，每个要求规定了其中两座城市是否驻扎军队。小 Z 需要针对每个要求逐一 给出回答。具体而言，如果国王提出的第 $j$个要求能够满足上述驻扎条件（不需要考虑 第  $j$ 个要求之外的其它要求），则需要给出在此要求前提下驻扎军队的最小开销。如果 国王提出的第 $j$个要求无法满足，则需要输出 $-1$ ($1 \leq j \leq  m$)。现在请你来帮助小 Z。


#### 题解

怎么说呢，感觉是道好题，就是放在NOIp的位置并不是特别合适...而且确切的说是放在这么恐怖的 `Day 2` 并不是很合适。

该题貌似目前还没有人能给我完全讲明白...机房学长讲了一遍动态dp但是我也没太搞懂只听明白链上的情况，也就是线段树维护转移矩阵（一般比较小）做到快速的修改。

好像还可以倍增做，也可以用虚树的思想。我都不会，以后慢慢补（咕咕.jpeg）。

写了个最坏 $O(n^2)$ 暴力也不知道对不对。

期望得分：44，实际得分：44

### Day2总结

完全没有区分度的一天...偏偏我还挂题了...太年轻了啊...考试结束一个小时前开始佛系检查...还没发现自己的数组开小...

实名举报T2和T3样例太小...感觉很虚啊qaq

期望得分：68~100 + 50 + 44 = 162~194，实际得分：100 + 20 + 44 = 164


## 总结

难度大约是 $T1-T2-T4-T3-T5-T6$ 递增吧...

这个 noip 咋回事啊...感觉区分度简直跟 NOI Day2 似的，会的大家都能打，不会的（基本上）没人能做...

某神仙：“这不就是比谁FST少吗？”

可我偏偏就挂题了啊...

写了这么多，似乎也是想体现一下自己对于 OI 的热爱吧...可是当比赛完成后，热情一点点消退，冰冷的分数让你不得不作出两难的选择。恐怕一切都不那么简单吧。

赛前反复担心自己会卡在简单题上，最后发现还是难题攻坚能力不行。赛时心态恐怕也有些过于紧张，也没能多检查几遍数组有没有开小的问题...也可以说是自己埋葬了自己吧。

如果一切都按照最好的实力发挥，我是有希望上500的，可现在也只能在 400 下挣扎。恐怕也是自己太年轻老作死吧，这种事情也怨不得别人，但是组题人还是可以骂的...

考试结束前紧张了一会，发现自己挂题后紧张了一会...不过现在也都释然了...这算什么大事啊，省选AK照样A队稳稳的2333况且文化课也不是上不了清华啊233
- - -
最后大概期望得分：255+162 = 417...这个分数好尴尬啊...估计省选什么的是要凉了23333等出分了再来upd吧

另，CCF换少爷机了...这就是报名费+=200的理由吗233333

### 出分后update

自己菜也不能怪别人啊qaq

不过打错模数50->20分...大样例不过80分硬让我调成50的事情嘛...也不知道该说什么...如果IOI赛制恐怕不会有这些奇怪的事情...不过也没那么多如果啊qaq

省选大约还要继续划水...现在还是十分迷茫...