# 文献追踪报告

- 时间范围：2026-03-24 ~ 2026-03-24
- 目标期刊数：10
- 本周新论文数：5
- 本周重点文章数：0
- 关键词：免疫代谢, 代谢表观调控, 单细胞算法, 单细胞图谱, 流感, HSV, H1N1, 肺损伤, 肺组织修复, 皮肤免疫

## 本周重点文章

- 本周没有命中关键词的重点文章。

## 分期刊展示（剩余论文）

### Nature

- 本期刊剩余论文为空。

### Science

- 本期刊剩余论文为空。

### Cell

- 本期刊剩余论文为空。

### Cell metabolism

- 本期刊剩余论文为空。

### Immunity

- 本期刊剩余论文为空。

### Nature Immunology

#### 靶细胞上的MHC I调控CD4+ T细胞介导的免疫（MHC class I on target cells regulates CD4 + T cell-mediated immunity）
- 日期：2026-03-24
- 作者：Emma Lauder, Mahnoor Gondal, Meng-Chih Wu, Akira Yamamoto, Laure Maneix, Dongchang Zhao, Yaping Sun, Marcin Cieslik, Arul M. Chinnaiyan, Pavan Reddy
- 文章类型：未提供
- 研究问题：靶细胞表面主要组织相容性复合体I类分子（MHC I）的表达是否调控CD4+ T细胞介导的免疫效应，尤其是对异基因细胞或肿瘤细胞铁死亡易感性的影响？
- 发现/highlights：
  1. 当异基因或肿瘤靶细胞下调MHC I时，其对CD4+ T细胞介导的杀伤更易感。
  1. 该研究提示CD4+ T细胞介导的免疫作用与靶细胞表面MHC I表达水平相关。
  1. 作者提出MHC I下调可增强CD4+ T细胞介导的铁死亡敏感性。
- 摘要：作者提出，当异基因细胞或肿瘤细胞表面的主要组织相容性复合体I类分子（MHC I）下调时，这些靶细胞对CD4+ T细胞介导的铁死亡更为敏感。
- 链接：https://www.nature.com/articles/s41590-026-02480-z

#### 共生菌加入效应蛋白博弈 / Commensals join the effector game
- 日期：2026-03-24
- 作者：Julia Sanchez-Garrido
- 文章类型：未提供
- 研究问题：健康肠道微生物组中的共生菌所携带的Ⅲ型分泌系统及其效应蛋白，是否能够调控人体免疫信号，并影响炎症性疾病易感性？
- 发现/highlights：
  1. 健康肠道微生物组中广泛存在细菌Ⅲ型分泌系统，而其并非仅限于致病相关背景。
  1. 这些分泌系统可递送效应蛋白，进而调节人体免疫信号通路。
  1. 共生菌相关效应机制可能影响机体对炎症性疾病的易感性。
- 摘要：细菌Ⅲ型分泌系统传统上被视为毒力因子，但其在健康肠道微生物组中同样广泛存在；这些系统可递送效应蛋白，调节人体免疫信号传导，并影响个体对炎症性疾病的易感性。
- 链接：https://www.nature.com/articles/s41590-026-02467-w

### Science Immunology

- 本期刊剩余论文为空。

### Bioinformatics

#### 环境生物转化反应的酶关联：通过反应中心特异性指纹的对比学习 / Enzyme Association for Environmental Biotransformation Reactions Through Contrastive Learning of Reaction Center-Specific Fingerprints
- 日期：2026-03-24
- 作者：Kunyang Zhang, Thierry D Marti, Silke I Probst, Serina L Robinson, Kathrin Fenner
- 文章类型：期刊论文
- 研究问题：能否通过自监督对比学习改进基于BERT的环境生物转化反应指纹，使其更准确地表征反应中心与转化类型，并进一步实现反应—酶关联及污染物生物转化相关酶类预测？
- 发现/highlights：
  1. 提出一种自监督对比式微调策略，学习面向环境生物转化反应中心的256维反应指纹crxnfp。
  1. crxnfp在多数据集反应分类中表现优于或不逊于现有方法，并更能按转化类型聚类反应。
  1. 该方法可将enviPath中的反应与Rhea、UniProt酶注释进行相似性关联，并以91.3%的第三级酶分类准确率辅助识别污染物生物转化相关酶类。
