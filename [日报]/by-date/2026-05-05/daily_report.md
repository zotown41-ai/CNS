# 文献追踪报告

- 时间范围：2026-05-05 ~ 2026-05-05
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

- 本期刊剩余论文为空。

### Science Immunology

- 本期刊剩余论文为空。

### Bioinformatics

#### Learning Protein Representations with Conformational Dynamics
- 日期：2026-05-05
- 作者：未提供
- 文章类型：未提供
- 研究问题：Abstract Motivation Proteins change shape as they work, and these changing states control whether binding sites are exposed, signals are relayed, and catalysis proceeds.
- 发现/highlights：
  1. Most protein language models pair a sequence with a single structural snapshot, which can miss state-dependent features central to interaction, localization, and enzyme activity.
  1. Studies also indicate that many proteins assume multiple, functionally relevant shapes, motivating approaches that learn from this variability.
  1. Results We present DynamicsPLM, a protein language model conditioned on ensembles of computationally generated conformations to derive state-aware representations.
- 摘要：Abstract Motivation Proteins change shape as they work, and these changing states control whether binding sites are exposed, signals are relayed, and catalysis proceeds. Most protein language models pair a sequence with a single structural snapshot, which can miss state-dependent features central to interaction, localization, and enzyme activity. Studies also indicate that many proteins assume multiple, functionally relevant shapes, motivating approaches that learn from this variability. Results We present DynamicsPLM, a protein language model conditioned on ensembles of computationally generated conformations to derive state-aware representations. DynamicsPLM improves predictive performance across protein–protein interaction, subcellular localization, enzyme classification, and metal-ion binding. On a widely used protein–protein interaction benchmark, it achieves a four-point accuracy gain over the strongest baseline. On a curated test set enriched for proteins with multiple conformational states, the margin increases to eleven points. These findings argue for a shift from static to dynamics-aware modeling, in which conformational variability is treated as informative. By elevating conformational state to a central element of machine learning in protein biology, this work advances modeling toward mechanisms that better reflect how proteins operate in cells and provides a route to actionable hypotheses about when and how binding, signaling, and catalysis occur. Availability and implementation Code, model weights, and inference scripts are available at https://github.com/kalifadan/DynamicsPLM (DOI: https://doi.org/10.5281/zenodo.17668302 )
- 链接：https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btag254/8669790?rss=1

#### Learning Drug Synergy through Environment-Conditioned Feature Modulation
- 日期：2026-05-05
- 作者：未提供
- 文章类型：未提供
- 研究问题：Abstract Motivation Drug combinations are crucial for overcoming resistance in cancer therapy.
- 发现/highlights：
  1. Although deep learning has achieved strong performance in synergy prediction, existing models often treat cell-specific features and paired drugs as a static background and fail to capture how the specific cell-drug environment dynamically modulates drug representations, thereby hindering the modeling of environment-specific synergistic effects.
  1. Results We propose Env-Syn, a framework for modeling drug-drug-cell interactions through Environment-Conditioned Feature Modulation, which incorporates a Residual Feature-wise Linear Modulation (R-FiLM) module to perform precise affine transformations on drug representations conditioned on paired drugs and cellular environments.
  1. Benchmark evaluations show that Env-Syn consistently outperforms state-of-the-art methods.
- 摘要：Abstract Motivation Drug combinations are crucial for overcoming resistance in cancer therapy. Although deep learning has achieved strong performance in synergy prediction, existing models often treat cell-specific features and paired drugs as a static background and fail to capture how the specific cell-drug environment dynamically modulates drug representations, thereby hindering the modeling of environment-specific synergistic effects. Results We propose Env-Syn, a framework for modeling drug-drug-cell interactions through Environment-Conditioned Feature Modulation, which incorporates a Residual Feature-wise Linear Modulation (R-FiLM) module to perform precise affine transformations on drug representations conditioned on paired drugs and cellular environments. Benchmark evaluations show that Env-Syn consistently outperforms state-of-the-art methods. Notably, the model exhibits exceptional generalization performance in rigorous inductive scenarios. It maintains high predictive accuracy for unseen drugs with AUROC and AUPRC exceeding 0.81 in the Leave-drug-out setting, and further demonstrates strong cross-dataset reliability by surpassing a recall of 0.7 on independent test set. Furthermore, among 15 novel predicted drug combinations, eight are directly supported by literature evidence. These results demonstrate that Env-Syn is an effective computational tool for drug synergy discovery. Availability The source code is available at https://github.com/AnQi-87/Env-Syn
- 链接：https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btag256/8669792?rss=1

#### FuFiHLA: A tool for Full-Field HLA typing from long-read data
- 日期：2026-05-05
- 作者：未提供
- 文章类型：未提供
- 研究问题：Abstract Motivation Allele typing for Human Leukocyte Antigen (HLA) genes has many important clinical applications.
- 发现/highlights：
  1. Popular short-read typing can only accurately distinguish alleles at the coding sequence level, which potentially limit our understanding of the effect of variants in non-coding region.
  1. Long read data has been proved to be useful in typing HLA alleles in full resolution, but only a few tools are publicly available and with significant limitations in practical application.
  1. Results We developed FuFiHLA, a lightweight open-source software, to type HLA alleles.
