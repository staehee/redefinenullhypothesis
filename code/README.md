# Reproducibility code

R scripts that reproduce every table, figure, and in-text number in
`manuscript/redefinenullhypothesis_stats.qmd` ("Redefining the Null Hypothesis", Kim & Shin).

## How to run

```bash
cd code
Rscript run_all.R        # about 1 minute
```

`run_all.R` runs the numbered scripts in order. Each script can also be run alone from
the `code/` directory (`Rscript 01_table1_typeI.R`); all of them `source("00_setup.R")`.
Outputs (CSV and vector PDF) are written to `code/output/`, together with `sessionInfo.txt`.

Required packages: `data.table`, `magrittr`, `ggplot2`, `scales`, `MASS`.

The manuscript itself (PDF, DOCX, and the arXiv LaTeX package) is built from the single
source `manuscript/redefinenullhypothesis_stats.qmd` with `bash manuscript/build.sh`
(requires Quarto, TinyTeX/TeX Live, and additionally `knitr`, `kableExtra`, `flextable`).

## Scripts

| Script | Reproduces | Seed | Output |
|---|---|---|---|
| `00_setup.R` | Packages and core functions (`CalP_uncertainty`, `cfun`, `SampleNew`) | – | – |
| `01_table1_typeI.R` | Table 1 (rejection rates, 10,000 reps) and Section 3.1.1 numbers | 2024 | `table1_typeI.csv` |
| `02_fig1_3_methods.R` | Figures 1–3 (deterministic) | – | `fig1_*.pdf`, `fig2_*.pdf`, `fig3_*.pdf` |
| `03_fig4_power.R` | Figure 4 (power, 5,000 reps) | 2024 | `fig4_power.csv/.pdf` |
| `04_table2_birthwt.R` | Table 2 and Section 3.2 numbers (`MASS::birthwt`) | – | `table2_birthwt.csv`, `birthwt_summary.csv` |
| `05_fig5_tost.R` | Figure 5 and Section 3.3 numbers (3,000 reps) | 2024 | `fig5_tost.csv/.pdf` |
| `06_fig6_samplesize.R` | Figure 6 (corrected sample size formula) and power check of the formula (50,000 reps) | 2024 | `fig6_samplesize.pdf`, `samplesize_verification.csv` |
| `07_fig7_multiple.R` | Figure 7 and Section 5.3 number (deterministic) | – | `fig7_multiple.pdf`, `multiple_preq.csv` |

Each simulation script calls `set.seed(2024)` immediately before its simulation, matching
the corresponding chunk in the manuscript source, so the numbers are identical to those in
the rendered manuscript.
