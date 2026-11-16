## Table 2 and Section 3.2 inline values: maternal smoking and birth weight (MASS::birthwt)
source("00_setup.R")
data(birthwt, package = "MASS")

smokers <- birthwt$bwt[birthwt$smoke == 1]
nonsmokers <- birthwt$bwt[birthwt$smoke == 0]

n1 <- length(smokers)
n2 <- length(nonsmokers)
mean_diff <- mean(nonsmokers) - mean(smokers)
pooled_sd <- sqrt(((n1 - 1) * var(smokers) + (n2 - 1) * var(nonsmokers)) / (n1 + n2 - 2))
se_diff <- pooled_sd * sqrt(1/n1 + 1/n2)
effect_size <- mean_diff / pooled_sd
t_stat <- mean_diff / se_diff
n_eff <- (n1 * n2) / (n1 + n2)
df <- n1 + n2 - 2

p_trad <- 2 * pt(-abs(t_stat), df = df)
c_values <- c(0.1, 0.2, 0.3)
p_uncertainty <- sapply(c_values, function(c) 2 * pt(-abs(t_stat / sqrt(1 + n_eff * c^2)), df = df))

equiv_bound <- 0.2 * pooled_sd
p_tost <- max(pt(-(mean_diff + equiv_bound) / se_diff, df = df),
              pt(-(equiv_bound - mean_diff) / se_diff, df = df))

table2 <- data.table(
  Method = c("Traditional t-test", paste0("Uncertainty-adjusted (c = ", c_values, ")"), "TOST (delta = 0.2 sigma)"),
  p_value = c(p_trad, p_uncertainty, p_tost),
  MDE_finite = c(NA, qnorm(0.975) * sqrt(1/n_eff + c_values^2), NA)
)
fwrite(table2, file.path(out_dir, "table2_birthwt.csv"))

summary_birthwt <- data.table(
  n_nonsmokers = n2, mean_nonsmokers = mean(nonsmokers), sd_nonsmokers = sd(nonsmokers),
  n_smokers = n1, mean_smokers = mean(smokers), sd_smokers = sd(smokers),
  mean_diff = mean_diff, pooled_sd = pooled_sd, cohen_d = effect_size, t = t_stat, n_eff = n_eff
)
fwrite(summary_birthwt, file.path(out_dir, "birthwt_summary.csv"))
print(table2); print(summary_birthwt)
