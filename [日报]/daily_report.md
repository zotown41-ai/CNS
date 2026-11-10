# 文献追踪报告

- 时间范围：2026-11-10 ~ 2026-11-10
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

#### PFM: perturbed flow matching for structure-based drug design
- 日期：2026-11-10
- 作者：未提供
- 文章类型：Journal Article
- 研究问题：Target-specific 3D molecular generation is a promising approach for structure-based drug design.
- 核心发现：
  1. However, existing diffusion-based methods are generally restricted to marginal distributions with closed-form solutions, limiting the flexibility of generative process design, especially for the forward noising process.
  1. As a result, these methods may be less effective in modeling the complex distributions underlying pocket-conditioned molecular generation.
  1. RESULTS: We develop Perturbed Flow Matching (PFM), a flow-matching-based framework for protein pocket-conditioned 3D molecular generation.
- 摘要：Abstract Motivation Target-specific 3D molecular generation is a promising approach for structure-based drug design. However, existing diffusion-based methods are generally restricted to marginal distributions with closed-form solutions, limiting the flexibility of generative process design, especially for the forward noising process. As a result, these methods may be less effective in modeling the complex distributions underlying pocket-conditioned molecular generation. Results We develop Perturbed Flow Matching (PFM), a flow-matching-based framework for protein pocket–conditioned 3D molecular generation. PFM employs a perturbed conditional probability path that incorporates both pocket binding-site information and coupled atom type–coordinate information, enabling more effective generation of molecules in protein binding environments. On CrossDocked2020, PFM achieves competitive structural quality and the best average Vina score among the evaluated unguided methods (-7.12); PFM-G further improves the score to -8.70 with tailored classifier-free guidance. Experiments on additional molecular datasets further confirm the effectiveness and generalizability of the proposed framework. Availability and implementation https://github.com/kurisu92725/PFM
- 链接：https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btag811/9027072?rss=1

#### MIRAGE-DTA: conflict-aware multimodal evidence arbitration for drug–target affinity prediction
- 日期：2026-11-10
- 作者：未提供
- 文章类型：Journal Article
- 关键词：distribution shift, drug–target affinity prediction, missing modalities, multimodal information fusion, reliability calibration, retrieval-augmented learning
- 研究问题：Multimodal drug-target affinity (DTA) models can incorporate molecular, protein, assay and textual evidence whose availability and reliability vary under missing modalities, cold-start entities and assay distribution shift.
- 核心发现：
  1. RESULTS: We present MIRAGE-DTA, a reliability-oriented evidence-arbitration layer that complements DTA encoders by keeping current-sample and training-set retrieval evidence as two explicit chains, carrying modality masks into fusion, retrieving training-only neighbors, and resolving disagreement with an interaction gate and validation-selected anchor.
  1. Across BindingDB_Kd, DAVIS, KIBA and a 2010-2024 CHEMBL_ASSAY benchmark with 35,238 interactions, experiments tested cold-start, missing-modality and assay/temporal shift settings.
  1. Under 35% sequence/text missingness on CHEMBL_ASSAY, 10-seed paired evaluation showed that MIRAGE-DTA reduced expected calibration error relative to late fusion by 0.0524, 0.0923 and 0.1018 on assay-cold, target-cold and temporal splits.
- 摘要：Abstract Motivation Multimodal drug–target affinity (DTA) models can incorporate molecular, protein, assay and textual evidence whose availability and reliability vary under missing modalities, cold-start entities and assay distribution shift. Results We present MIRAGE-DTA, a reliability-oriented evidence-arbitration layer that complements DTA encoders by keeping current-sample and training-set retrieval evidence as two explicit chains, carrying modality masks into fusion, retrieving training-only neighbors, and resolving disagreement with an interaction gate and validation-selected anchor. Across BindingDB_Kd, DAVIS, KIBA and a 2010–2024 CHEMBL_ASSAY benchmark with 35,238 interactions, experiments tested cold-start, missing-modality and assay/temporal shift settings. Under 35% sequence/text missingness on CHEMBL_ASSAY, 10-seed paired evaluation showed that MIRAGE-DTA reduced expected calibration error relative to late fusion by 0.0524, 0.0923 and 0.1018 on assay-cold, target-cold and temporal splits. Risk at 80% coverage was significantly lower on target-cold and temporal splits and numerically lower on assay-cold. A complementary complete-evidence direct-pChEMBL regression analysis also showed lower RMSE for the two-branch model than for current-only and retrieval-only regressors across assay-cold, target-cold and temporal splits. Ranking remained broadly competitive, with a modest trade-off on the temporal split, indicating that the principal benefit lies in calibrated and selective prediction under incomplete or shifted evidence. Shortcut audits quantified neighbor-overlap effects and showed that temporal retrieval was not driven by repeated compounds or near-duplicate scaffolds. Availability and implementation Source code is available at https://github.com/wushen1103-collab/mirage_drug_miniprototype and archived on Zenodo at https://doi.org/10.5281/zenodo.22695984 ; data come from public sources
- 链接：https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btag812/9027069?rss=1

