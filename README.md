
# 🧠 Long-Range Position Signals to the Retrosplenial Cortex

This repository accompanies the publication:

Gianatti M.\*, Garvert A.\*, Lenkey N., Ebbesen N., Hennestad E., Vervaeke K.
Multiple long-range projections convey position information to the agranular retrosplenial cortex
Cell Reports, Volume 42, Issue 9, September 26, 2023
(* indicates equal contribution)

## ⚙️ Setup Instructions

### MATLAB Requirements
- **Recommended Version**: MATLAB R2018b (Version 9.5)  
- **Required Toolboxes**:
  - Statistics and Machine Learning Toolbox (v11.4)
  - Signal Processing Toolbox (v8.1)
  - Optimization Toolbox (v8.2)

## 🔁 Reproducing Figures

### To reproduce Figures 1–3, run the following scripts in the Figure/ directory:

- create_all_figures.m

### 🧩 To generate figures individually:
You can run any of the following scripts in the `Figure/` directory:
- `create_figure_1.m`
- `create_figure_2.m`
- `create_figure_3.m`

⚠️ **Before running individual figure scripts, make sure to first run the following setup scripts in the same directory:**

```matlab
load_all_data()           % Loads the full sData structure. See 'sData_template.m' for details.
load_LNP_results()        % Required for Figures 1, 2 & 3. 
                          % If unavailable, run: analysis/cellClassification/main_cell_classification.m

load_decoding_results()   % Required for Figures 1 & 3.
                          % If unavailable, run: analysis/decoding/decoding_main.m

load_skaggs_results()     % Required for Figure 3.
                          % If unavailable, run: analysis/skaggs/calculate_skaggs.m

helper.createRMaps        % Required for Figures 1, 2 & 3.
                          % Generates rate maps (heatmaps) for all cells.
```
## 📄 Data Reference

### For a description of the variables used in the figure scripts, refer to:

sData_template.m

## 🧪 Advanced Analyses

### Detailed methodology is described in the publication’s Methods section.
### All advanced analysis methods are organized within the analysis/ folder:

### 🔬 Cell Classification
- **Location:** `analysis/cellClassification/`  
- Based on **generalized linear models (GLMs)** adapted from Hardcastle et al., 2017.  
- Axons are classified by comparing model performance against a fixed mean firing rate baseline using cross-validation and statistical testing.  
- Axons not outperforming the baseline are considered **not tuned**; others are classified according to which variables they encode (position, speed, acceleration, or licking).  
- Multiple tuning is assigned if no single model significantly outperforms others.  
- Classification significance and chance levels are estimated through permutation testing.  

### 🧠 Bayesian Decoding
- **Location:** `analysis/decoding/`  
- Predicts the animal's position on the wheel using Bayesian inference based on axonal activity.  
- Assumes statistical independence of axonal signals and models firing rates with a Poisson distribution.  
- Employs cross-validation and optimized hyperparameters to minimize decoding error.  
- Decoding error quantified as mean distance between predicted and actual positions.  
- Chance decoding error estimated through random shuffling of position labels.  

### ℹ️ Skaggs Information Score
- **Location:** `analysis/skaggs/`  
- Calculates the Skaggs spatial information score (Skaggs et al., 1993) to quantify spatial coding based on calcium activity maps, adapted for ΔF/F signals using a scaling factor according to Climer et al., 2021.  



