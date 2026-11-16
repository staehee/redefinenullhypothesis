## Common setup: packages, core functions, output directory
## Sourced by every numbered script. Run scripts from the code/ directory.
library(data.table)
library(magrittr)
library(ggplot2)
library(scales)

out_dir <- "output"
dir.create(out_dir, showWarnings = FALSE)

# Reverse log transformation for p-value axes
reverselog_trans <- function(base = exp(1)) {
  trans <- function(x) -log(x, base)
  inv <- function(x) base^(-x)
  trans_new(paste0("reverselog-", format(base)), trans, inv,
            log_breaks(base = base),
            domain = c(1e-100, Inf))
}

# Uncertainty-adjusted p-value: z shrunk by sqrt(1 + n c^2)
CalP_uncertainty <- function(z, n, c) {
  zval <- z / sqrt(1 + n * c^2)
  2 * (1 - pnorm(abs(zval)))
}

# Uncertainty scaling for multiple testing: c_m = c * m^b
cfun <- function(base, m, b) {
  10^(log10(base) + b * log10(m))
}

# Required sample size (Section 4.2), one-tail approximation:
#   d = z_{1-a/2} sqrt(1/n + c^2) + z_{1-b} sqrt(1/n)
# Requires z_{1-a/2} > z_{1-b}; infeasible (NA) when d <= z_{1-a/2} c
SampleNew <- function(d, c, alpha = 0.05, beta = 0.2) {
  za <- qnorm(1 - alpha/2)
  zb <- qnorm(1 - beta)
  A <- za^2 - zb^2
  s <- (-d * zb + sqrt(pmax(d^2 * zb^2 + A * (d^2 - za^2 * c^2), 0))) / A
  ifelse(d <= za * c, NA, 1 / s^2)
}

theme_set(theme_bw(base_size = 12))
