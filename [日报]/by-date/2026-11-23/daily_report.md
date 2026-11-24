# 文献追踪日报｜2026-11-23

- 期刊更新：13 条 · 重点研究：1 条 · 期刊覆盖：10/10
- 追踪主题：免疫代谢、代谢表观调控、单细胞算法、单细胞图谱、流感、HSV、H1N1、肺损伤、肺组织修复、皮肤免疫

## 重点研究

#### BioBatchNet：用于成像质谱流式细胞术中稳健批次效应校正的双编码器框架 / BioBatchNet: A Dual-Encoder Framework for Robust Batch Effect Correction in Imaging Mass Cytometry
- Bioinformatics · 2026-11-23 · 有摘要
- 作者：Haiping Liu, Qian Zhao, Shaojie Zhang, Shengzhong Mao, Yuxi Zhou, Yabing Yao, Jingyuan Sun, Andrew Gilmore, Mauricio A Alvarez, Hongpeng Zhou
- 追踪主题：单细胞算法
- 匹配依据：单细胞算法 · 题名：imaging mass cytometry + batch effect correction
- 主要结果（据 PubMed 摘要 Results · 中文摘译）：
  1. 我们在三个 IMC 数据集上评估了 BioBatchNet，它在校正和生物信号保存方面的稳健性优于七个基准测试方法。
  2. 这个改编版本在四个 scRNA-seq 数据集上取得了有竞争力的性能，在其中三个数据集上获得了最高的总分。
- 论文摘要（PubMed 摘要 · 中文译文）：成像质谱流式细胞术 (IMC) 是一种用于在单细胞水平上分析空间分辨蛋白质表达的尖端技术。然而，其下游分析常常受到批次效应的阻碍，批次效应会引入系统偏差并掩盖生物变异。现有的校正方法主要是针对 scRNA-seq 数据开发的，由于数据特征的差异，在适应 IMC 数据方面面临挑战。此外，这些方法难以实现精确控制，导致要么通过删除关键生物信息而过度校正，要么通过留下残余批次效应而导致校正不足。此外，IMC 数据通常具有重叠的细胞群，使聚类和下游分析变得复杂。这些挑战强调需要一种针对 IMC 数据定制的稳健且可控的批次效应校正方法。  结果：我们提出了 BioBatchNet，这是一个双编码器框架，利用对抗性训练来明确地解开批次特定信号和生物信号。 BioBatchNet 可实现可控批次效应校正，平衡校正与生物变异的保留。我们在三个 IMC 数据集上评估了 BioBatchNet，它在校正和生物信号保存方面的稳健性优于七个基准测试方法。此外，我们开发了一种约束配对聚类（CPC）方法，该方法使用约束对来提高聚类性能，即使在具有重叠细胞群的数据集中也是如此。为了验证其普适性，我们通过将数据似然从高斯分布更改为零膨胀负二项式分布，将 BioBatchNet 应用于 scRNA-seq 数据集。 这个改编版本在四个 scRNA-seq 数据集上取得了有竞争力的性能，在其中三个数据集上获得了最高的总分。这些结果证明了 BioBatchNet 在纠正不同单细胞数据集的批次效应方面的通用性和鲁棒性，并强调了其大规模生物分析的潜力。
- [查看来源](<https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btag853/9116086?rss=1>)

## 其他期刊更新

### Bioinformatics（1）

#### GSP：用于评估 3D RNA 结构预测的多尺度指标 / GSP: a multi-scale metric for evaluation of 3D RNA structure predictions
- Bioinformatics · 2026-11-23 · 有摘要
- 作者：Dariusz Aleksander Dziel, Krzysztof Fidelis, Eric Westhof, Maciej Antczak, Marta Szachniuk
- 主要结果（据 PubMed 摘要 Results · 中文摘译）：
  1. 我们证明，GSP 能够可靠地识别具有可比总体偏差的模型，同时与全局指标保持高度一致。
