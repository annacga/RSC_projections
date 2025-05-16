# RSC_projections

This repository accompanies the publication:

Gianatti M.*, Garvert A.*, Lenkey N., Ebbesen N., Hennestad E., Vervaeke K.
Multiple long-range projections convey position information to the agranular retrosplenial cortex
Cell Reports, Volume 42, Issue 9, September 26, 2023
(* indicates equal contribution)

🔁 Reproducing Figures

To reproduce Figures 1–3, run the following scripts in the Figure/ directory:

create_figure_1.m
create_figure_2.m
create_figure_3.m

📄 Data Reference

For a description of the variables used in the figure scripts, refer to:

sData_template.m

🧪 Advanced Analyses

All advanced analysis methods are organized within the analysis/ folder:

🔬 Cell Classification
Located in: analysis/cellClassification/

Based on generalized linear models (GLMs)
Method adapted from Hardcastle et al., 2017
Detailed in the Methods section of the publication
🧠 Bayesian Decoding
Located in: analysis/decoding/

Used to predict position on the wheel using Bayesian inference
ℹ️ Information Metrics
Located in: analysis/skaggs/

Calculation of the Skaggs information score to quantify spatial coding
