# 文献追踪报告

- 时间范围：2026-09-29 ~ 2026-09-29
- 目标期刊数：10
- 本周新论文数：3
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

#### scURL: Uncertainty-Sharpened Representation Learning for Single-cell Multi-omics Clustering
- 日期：2026-09-29
- 作者：未提供
- 文章类型：未提供
- 研究问题：Single-cell multi-omics clustering requires integrating complementary omics layers while accounting for their unequal reliability across individual cells.
- 核心发现：
  1. However, cell-wise reliability can vary substantially within each omics layer, causing different omics to provide reliable signals for some cells but ambiguous or noisy signals for others.
  1. This challenge is further complicated by omics-level heterogeneity, where differences in sparsity, signal distribution, and biological resolution may introduce cross-omics conflicts and bias the fused representation.
  1. Results We present scURL, an uncertainty-sharpened representation learning framework for single-cell multi-omics clustering.
- 摘要：Abstract Motivation Single-cell multi-omics clustering requires integrating complementary omics layers while accounting for their unequal reliability across individual cells. However, cell-wise reliability can vary substantially within each omics layer, causing different omics to provide reliable signals for some cells but ambiguous or noisy signals for others. This challenge is further complicated by omics-level heterogeneity, where differences in sparsity, signal distribution, and biological resolution may introduce cross-omics conflicts and bias the fused representation. Results We present scURL, an uncertainty-sharpened representation learning framework for single-cell multi-omics clustering. scURL introduces representation uncertainty (RU) and establishes its connection to clustering generalization risk (GR), enabling the derivation of cell-wise omics weights for uncertainty-aware fusion (UAF). To support stable uncertainty estimation, scURL further introduces a multi-granular calibration module (MCM) that calibrates omics-specific representations from both cluster-level semantic and local-level structural perspectives before fusion. Experiments on ten datasets demonstrate that scURL outperforms existing clustering methods, remains robust under dropout noise, and identifies biologically meaningful cell populations, as supported by marker gene analysis. Availability and Implementation Source code is available at https://github.com/Yaolab-fantastic/scURL
- 链接：https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btag723/8845493?rss=1

#### OrchAlign: Orchestrated Multimodal Alignment for Gene Expression Prediction
- 日期：2026-09-29
- 作者：未提供
- 文章类型：未提供
- 研究问题：Gene expression prediction benefits from integrating DNA sequences and epigenomic signals.
- 核心发现：
  1. Existing approaches typically combine these modalities using simple operations such as concatenation or summation, without explicitly modeling fine-grained token-level cross-modal interactions.
  1. Establishing precise cross-modal correspondences remains challenging due to (1) inter-modal discrepancies, and (2) intra-modal structural preservation.
  1. Results To address these challenges, we propose OrchAlign, an orchestrated multimodal alignment framework that establishes fine-grained cross-modal alignment while preserving intra-modal structure.
- 摘要：Abstract Motivation Gene expression prediction benefits from integrating DNA sequences and epigenomic signals. Existing approaches typically combine these modalities using simple operations such as concatenation or summation, without explicitly modeling fine-grained token-level cross-modal interactions. Establishing precise cross-modal correspondences remains challenging due to (1) inter-modal discrepancies, and (2) intra-modal structural preservation. Results To address these challenges, we propose OrchAlign, an orchestrated multimodal alignment framework that establishes fine-grained cross-modal alignment while preserving intra-modal structure. Our approach first disentangles each modality into shared and specific representations. We then perform focused cross-modal alignment on the shared subspace within a key regulatory region, producing aligned representations with token-level correspondences. Moreover, we enforce consistency between relational structures of the aligned shared representations and their corresponding modality-specific counterparts, enhancing intra-modal structural coherence. Finally, the aligned shared representations and modality-specific representations are passed to the BiMamba backbone for further multimodal fusion. Our experimental results show that OrchAlign achieves state-of-the-art performance in gene expression prediction. Availability and Implementation All resources are available at https://github.com/XMUDM/OrchAlign Contact and
- 链接：https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btag711/8845491?rss=1

#### CSGDA: A Cell State-Guided Graph Domain Adaptation Network for Single-Cell Drug Response Prediction
- 日期：2026-09-29
- 作者：未提供
- 文章类型：未提供
- 研究问题：Intratumoral heterogeneity drives cancer recurrence and metastasis, yet single-cell drug response prediction faces severe “cross-domain” challenges, such as applying in vitro models to in vivo tissues or inferring metastatic resistance from primary tumors.
- 核心发现：
  1. These scenarios trigger distribution shifts arising from heterogeneous sequencing platforms, distinct tissue microenvironments, and metastatic evolution—problems rarely addressed by existing methods.
  1. Results We introduce CSGDA, a cell state-guided graph domain adaptation framework designed to predict drug responses across these biological heterogeneities.
  1. CSGDA incorporates biological priors to map gene expression into functional cell states, guiding a structure learning module to construct robust cell topology.
- 摘要：Abstract Motivation Intratumoral heterogeneity drives cancer recurrence and metastasis, yet single-cell drug response prediction faces severe “cross-domain” challenges, such as applying in vitro models to in vivo tissues or inferring metastatic resistance from primary tumors. These scenarios trigger distribution shifts arising from heterogeneous sequencing platforms, distinct tissue microenvironments, and metastatic evolution—problems rarely addressed by existing methods. Results We introduce CSGDA, a cell state-guided graph domain adaptation framework designed to predict drug responses across these biological heterogeneities. CSGDA incorporates biological priors to map gene expression into functional cell states, guiding a structure learning module to construct robust cell topology. To mitigate distribution shifts, the model employs graph domain adaptation combined with a novel overlap penalty mechanism. Extensive benchmarks on five scRNA-seq datasets demonstrate that CSGDA outperforms the state-of-the-art method SSDA4Drug by approximately 6 percentage points in both ACC and AUPR. Beyond prediction accuracy, we employed integrated gradients to effectively pinpoint key genes involved in drug resistance within a challenging cross-metastasis cisplatin dataset. These findings underscore CSGDA’s superior performance in single-cell drug response prediction and its potential in resolving single-cell heterogeneity, paving the way for precision medicine. Availability and Implementation Source code is available at https://github.com/yanfen-git/CSGDA-code and archived at https://doi.org/10.5281/zenodo.21759274 . Data are available at https://doi.org/10.5281/zenodo.21770737
- 链接：https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btag726/8845492?rss=1

### Nature Protocols

- 本期刊剩余论文为空。

### Nature methods

- 本期刊剩余论文为空。
