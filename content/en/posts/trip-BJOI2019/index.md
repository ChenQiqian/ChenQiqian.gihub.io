---
title: BJOI2019退役记
urlname: BJOI2019
date: 2019-04-21 21:39:12
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

GoodBye, OI.

<!--more-->

## 太长不看版

> 考的还不错，rk19 退役。

## 说在前面

好好的BJWC就给取消了啊。

## Week -2

### Day1 2019-04-06

第一天，又是熟悉的首师大附中。

今天充满了锅的味道。

首先是晚开始了半个小时emm所以本来捉鸡的三个小时时间就变成了两个半小时（虽然后来补了半个小时）

然后 9:30 打开题...怎么文件名是 `0612.pdf` ？？？怎么内容是山东省队集训？？？

好吧好吧做吧做吧。

T1 啥啊？矩阵啥玩意？我咋看不懂题？咋没有部分分啊？？？

T2 啥啊？图和生成树的那一套理论？？？我不会啊？？？咋没有部分分啊？？？

T3 啥啊？看起来像个类似字符串的 dp ？为什么 lzy 在我旁边写 SA ？？？有部分分？让我推推...

推啊推 T3...好像可以搞出一个 dp，但是好像没法满足第一个要求啊。

写啊写啊写，推啊推啊推...一个多小时过去，大概写了个哈希+二分+二分之类的东西；大概跑过了样例...然后发现是有锅的...胡乱搞了个贪心上去...

看 T1 ...哦我终于看懂了题意...诶胡乱猜结论...是不是线性无关就可以少一次操作啊...那么高斯消元消消消...又写了个类似线性基的东西拍一拍...好像精度不太容易出锅...不管了不管了...

这个时候说还可以再写半个小时...不写了不写了我要吃饭...

于是就交了程序去吃饭...

饭很好吃。

饭真的很好吃。

饭真的超级好吃。

下午讲题...

T1 A掉了，多亏这道题没有爆 0 qaq

好像全世界都会T2？就是个奇葩构造？好吧...

T3 的贪心果然假了，然后获得了 0 分的好成绩...好歹也想到了正解的一半呢...也不多给点分数...

并列排名 20-49 名 emmm很符合蒟蒻的本质了...

讲课讲的是网络流，好像不是很难，也没怎么听。

下午骑车回家...不错啊qwq

### Day2 2019-04-07

又是熟悉的首师大附中嗯。

hyc 同学提前进入了系统被首师大的老师训斥了（并且为了给 hyc 同学下台的机会：“小黄同学在这个屋子里不是第一也是第二名”）

今天考试 8:30 就开始了考试，题目终于是 `BJOI` 开头的题目了2333

T1 啥啊？怎么有地图啊...下一题...

T2 啥啊？怎么又是图和生成树的那一套理论啊？这次还要算数...下一题...

T3 啥啊？怎么又是图论中存在性染色问题啊？？？不会像去年省选那样随便猜个结论就过了吧...

先看 T1 吧。我可以预处理一波...然后变成一个啥问题..？每四个 B 物品必须选一个？？？咋做啊...怎么就两档 subtask 啊 （40/40+60）... 

不管了先写个预处理...想想想写写写 2h 就这么过去了...我怎么还是不会后面的操作啊...其间脑补了若干个假的做法...

好吧先放着我去想想后面的题...

T2 10 分 $k = 0$ 我会233 就是求一个生成树个数嘛...后面的部分分好像也不是很难...

再看看 T3... 诶？好像有个什么sb性质？？只会必要性不会充分性，那肯定就是了。可以从 $O(2^{2n})$ 优化到 $O(2^n)$ ... 好像可以有 40 分了诶...打了个大暴力和小暴力拍拍...嗯过了那这个结论好像是对的...

咦？我左边的人怎么 T1 写了 500 行？？？（赛后发现此人 A 掉了此题...） 咦？我右边的人怎么再看 vim 的文档？？？好吧...

诶？T3 好像不需要枚举子图...就是最大权闭合子图啊...啊！这个我会！看看表...还有四十分钟...没事没事...

开始码 dinic ...前几天写了网络流 24 题... dinic 的板子都快能不看键盘敲出来了...说到键盘...我的键盘的 backspace 居然是坏的...这对于一个手残选手真的是...

10 分钟多一点敲完 dinic （我用自己的笔记本可以 7 分钟左右敲完的），建图很 easy ，拍拍拍死活拍不过...然后猛然发现是要最大权非空闭合子图...自闭...把暴力交上去了...

嗯。出分倒是没挂分...

T1 没学过 2-SAT + 没发现光路可逆...没办法吧

T2 神仙数学...倒是我少看到 30 分暴力 emmm

T3 为什么枚举必选一个点然后多跑 500 倍次数 dinic 可以过 合着 50 次 dinic 0.04s？？？ ？？？？？我都在正解门口了啊喂...差点就 100 分了啊...

最后 rk30 ...也差不多吧...

下午杂题选讲在写周末作业，没听。

rdfzhyc 和 真正的 hyc 切题都切的很欢乐 orz

## Week -1

### Day1 2019-04-13

大概是有史以来在省里排名最高的一次呢...

进场要求换了个键盘，感觉比以前的那个好多了...

8:30 开始考试看题。

T1看起来就是个dp...emm好像连最小部分分都不会...

T2数据范围 $10^5$ 耶！树上的题！耶！看看啊...诶先写个 20 分 $O(n^2)$ 暴力吧...大概 10 分钟多大概过了...

仔细研究一下...统计所有路径中满这个东西好像可以点分治，回忆了一波点分治怎么写...