- 论文摘要（PubMed 摘要 · 中文译文）：RNA 3D 结构的准确预测仍然是结构生物信息学的一个核心挑战，需要可靠的措施来量化预测模型和实验确定的参考结构之间的相似性。目前，许多评分函数可用于评估生物分子三级结构的不同方面。一方面，全局度量平均了局部不规则性，因此不同地区扭曲的结构通常可以被认为是结构相似的。另一方面，局部构象测量侧重于特定的残基间相互作用，通常无法捕获更广泛的拓扑背景。因此，缺乏能够全面评估不同空间尺度的结构差异的方法。  结果：为了解决这一差距，我们引入了几何球面精度 (GSP)，这是一种新颖的多尺度评分，可评估 3D RNA 和 RNP 复杂预测的质量。它将根据局部几何协议计算出的多个部分分数集成到一个易于阅读的标准化分数中，以便对这些预测进行排名。我们证明，GSP 能够可靠地识别具有可比总体偏差的模型，同时与全局指标保持高度一致。这些特性使其成为对 3D RNA 结构和 RNP 复合物进行基准测试和比较的有用工具。可用性和实施​​：GSP 脚本以及针对 RNA-Puzzles 和 CASP15 数据集最先进措施的评估结果可在 https://doi.org/10.5281/zenodo.19608328 上获取。
- [查看来源](<https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btag854/9116087?rss=1>)

### Nature（3）