- 摘要：Abstract Motivation Allele typing for Human Leukocyte Antigen (HLA) genes has many important clinical applications. Popular short-read typing can only accurately distinguish alleles at the coding sequence level, which potentially limit our understanding of the effect of variants in non-coding region. Long read data has been proved to be useful in typing HLA alleles in full resolution, but only a few tools are publicly available and with significant limitations in practical application. Results We developed FuFiHLA, a lightweight open-source software, to type HLA alleles. Currently it supports typing alleles of six HLA genes (HLA-A, HLA-B, HLA-C, HLA-DRB1, HLA-DQA1, and HLA-DQB1) from long reads. Evaluation using 233 PacBio HiFi WGS samples from HPRC shows that FuFiHLA achieves 99.6% accuracy in the full field allele typing and QV as 51.8 for consensus allele sequence construction. Additional testing on four Nanopore R10 reads demonstrates slightly reduced accuracy in the fourth field. Availability FuFiHLA is available at https://github.com/jingqing-hu/FuFiHLA under MIT License
- 链接：https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btag231/8669788?rss=1

#### FourierDrug: a domain generalization framework for robust drug response prediction via frequency-space asymmetric attention
- 日期：2026-05-05
- 作者：未提供
- 文章类型：未提供
- 研究问题：Abstract Motivation Accurate prediction of drug response remains a major challenge in precision oncology, particularly at the single-cell level and in clinical settings, due to significant distribution shifts between preclinical models and real-world patient data.
- 发现/highlights：
  1. Existing approaches often rely on transfer learning from cell lines to target domains, but typically require access to target-domain data during training, which is frequently unavailable in practice.
  1. Results We propose FourierDrug, a novel domain generalization framework for robust drug response prediction.
  1. Given gene expression profiles, the model performs Fourier transformation to project features into the frequency domain and introduces an asymmetric attention mechanism that encourages drug-sensitive samples to form compact clusters while driving resistant samples to be more dispersed.
- 摘要：Abstract Motivation Accurate prediction of drug response remains a major challenge in precision oncology, particularly at the single-cell level and in clinical settings, due to significant distribution shifts between preclinical models and real-world patient data. Existing approaches often rely on transfer learning from cell lines to target domains, but typically require access to target-domain data during training, which is frequently unavailable in practice. Results We propose FourierDrug, a novel domain generalization framework for robust drug response prediction. Given gene expression profiles, the model performs Fourier transformation to project features into the frequency domain and introduces an asymmetric attention mechanism that encourages drug-sensitive samples to form compact clusters while driving resistant samples to be more dispersed. This design facilitates the learning of domain-invariant yet task-relevant representations. Extensive experiments demonstrate that FourierDrug effectively leverages diverse source domains and generalizes well to unseen cancer types. Notably, when evaluated on single-cell and patient-level prediction tasks, our method—trained solely on in vitro cell line data without access to target-domain data—consistently outperforms or matches state-of-the-art approaches. Availability and Implementation The source code and processed datasets are available at: https://github.com/hliulab/FourierDrug
- 链接：https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btag276/8669789?rss=1

### Nature Protocols

- 本期刊剩余论文为空。

### Nature methods

#### $${\bf{Micro}}{{\mathbb{S}}}{\bf{plit}}$$ Micro S plit：荧光显微镜数据的语义分离 / $${\bf{Micro}}{{\mathbb{S}}}{\bf{plit}}$$ Micro S plit : semantic unmixing of fluorescent microscopy data
- 日期：2026-05-05
- 作者：Ashesh Ashesh, Federico Carrara, Igor Zubarev, Vera Galinova, Melisande Croft, Melissa Pezzotti, Daozheng Gong, Francesca Casagrande, Elisa Colombo, Stefania Giussani, Elena Restelli, Eugenia Cammarota, Juan Manuel Battagliotti, Nikolai Klena, Moises Di Sante, Raghabendra Adhikari, Daniel Feliciano, Gaia Pigino, Elena Taverna, Oliver Harschnitz, Nicola Maghelli, Norbert Scherer, Damian Edward Dalle Nogare, Joran Deschamps, Francesco Pasqualini, Florian Jug
- 文章类型：未提供
- 研究问题：$${\rm{Micro}}{\mathbb{S}}{\rm{plit}}$$ M i c o Split 是一种计算分离方法，用于每个成像通道最多四个结构的多重荧光成像
- 发现/highlights：
  1. $${\bf{Micro}}{{\mathbb{S}}}{\bf{plit}}$$ Micro S plit：荧光显微镜数据的语义分离
  1. $${\rm{Micro}}{\mathbb{S}}{\rm{plit}}$$ M i c o Split 是一种计算分离方法，用于每个成像通道最多四个结构的多重荧光成像
- 摘要：$${\rm{Micro}}{\mathbb{S}}{\rm{plit}}$$ M i c o Split 是一种计算分离方法，用于每个成像通道最多四个结构的多重荧光成像
- 链接：https://www.nature.com/articles/s41592-026-03082-1
