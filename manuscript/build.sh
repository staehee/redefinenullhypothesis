#!/usr/bin/env bash
# Build everything from the single source manuscript/redefinenullhypothesis_stats.qmd
#   - PDF + DOCX (MDPI Stats submission)
#   - submission/: manuscript.docx, manuscript.pdf, supplementary_code.zip
#   - manuscript/arxiv_submission/ + redefinenullhypothesis_arxiv.zip (pdfLaTeX source for arXiv)
# Usage: bash manuscript/build.sh   (from the repository root or anywhere)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC=redefinenullhypothesis_stats
cd "$ROOT/manuscript"

quarto render "$SRC.qmd"            # renders pdf and docx

# MDPI submission files
rm -rf "$ROOT/submission" && mkdir -p "$ROOT/submission"
cp "$SRC.docx" "$ROOT/submission/manuscript.docx"
cp "$SRC.pdf"  "$ROOT/submission/manuscript.pdf"
(cd "$ROOT" && zip -qr submission/supplementary_code.zip code -x 'code/output/*')

# arXiv package (same source, LaTeX output)
rm -rf arxiv_submission redefinenullhypothesis_arxiv.zip
mkdir -p arxiv_submission/figures
cp "${SRC}_files/figure-pdf/"*.pdf arxiv_submission/figures/
{ echo '\pdfoutput=1'; sed "s|${SRC}_files/figure-pdf/|figures/|g" "$SRC.tex"; } > arxiv_submission/redefinenullhypothesis_arxiv.tex
(cd arxiv_submission && zip -qr ../redefinenullhypothesis_arxiv.zip .)

echo "Built: submission/{manuscript.docx,manuscript.pdf,supplementary_code.zip}, manuscript/redefinenullhypothesis_arxiv.zip"