#### 痘病毒早期转录机制和门户复合体的结构 / Architecture of the poxvirus early-transcription machinery and portal complex
- Nature · 2026-11-23 · 有摘要
- 作者：Benoît Arragain, Lukas W. Bauer, Victor-Valentin Hodirnau, Florian K. M. Schur
- 论文摘要（出版社摘要 · 中文整理）：这是一项病毒结构研究。作者观察了病毒颗粒内部负责早期转录的装置和门户复合体，旨在解释两类结构在病毒颗粒中如何组织。
- [查看来源](<https://www.nature.com/articles/s41586-026-11458-8>)

#### 连续 N-C 肽合成 / Continuous N-to-C Peptide Synthesis
- Nature · 2026-11-23 · 有摘要
- 作者：Jingjun Yin, Ji Qi, Zhiyan Song, Baoqiang Wan, Jin Zhang, Fangzhou Xie, Enkai Wang, Yang Cao, Hongming Li, Qixue Yuan, Jinxiang He, Xiao Wang, Liwen Xu, Chunrui Sun, Kai-Jiong Xiao, Feng Peng, Shishi Lin, Gao Shang, Lu Wang, Jing Xu, Jiwen Jiang, Xiupeng Duan, Donghong Li, Mengli Zhang, Haijiang Nan, Like Chen, Fang Wang, Tong Kang, Minyi Feng, Guiquan Liu, Louis-Charles Campeau
- 论文摘要（出版社摘要 · 中文整理）：研究提出连续的 N 端到 C 端肽合成路线，以减少中间分离和废物产生。作者还展示了该路线在多种治疗相关肽上的应用。
- [查看来源](<https://www.nature.com/articles/s41586-026-11448-w>)

#### 非经典碳正离子合成六取代苯 / Hexa-substituted benzene synthesis with non-classical carbocations
- Nature · 2026-11-23 · 有摘要
- 作者：Guillaume Mollaert, Hang-Fei Tu, Jacob R. King, Mihai V. Popescu, Zexian Li, Quan Zhang, Eric Palomo, Robert S. Paton, Marcos G. Suero
- 论文摘要（出版社摘要 · 中文整理）：研究展示了可预测地在苯环六个位点布置取代基的合成策略，拓宽了原本较难获得的高度取代芳香化合物范围。
- [查看来源](<https://www.nature.com/articles/s41586-026-11449-9>)

### Nature Immunology（7）

#### 非洲疫苗生产雄心从主权到可持续复原力 / Africa’s vaccine manufacturing ambition from sovereignty to sustainable resilience
- Nature Immunology · 2026-11-23 · 期刊导读
- 作者：Shabir A. Madhi, Glenda E. Gray
- 期刊导读（期刊 RSS · 中文译文）：无法公平地获得包括 COVID-19 疫苗在内的救生疫苗，暴露了非洲对外部供应依赖的脆弱性。非洲应通过负担得起的日常采购来增强抵御能力，同时战略性地将适应性平台、研发、疫情应对能力和监管专业知识制度化
- [查看来源](<https://www.nature.com/articles/s41590-026-02666-5>)

#### 超越抗体：工程器官规模免疫 / Beyond antibodies: engineering organ-scale immunity
- Nature Immunology · 2026-11-23 · 期刊导读
- 作者：Bali Pulendran
- 期刊导读（期刊 RSS · 中文译文）：疫苗的作用不仅仅是诱导抗体和淋巴细胞。新的证据表明，他们可以建立组织嵌入的器官规模免疫，称为综合器官免疫，它提供针对不同病原体的广泛保护，并揭示更广泛的保护性免疫状态
- [查看来源](<https://www.nature.com/articles/s41590-026-02661-w>)

#### 饮食留下记忆 / Diet leaves a memory
- Nature Immunology · 2026-11-23 · 研究亮点
- 作者：Stephanie Houston
- 研究亮点（出版社研究亮点 · 中文整理）：这则研究亮点介绍了一项 Nature 小鼠研究：短期高脂饮食可加剧皮肤炎症，恢复正常饮食后仍可观察到免疫记忆相关影响。
- [原研究](<https://doi.org/10.1038/s41586-026-11181-4>)
- [查看来源](<https://www.nature.com/articles/s41590-026-02733-x>)

#### 利用 ILC2 的免疫调节功能进行 CAR 治疗 / Exploiting immunoregulatory functions of ILC2s for CAR therapy
- Nature Immunology · 2026-11-23 · 期刊导读
- 作者：Timotheus You Fu Halim
- 期刊导读（期刊 RSS · 中文译文）：除了促进2型免疫外，2型先天淋巴细胞（ILC2）还具有强大的免疫调节能力； ILC2 的这一未被充分认识的功能现在被用作治疗自身免疫性疾病的潜在“CAR ILC2”疗法
- [查看来源](<https://www.nature.com/articles/s41590-026-02720-2>)

#### 感染阈值 / Infection thresholds
- Nature Immunology · 2026-11-23 · 研究亮点
- 作者：Ioana Staicu
- 研究亮点（出版社研究亮点 · 中文整理）：这则研究亮点介绍了一项 Cell 研究，关注感染的起始门槛会如何随病毒和宿主细胞类型而变化。它是对原研究的导读，不是另一篇原创研究。
- [原研究](<https://doi.org/10.1016/j.cell.2026.10.004>)
- [查看来源](<https://www.nature.com/articles/s41590-026-02734-w>)

#### mRNA疫苗的新视野 / New horizons of mRNA vaccines
- Nature Immunology · 2026-11-23 · 评论
- 作者：Michael J. Hogan, Norbert Pardi
- 期刊导读（期刊 RSS · 中文译文）：此评论强调了 mRNA 疫苗成功背后的创新，回顾了最新进展，并讨论了 RNA 疫苗平台的局限性以及克服这些局限性的潜在策略
- [查看来源](<https://www.nature.com/articles/s41590-026-02688-z>)

#### 疫苗学2.0 / Vaccinology 2.0
- Nature Immunology · 2026-11-23 · 期刊导读
- 期刊导读（期刊 RSS · 中文译文）：COVID-19 大流行凸显了疫苗开发的成功，但有必要在疫苗设计、公平性、制造和公共卫生政策变化方面进行更多改进
- [查看来源](<https://www.nature.com/articles/s41590-026-02725-x>)

### Nature methods（1）

#### 通过歌曲追踪个别鸟类 / Tracking individual birds by their song
- Nature methods · 2026-11-23 · 期刊导读
- 作者：Amanda Navine, Patrick Hart
- 期刊导读（期刊 RSS · 中文译文）：分析音景录音的自动化方法可以区分同一物种的个体鸟类之间歌曲结构的差异。这代表了一种新的非侵入性工具，用于监测整个景观中的鸟类
- [查看来源](<https://www.nature.com/articles/s41592-026-03406-1>)
