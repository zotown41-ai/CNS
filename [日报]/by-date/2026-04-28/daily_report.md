# 文献追踪报告

- 时间范围：2026-04-28 ~ 2026-04-28
- 目标期刊数：10
- 本周新论文数：4
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

- 本期刊剩余论文为空。

### Science Immunology

- 本期刊剩余论文为空。

### Bioinformatics

#### 蛋白质-RNA模型质量的图Transformer推断 / Inferring the qualities of protein-RNA models with graph transformers
- 日期：2026-04-28
- 作者：未提供
- 文章类型：未提供
- 研究问题：如何利用图Transformer对蛋白质-RNA复合物模型进行多维度质量评估，并提升高质量模型的排序与筛选能力？
- 发现/highlights：
  1. 提出基于图Transformer的CARP方法，可同时预测蛋白质-RNA复合物模型的多层面质量。
  1. 在非冗余蛋白质-RNA对接基准上，CARP较现有多数评分工具表现更优，尤其擅长高质量decoy的排序与筛选。
  1. 在CASP16及AlphaFold3模型筛选测试中，CARP持续显示出更强的高质量模型选择能力。
- 摘要：蛋白质三级和四级结构预测的突破显著推动了结构生物信息学研究与药物开发，但许多生物学机制涉及更复杂的相互作用，例如蛋白质与RNA之间的作用。由于数据稀缺和实验研究困难，蛋白质-RNA复合物结构预测具有高度重要性且极具挑战。针对这一需求，作者提出了一种新的基于图Transformer的质量评估方法CARP（complex quality assessment of RNA and protein），用于推断蛋白质-RNA复合物模型的多种质量指标。对于单个复合物模型，CARP可一次性同时预测整体折叠质量、整体界面质量以及逐蛋白质-RNA界面质量。在非冗余蛋白质-RNA对接基准测试中，该方法相较几乎所有现有评分工具均表现出明显优势，尤其在高质量decoy的排序和筛选方面表现突出。在CASP16靶标测试中，CARP相较其他预测器也能稳定选出更高质量的模型。具体而言，基于所有10个CASP16蛋白质-RNA复合物靶标的top-3入选模型评估，CARP预测的全局界面质量和全局蛋白质-RNA界面质量分别排名第1和第2。此外，与现有工具及AlphaFold3自评估结果相比，CARP在筛选高质量AlphaFold3模型方面同样表现出较强能力。该方法可免费获取：github.com/zwang-bioinformatics/CARP/。
- 链接：https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btag202/8664118?rss=1

#### ChASM：用于古DNA研究中染色体非整倍体检测的统计学严谨方法 / ChASM: A Statistically Rigorous Method for the Detection of Chromosomal Aneuploidies in Ancient DNA Studies
- 日期：2026-04-28
- 作者：未提供
- 文章类型：未提供
- 研究问题：如何在古DNA研究中，以统计学上严谨的方式从测序数据中检测完整的常染色体及性染色体非整倍体，从而克服骨骼遗存难以单独准确诊断此类异常的局限？
- 发现/highlights：
  1. 提出ChASM，一种用于古DNA研究中检测整倍体异常的贝叶斯统计方法。
  1. 该方法基于染色体水平读段计数，并校正测序方法、遗传覆盖度及疾病罕见性差异。
  1. 作者同时提供R语言实现RChASM，可用于小型和大型序列数据库的筛查。
- 摘要：研究动机在于，个体在过去社会中如何被对待，可通过对疾病、残障或异常状况的识别获得重要线索。染色体非整倍体是人群中最常见的大尺度染色体异常，可累及常染色体（如唐氏综合征）或性染色体（如克兰费尔特综合征），其表型表现从轻到重不等。尽管从遗传学角度较易识别，但仅依据骨骼遗存进行诊断较为困难，因为其骨骼病理表现可与多种其他疾病重叠。本文提出ChASM（Chromosomal Aneuploidy Screening Methodology，染色体非整倍体筛查方法），这是一种具有严格统计学基础的贝叶斯方法，用于检测完整的常染色体及性染色体非整倍体。该方法利用按染色体汇总的读段计数，并综合考虑测序方法差异、遗传覆盖度以及疾病罕见性，以生成后验概率估计，适用于小型和大型序列数据库的筛查。为便于使用，作者以R语言实现了RChASM软件包，并以MIT许可在CRAN发布。
- 链接：https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btag204/8664117?rss=1

### Nature Protocols

#### 利用IPOD-HR绘制细菌基因组上大规模蛋白占据图谱 / Profiling large-scale protein occupancy on bacterial genomes using IPOD-HR
- 日期：2026-04-28
- 作者：Rebecca L. Hurto, Jeremy W. Schroeder, Julian Trouillon, Uwe Sauer, Lydia Freddolino
- 文章类型：未提供
- 研究问题：如何利用IPOD-HR这一高分辨率方法，在细菌中实现全基因组尺度的蛋白占据谱绘制，并结合计算流程开展标准化下游分析？
- 发现/highlights：
  1. 介绍了用于细菌全基因组蛋白占据谱分析的高分辨率IPOD-HR方法。
  1. 配套提供计算分析流程，以简化下游数据处理与结果解析。
  1. 该方案适用于大规模描绘细菌基因组上的蛋白结合占据特征。
- 摘要：本文介绍了IPOD-HR这一用于细菌全基因组蛋白占据分析的高分辨率方法，并配套提供了用于简化下游分析的计算流程。
- 链接：https://www.nature.com/articles/s41596-026-01357-7

### Nature methods

#### 单分子定位与扩散率显微技术揭示活细胞中动态生物分子组织 / Single-molecule localization and diffusivity microscopy reveals dynamic biomolecular organization in living cells
- 日期：2026-04-28
- 作者：Zuhui Wang, Yiwen Liu, Bo Wang, Xiangyu Liu, Wulan Deng
- 文章类型：未提供
- 研究问题：如何结合深度学习、扩散理论与超分辨成像，从单分子快照中同时获得单分子定位与扩散率信息，以解析活细胞内生物分子的动态组织规律？
- 发现/highlights：
  1. SMLDM整合深度学习、扩散理论与超分辨成像，可从单分子快照中同时提取定位与扩散率信息。
  1. 该方法用于解析活细胞内生物分子的动态组织状态，并揭示多种动态生物过程。
  1. 应用场景涵盖染色质活动、黏着斑、GPCR药物应答及相分离等体系。
- 摘要：单分子定位与扩散率显微技术（SMLDM）将深度学习、扩散理论与超分辨成像相结合，可从单分子快照中提取单分子扩散率和定位信息，从而为活细胞内动态生物过程提供新的解析视角，包括染色质活动、黏着斑动力学、GPCR药物应答以及相分离等。
- 链接：https://www.nature.com/articles/s41592-026-03078-x