#### DTBNet: Multimodal 3D Geometric Perception with Hierarchical Attention for Robust Drug–Target Interaction and Binding Affinity Prediction
- 日期：2026-11-10
- 作者：未提供
- 文章类型：Journal Article
- 关键词：deep learning, drug discovery, hierarchical attention, multimodal geometric perception
- 研究问题：Accurate prediction of drug-target interactions (DTIs) and binding affinity (DTA) constitutes a core challenge in accelerating drug discovery.
- 核心发现：
  1. While existing computational methods have made progress, most models struggle to capture critical physicochemical interactions in 3D space due to reliance on 1D sequences or 2D graph structures, and exhibit limited generalization in cold-start scenarios.
  1. This study proposes DTBNet, a unified prediction framework integrating multimodal geometric perception and hierarchical attention.
  1. The framework constructs heterogeneous embeddings combining local chemical details with global biological information by incorporating protein 3D geometric features and multilevel drug representations.
- 摘要：MOTIVATION: Accurate prediction of drug-target interactions (DTIs) and binding affinity (DTA) constitutes a core challenge in accelerating drug discovery. While existing computational methods have made progress, most models struggle to capture critical physicochemical interactions in 3D space due to reliance on 1D sequences or 2D graph structures, and exhibit limited generalization in cold-start scenarios. This study proposes DTBNet, a unified prediction framework integrating multimodal geometric perception and hierarchical attention. The framework constructs heterogeneous embeddings combining local chemical details with global biological information by incorporating protein 3D geometric features and multilevel drug representations. During cross-modal interaction, atom-residue cross-attention first captures pair-specific local associations, followed by group-level multi-head self-attention that integrates complementary chemical-semantic, global structural, and local geometric interaction representations.

RESULTS: Experiments on benchmark datasets (Davis, KIBA, PDBBind) demonstrate that compared with the optimal baseline models, DTBNet achieves up to 19.8% reduction in mean squared error and 8.0% improvement in Pearson correlation coefficient, maintaining optimal performance in drug cold-start, target cold-start, and completely novel pairing scenarios, showcasing robust cross-domain adaptability. Independent validation on GPCR targets achieves RMSE 0.783, confirming real-world applicability. Visualization analyses reveal DTBNet precisely identifies interaction sites between key transmembrane helical domain residues and drug aromatic rings, with attention distribution highly consistent with experimentally resolved binding conformations. These results establish DTBNet as a new performance benchmark through 3D geometric perception and dynamic attention mechanisms, providing interpretable molecular insights for structure-based rational drug design and demonstrating broad potential in virtual screening and target discovery.

AVAILABILITY: The source code and data are available at https://github.com/wyx2012/DTB_Net.

SUPPLEMENTARY INFORMATION: Supplementary data are available at Bioinformatics online.
- 链接：https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btag809/9027070?rss=1

#### CellSavior: an open-source framework for improved cell calling in targeted single-cell DNA sequencing
- 日期：2026-11-10
- 作者：未提供
- 文章类型：Journal Article
- 研究问题：Single-cell DNA sequencing (scDNA-seq) has emerged as a key approach for studying complex genomic variation, including tumor heterogeneity.
- 核心发现：
  1. Despite its increasing commercial availability, exemplified by the Tapestri platform, analytical reproducibility remains limited due to reliance on proprietary and non-transparent pipelines.
  1. Among preprocessing steps, cell calling is particularly critical, as it determines which barcodes correspond to true cells rather than background noise and directly shapes all downstream analyses.
  1. However, existing methods typically rely on empirical thresholding and exhibit inconsistent performance across datasets.
- 摘要：MOTIVATION: Single-cell DNA sequencing (scDNA-seq) has emerged as a key approach for studying complex genomic variation, including tumor heterogeneity. Despite its increasing commercial availability, exemplified by the Tapestri platform, analytical reproducibility remains limited due to reliance on proprietary and non-transparent pipelines. Among preprocessing steps, cell calling is particularly critical, as it determines which barcodes correspond to true cells rather than background noise and directly shapes all downstream analyses. However, existing methods typically rely on empirical thresholding and exhibit inconsistent performance across datasets. These limitations underscore the need for a robust and generalizable cell calling framework for reliable scDNA-seq analysis.

RESULTS: We developed CellSavior, an open-source cell calling algorithm with an integrated downstream pipeline that produces standardized outputs. CellSavior employs an ensemble clustering strategy across multiple distance metrics, combined with confidence-weighted merging, to generate a consensus classification that reduces bias and improves robustness. Across 33 public and in-house single-cell DNA sequencing datasets, CellSavior recapitulated cell annotations generated by commercial software (CellFinder) in 31 cases (93.9%). In the remaining discordant cases, CellSavior yielded more biologically interpretable annotations, rescuing previously undetected clusters enriched for key hotspot genomic alterations.

AVAILABILITY: The source code for CellSavior is freely available at https://github.com/dauer-tgilab/CellSavior; DOI: https://doi.org/10.5281/zenodo.22744146.

SUPPLEMENTARY INFORMATION: Supplementary data are available at Bioinformatics online.
- 链接：https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btag808/9027071?rss=1

### Nature Protocols

- 本期刊剩余论文为空。

### Nature methods

#### In situ profiling of plasma cell clonality with image-based single-cell transcriptomics
- 日期：2026-11-10
- 作者：未提供
- 文章类型：未提供
- 研究问题：BCR-MERFISH enables tracking of plasma cell clones by combining V gene-specific detection with spatial transcriptomics
- 核心发现：
  1. In situ profiling of plasma cell clonality with image-based single-cell transcriptomics
  1. BCR-MERFISH enables tracking of plasma cell clones by combining V gene-specific detection with spatial transcriptomics
- 摘要：BCR-MERFISH enables tracking of plasma cell clones by combining V gene-specific detection with spatial transcriptomics
- 链接：https://www.nature.com/articles/s41592-026-03296-3