然后开始写点分治...大概写了一个小时写到最后的两个 dfs...然后发现自己的一个 dfs 假了...想了想套了一个左偏树上去从下往上合并，然后于是多了一个 $\log$ ...大概两个小时调过了  T2 ... 

然后看 T3...T3 的暴力好像非常轻松... 20 分的 $O(n^3)$ 暴力 5 分钟就写完了...然后推了推式子发现 $O(n^2)$ 的斜率优化也非常显然...

然后忽然想起来...什么？n 个东西分成 k 份？？？我会 wqs 二分！！！

打个表发现的确有凸性...然后写了个 wqs 二分 + 斜率优化...20分钟就写完了...对拍拍拍改改改过过过...

然后最后还剩下半个多小时...写了写 T1 的暴力没写完...

中午饭还是一如既往的好吃...

下午先讲了 COCI 的题目若干，题目是相当的毒瘤呀qaq（我一直在打游戏 & 写数学作业

然后 3 点多的时候出成绩了...第三题因为 `eps` 设大了而挂了 $30$ 分...

于是就 `rk6` 。

如果省选能这么高的话大概就可以翻盘了吧（

就算进队了我也不会去 NOI 的...

## Week 0

### Day1 2019-04-20

正式比赛日。

今天起的格外的早...三周没有时间补觉，感觉自己的精力快要被耗尽了...

早上八点开始考试。

T1 看了看。很像一个 AC 自动机上胡逼 dp 。

T2 看了看。哇。题面好长。它在讲啥呢...哦好像是个数学题。

T3 看了看。哇。题面怎么比 T2 还长啊。看着怎么这么像一个乱搞题啊...仔细看看...不会告辞...

回去推了推 T1 。好像有一个 $O(n^3 \sqrt n)$ 的显然 dp ...emmm 取个对数就变成了几何平均值了啊。咦？几何平均值...我会 0/1 分数规划...脑补了一波开始写写写...得有几个月没写过 AC 自动机了...AC自动机错，AC自动机错完  dp 错... 想+写+调了两个小时终于过了样例...

于是看 T2 。啥玩意啊...只会40分...写了些 150 行+终于过掉了40分的暴力分...

看了看 T3 ...感觉如果写 100 行也就是 10 分...不写了...查查 T1 & T2...

然后就 13 点比赛结束了...

吃饭的时候发现并不怎么好...我校除了 dmy 没人会做 T2... hyc 会做 T3 怒刚 4h 过掉大样例然后就没发现 T1 是一个签到题... jkp 大概跟我打的分是一样多的...

吃完饭之后等到快 3 点开始讲题...我获得了 105 分... T1 被卡常 TLE 了 20 分... T2 不知道哪里搞错了 40 -> 25 ...咋一不小心就 rk13 了呢...

hyc T3 爆到 30 了... jkp 被女选手暴打了...不过还在队线上...

dmy 仍然是天下第一...

明天 hyc 一定能翻盘的！

jkp 一定能苟住队线的！

我一定能退役的！

### Day2 2019-04-21

8 点开考。

今天出了一些小锅...不过也是在八点开始了。

开局看 T1 ...咦？好想是个 sb dp？？？ $O(nms) = 2 \times 10^8$ 常数小能过吧...100分有了...

看 T2 。卧槽？怎么是个物理题？看起来是个无穷等比数列求和，我会啊（

推了推式子。写了怎么都调不过小样例...咦？模数是多少？1e9+7？？？我怎么敲成了998244353...然后过掉了第一个样例...测第二个三块玻璃的样例又 Wa 了...仔细想想觉得还要多维护两个东西才能合并...于是就写了然后过掉了样例扔到一边... 

写了 T1 的暴力 * 2 然后都跑的飞快（弱智 dp 还调了半个多小时...）

然后 10 点多过掉了两个题。

然后看 T3 。T3 一看就是一个数据结构题，初步把答案确定到平衡树和线段树两个上。然后找性质。

先转化了一下题目的条件，然后想怎么才能构造一个最优方案。然后大概有了个结论，写了一波过了样例。转化了一下发现好像可以用线段树维护，于是就开始码线段树。也不难写，一个小时左右就写完了（其间还把时间记错慌张了好一会）...写完过了拍大概是 12:00 左右...

吃饭。hyc & jkp都AK了。大概有翻盘的希望。我好像只要不 fst 就有翻盘的希望诶。

于是出分。开始还想在 300 分那里找到自己，发现第一屏都没有自己于是开始慌张。

最后发现自己 T3 爆零了... 200 分 rk30 左右吧...

看了看发现自己的 T3 ac & wa 参杂，但是捆绑测试下就爆 0 了...

然后想了半天也觉得自己没有写挂，把做法给 hyc 讲了一下...然后就被 dmy 叉掉了...（dmy：“这不是我想出来过的一个假结论吗”）

于是最后大概就是 hyc 和 jkp 都进队了，然后我总评 rk19 光荣退役...大概标准分上差了 15 分？

在省选前的那个周五， jkp 曾经想给我讲题，讲的就是 T3 的减弱版本，但被我拒绝了...如果听了的话，至少能会 47 分的吧...那么就进队了啊...但想想如果我这样的菜鸡选手都能进队，这无疑是对那些整天勤奋刷题的神仙选手最大的不公平吧。

我就不该买那三副扑克牌QAQ

不过木已沉舟...进队了倒是麻烦许多...

就是不进队就得考期中考试啊...滚去复习了...

## 结束语

想送给 6 个月前的自己，和所有看到这篇 blog 的人：

> 「可是留存的人总是习惯天真的为离开者感到悲悯，殊不知留存未必是正确的选择。」

GoodBye, OI.