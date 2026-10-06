# 文献追踪报告

- 时间范围：2026-10-06 ~ 2026-10-06
- 目标期刊数：10
- 本周新论文数：6
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

#### STiLE: Automated Tissue Microarray Dearraying for Spatial Transcriptomics
- 日期：2026-10-06
- 作者：未提供
- 文章类型：Journal Article
- 关键词：clustering, dearraying, spatial transcriptomics, tissue microarray
- 研究问题：Tissue microarrays (TMAs) enable high-throughput spatial transcriptomic profiling of dozens of tissue cores on a single slide.
- 核心发现：
  1. However, existing dearraying methods operate on histological images and do not support the coordinate-based outputs of spatial transcriptomics platforms.
  1. Therefore, task of assigning cells to their respective cores (dearraying) remains a manual bottleneck.
  1. We present STiLE, a tool for automated TMA dearraying that operates solely on cell centroid coordinates.
- 摘要：Tissue microarrays (TMAs) enable high-throughput spatial transcriptomic profiling of dozens of tissue cores on a single slide. However, existing dearraying methods operate on histological images and do not support the coordinate-based outputs of spatial transcriptomics platforms. Therefore, task of assigning cells to their respective cores (dearraying) remains a manual bottleneck. We present STiLE, a tool for automated TMA dearraying that operates solely on cell centroid coordinates. By eliminating dependence on image data, STiLE is robust to artefacts such as variable staining quality and uneven illumination. The algorithm combines connectivity-based component detection, density-based clustering (HDBSCAN), component-guided cluster merging, and optional grid-based peak detection. Validation on seven public TMA samples (50-150 cores, three platforms) achieved ARI > 0.99, while systematic benchmarking on 396 synthetic datasets with realistic artefacts demonstrated consistently robust performance (mean ARI = 0.992). STiLE accepts standard formats (AnnData, CSV) and is platform-agnostic, supporting diverse platforms including Vizgen MERSCOPE, 10x Xenium, and NanoString CosMx. An interactive Streamlit interface enables parameter tuning, visual inspection, and region-based processing for large slides. Availability and Implementation: https://pypi.org/project/stile; source at https://github.com/Huang-AI4Medicine-Lab/stile Supplementary Information: Supplementary data are available at Bioinformatics online.
- 链接：https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btag572/8868947?rss=1

#### RAFA: RNA all-atom structure reconstruction from sparse anchor coordinates
- 日期：2026-10-06
- 作者：未提供
- 文章类型：Journal Article
- 关键词：RNA structure reconstruction, all-atom modelling, coarse-grained RNA, fragment assembly, structural bioinformatics
- 研究问题：SUMMARY: We present RAFA, a C ++ command-line tool for RNA all-atom structure reconstruction from sparse or partial coordinates.
- 核心发现：
  1. RAFA targets settings in which coarse-grained modelling, low-resolution fitting, or partial experimental interpretation provides RNA anchor atoms but not a complete atomic model.
  1. The method retrieves experimentally observed 3-5 nt all-atom RNA fragments, fits them to local anchors, combines overlapping fragment-derived coordinate estimates by weighted consensus, and routes sparse and rich inputs through distinct reconstruction paths.
  1. In an independent RNA3DB train/test evaluation, no library-test pair exceeded 80% global sequence identity.
- 摘要：SUMMARY: We present RAFA, a C ++ command-line tool for RNA all-atom structure reconstruction from sparse or partial coordinates. RAFA targets settings in which coarse-grained modelling, low-resolution fitting, or partial experimental interpretation provides RNA anchor atoms but not a complete atomic model. The method retrieves experimentally observed 3-5 nt all-atom RNA fragments, fits them to local anchors, combines overlapping fragment-derived coordinate estimates by weighted consensus, and routes sparse and rich inputs through distinct reconstruction paths. In an independent RNA3DB train/test evaluation, no library-test pair exceeded 80% global sequence identity. RAFA achieved lower all-atom root-mean-square deviation (RMSD) values than Arena in 73.3% of target-mode comparisons, with the largest gains in input modes with the fewest structural constraints.

AVAILABILITY AND IMPLEMENTATION: RAFA is available at https://github.com/wangleiofficial/RAFA and archived at https://doi.org/10.5281/zenodo.20951205.

SUPPLEMENTARY INFORMATION: Supplementary data are available at Bioinformatics online.
- 链接：https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btag746/8869022?rss=1

#### MediNet: Simplifying Federated and Privacy-Preserving AI Deployment in Healthcare
- 日期：2026-10-06
- 作者：未提供
- 文章类型：Journal Article
- 研究问题：The application of Artificial Intelligence and Deep Learning (DL) in healthcare is increasingly feasible in principle, yet remains inaccessible in practice for most clinical institutions.
- 核心发现：
  1. Beyond the well-known challenge of data privacy regulations that prevent centralization of patient records, two further barriers limit adoption.
  1. First, deploying a federated learning infrastructure requires substantial technical expertise: configuring distributed training environments, implementing privacy-preserving mechanisms such as Differential Privacy (DP), and managing secure inter-institutional communication demands specialized knowledge that most healthcare organizations do not possess.
  1. Second, designing and configuring DL models (selecting architectures, tuning hyperparameters, interpreting results) currently requires machine learning expertise that clinical professionals, including researchers and physicians, typically lack.
