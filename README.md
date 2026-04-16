# PD regression with 82 subjects

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)


> 本项目对应论文：王敬, 王朋威, 谢晓, 韩红芳. "基于贝叶斯优化的支持向量回归预测帕金森病严重程度研究." 信阳师范大学学报(自然科学版) 38, no. 3 (2025): 297-303.

This project contains code and data for regression analysis on Parkinson's disease (PD) using data from 82 subjects.

## About

This repository includes MATLAB scripts for performing regression analysis on PD data, as well as visualization tools and results. The main components are:

- `main.m`: Main script to run the analysis
- `regression_with_BayesOpt.m`: Performs regression with Bayesian optimization
- `calculate_metrics.m`: Calculates performance metrics
- `plot_*.m` files: Various plotting functions
- `data.mat` and `data_fMRI.mat`: Data files
- `feature_names.txt`: Contains names of features used in the analysis
- `MNI152_T1_2mm_Brain.nii.gz`: MNI152 2mm brain template
- `MNI152_T1_2mm_Brain_Mask.nii.gz`: Brain mask in MNI152 2mm space
- `Schaefer2018_100Parcels_7Networks_w_SubCortAtlas_MNI152_2mm.nii.gz`: Schaefer 2018 brain atlas with 100 parcels and 7 networks in MNI152 2mm space

## Usage

To run the analysis:

1. Ensure you have MATLAB installed
2. Clone this repository
3. Open MATLAB and navigate to the project directory
4. Run `main.m`

## Results

The analysis generates several result figures:

### 1. Bayesian Optimization Model
<img src="figures/regression_with_BayesOpt.svg" width="70%">

### 2. MDS-UPDRS Actual vs Predicted Total Scores Scatter Plot
<img src="figures/plot_scatter.svg" width="70%">

### 3. Weight Bar Chart
<img src="figures/plot_bar.svg" width="70%">

### 4. ROI Visualization
<img src="figures/plot_ROI.svg" width="70%">

These figures provide visual representations of the regression analysis results and can be found in the `figures/` directory.

## Acknowledgements

This project uses the `tight_subplot` function by Pekka Kumpulainen, available on [MATLAB File Exchange](https://www.mathworks.com/matlabcentral/fileexchange/27991-tight_subplot-nh-nw-gap-marg_h-marg_w).

## Citation

If you use this code in your research, please cite:

```bibtex
@article{wang2025bayesian,
  title={基于贝叶斯优化的支持向量回归预测帕金森病严重程度研究},
  author={王敬, 王朋威, 谢晓, 韩红芳},
  journal={信阳师范大学学报(自然科学版)},
  volume={38},
  number={3},
  pages={297--303},
  year={2025}
}
```

## Contact
Jing Wang (wangjing@xynu.edu.cn)