- 摘要：研究动机：微生物生物转化在化学污染物的环境降解中发挥核心作用，其过程由多种酶的催化活性驱动。然而，在真实环境条件下，将特定酶与污染物去除联系起来并预测相关转化产物，仍是一项重大挑战。本研究提出一种用于反应指纹学习的自监督对比式微调策略，旨在提升基于BERT的反应嵌入在环境生物转化反应中的化学相关性。具体而言，作者对BERT编码器进行微调，使其反应指纹之间的余弦相似度与传统基于结构的指纹之Tanimoto相似度保持一致。

研究结果：所得紧凑型256维指纹被命名为crxnfp，表现出更强的能力，能够按照转化类型对反应进行聚类，并将注意力集中于具有化学意义的反应中心。crxnfp还在多个数据集的反应分类任务中得到验证，其性能优于或可比于现有方法。更重要的是，该指纹实现了基于相似性的关联，将enviPath中的生物转化规则与反应同Rhea和UniProt数据库中的酶注释连接起来，为以酶学信息丰富环境生物转化数据集提供了可扩展的方法。此外，crxnfp还被用于识别参与污染物生物转化的特定酶类别，并在本研究的实验中得到验证，在第三级酶分类上达到91.3%的准确率。总体而言，crxnfp为推进污染物生物转化机制理解，并指导不同环境情境下基于酶学信息的污染物管理策略开发，提供了有前景的解决方案。

代码获取：代码可见于https://github.com/zhangky12/crxnfp 和 https://github.com/zhangky12/crxnfp_knn。

补充信息：补充数据可于Bioinformatics在线版获取。
- 链接：https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btag142/8537913?rss=1

#### AutoGERN：通过显式连边建模与自适应架构进行单细胞RNA测序基因调控网络推断 / AutoGERN: Single-Cell RNA-Seq Gene Regulatory Network Inference via Explicit Link Modeling and Adaptive Architectures
- 日期：2026-03-24
- 作者：Jiacheng Wang, Yaojia Chen, Quan Zou, Ximei Luo
- 文章类型：期刊论文
- 研究问题：如何针对单细胞RNA测序数据，构建一种能够显式建模基因调控边信息、并可适应不同数据集分布偏移的图神经网络框架，以提高基因调控网络推断的性能与稳健性？
- 发现/highlights：
  1. AutoGERN面向单细胞RNA测序数据的基因调控网络推断，显式建模基因间调控边信息。
  1. 该方法采用层内与跨层双消息传递空间，并结合AutoGNN架构搜索以适应不同数据分布。
  1. 在多个真实scRNA-seq数据集上，AutoGERN较现有先进方法表现出更优的性能与稳健性。
- 摘要：作者提出用于单细胞RNA测序数据基因调控网络推断的图神经网络框架AutoGERN。该方法通过显式学习边嵌入建模调控信息，结合层内与跨层双消息传递机制，以及基于AutoGNN的架构搜索来适配不同数据分布。多项真实数据集实验显示，其性能与稳健性优于现有先进方法。
- 链接：https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btag143/8537914?rss=1

### Nature Protocols

#### Tracking-seq：用于CRISPR–Cas基因组编辑的通用脱靶检测方法 / Tracking-seq: a universal off-target detection approach for CRISPR–Cas genome editing
- 日期：2026-03-24
- 作者：Runda Xu, Tingting Cong, Junsong Yuan, Xuancheng Chen, Yinqing Li, Xun Lan, Ming Zhu
- 文章类型：未提供
- 研究问题：如何建立一种适用于多类CRISPR–Cas基因组编辑工具的通用方法，以在全基因组范围内评估其脱靶活性？
- 发现/highlights：
  1. 本文提出Tracking-seq流程，用于检测CRISPR–Cas基因编辑的全基因组脱靶活性。
  1. 该方法通过追踪复制蛋白A（RPA）对单链DNA中间体的结合来识别潜在脱靶位点。
  1. 该方案被描述为适用于多种基因编辑器的通用、分步实验方法。
- 摘要：本文以分步实验方案形式介绍了Tracking-seq，这是一种通用的脱靶检测方法。该方法通过追踪复制蛋白A（RPA）这一与单链DNA中间体结合的关键蛋白，评估多种基因编辑器在全基因组范围内的脱靶活性。
- 链接：https://www.nature.com/articles/s41596-025-01331-9

### Nature methods

- 本期刊剩余论文为空。