- 摘要：Abstract Motivation The application of Artificial Intelligence and Deep Learning (DL) in healthcare is increasingly feasible in principle, yet remains inaccessible in practice for most clinical institutions. Beyond the well-known challenge of data privacy regulations that prevent centralization of patient records, two further barriers limit adoption. First, deploying a federated learning infrastructure requires substantial technical expertise: configuring distributed training environments, implementing privacy-preserving mechanisms such as Differential Privacy (DP), and managing secure inter-institutional communication demands specialized knowledge that most healthcare organizations do not possess. Second, designing and configuring DL models (selecting architectures, tuning hyperparameters, interpreting results) currently requires machine learning expertise that clinical professionals, including researchers and physicians, typically lack. Existing federated learning frameworks address the infrastructure problem but impose a steep learning curve that effectively excludes non-specialized users. A solution that abstracts this complexity, enabling clinicians and biomedical researchers to design, launch, and monitor federated training processes without programming or machine learning expertise, remains absent from the field. Results To address existing limitations, we introduce MediNet, a comprehensive server–client Federated learning (FL) platform that allows hospitals and research centers to train Machine Learning (ML) and DL models without moving or exposing sensitive data. It offers an intuitive web-based environment that simplifies FL, enabling users to easily select the model and define training criteria while administrators manage permissions and datasets, ensuring granular and autonomous data control. The system automatically constructs and generates the underlying technical configuration (e.g., Python/FL scripts) according to the parameters specified in the GUI. It then orchestrates the secure federated rounds and provides real-time monitoring, fully encapsulating the complexity of deployment and security. MediNet is built upon PyTorch as its primary framework, chosen for its robustness in DL model development along with its Differential Privacy (DP) libraries. Flower (Beutel et al., 2020) is used as the federated orchestration system. These underlying technologies are internal pillars of MediNet, essential for ensuring robustness, functionality, and strict adherence to privacy principles. Availability and implementations The general information page for the MediNet software is available at https://isglobal-brge.github.io/MediNet . The MediNet software and its complementary tools are fully available under the MIT license on GitHub. The MediNetHub and MediNetNode code can be found on https://github.com/isglobal-brge/MediNetHub and https://github.com/isglobal-brge/MediNetNode
- 链接：https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btag742/8868964?rss=1

### Nature Protocols

#### T cell immunomonitoring: a comparative analysis of traditional and novel methods to quantify and characterize human antigen-specific T cells
- 日期：2026-10-06
- 作者：未提供
- 文章类型：未提供
- 研究问题：We present a comparative analysis review of traditional and cutting-edge technologies for clinical profiling of antigen-specific T cells, highlighting their principles, applications, benefits and limitations and the need for assay harmonization and standardization
- 核心发现：
  1. T cell immunomonitoring: a comparative analysis of traditional and novel methods to quantify and characterize human antigen-specific T cells
  1. We present a comparative analysis review of traditional and cutting-edge technologies for clinical profiling of antigen-specific T cells, highlighting their principles, applications, benefits and limitations and the need for assay harmonization and standardization
- 摘要：We present a comparative analysis review of traditional and cutting-edge technologies for clinical profiling of antigen-specific T cells, highlighting their principles, applications, benefits and limitations and the need for assay harmonization and standardization
- 链接：https://www.nature.com/articles/s41596-026-01453-8

### Nature methods

#### Flexible discovery of disease-associated tissue structures
- 日期：2026-10-06
- 作者：未提供
- 文章类型：未提供
- 研究问题：Identification of disease-associated patterns in spatial molecular data is challenging.
- 核心发现：
  1. We introduce variational inference-based microniche analysis (VIMA), a deep learning-based statistical method that can identify such patterns without requiring annotation of the data into cell types or niches.
  1. VIMA has high power and fidelity across a range of spatial molecular technologies and diseases
  1. Flexible discovery of disease-associated tissue structures
- 摘要：Identification of disease-associated patterns in spatial molecular data is challenging. We introduce variational inference-based microniche analysis (VIMA), a deep learning-based statistical method that can identify such patterns without requiring annotation of the data into cell types or niches. VIMA has high power and fidelity across a range of spatial molecular technologies and diseases
- 链接：https://www.nature.com/articles/s41592-026-03242-3

#### Accurate and well-powered case–control analysis of spatial molecular data
- 日期：2026-10-06
- 作者：未提供
- 文章类型：未提供
- 研究问题：VIMA uses deep-learning architecture to identify differentially enriched features within spatial datasets
- 核心发现：
  1. Accurate and well-powered case–control analysis of spatial molecular data
  1. VIMA uses deep-learning architecture to identify differentially enriched features within spatial datasets
- 摘要：VIMA uses deep-learning architecture to identify differentially enriched features within spatial datasets
- 链接：https://www.nature.com/articles/s41592-026-03236-1
