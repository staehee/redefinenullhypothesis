## Figure 6: required sample size (corrected formula, Section 4.2)
## plus simulation check that the formula delivers 80% power
source("00_setup.R")

sn <- CJ(d = seq(0.05, 1, by = 0.001), c = c(0, 0.01, 0.05, 0.1, 0.2))
sn[, N := SampleNew(d, c)]

fig6 <- ggplot(sn[N <= 50000 & !is.na(N)], aes(d, N, colour = factor(c))) +
  geom_line(linewidth = 0.8) +
  labs(color = expression(italic(c))) +
  scale_y_log10("Required sample size", breaks = c(10, 100, 1000, 10000)) +
  scale_x_log10("Effect size (d)", breaks = c(0.05, 0.1, 0.2, 0.5, 1)) +
  scale_color_brewer(palette = "Set1")
ggsave(file.path(out_dir, "fig6_samplesize.pdf"), fig6, width = 8, height = 5)

# c = 0 reduces to the traditional formula
stopifnot(isTRUE(all.equal(SampleNew(c(0.1, 0.3, 0.5), 0),
                           ((qnorm(0.975) + qnorm(0.8)) / c(0.1, 0.3, 0.5))^2)))

# Power check: one-sample z-test (sigma = 1), n = ceiling(formula), 50,000 replicates
set.seed(2024)
nsim <- 50000
check <- data.table(d = c(0.3, 0.25, 0.2, 0.5, 0.1), c = c(0.1, 0.1, 0.05, 0.1, 0.02))
check[, n_formula := SampleNew(d, c)]
check[, n_used := ceiling(n_formula)]
check[, n_old := {
  n0 <- ((qnorm(0.975) + qnorm(0.8)) / d)^2
  fifelse(1/n0 - c^2 <= 0, NA_real_, 1 / (1/n0 - c^2))
}]
check[, power_exact := {
  k <- qnorm(0.975) * sqrt(1/n_used + c^2)
  pnorm((d - k) * sqrt(n_used)) + pnorm((-k - d) * sqrt(n_used))
}]
check[, power_sim := mapply(function(d, c, n) {
  mean(replicate(nsim, CalP_uncertainty(mean(rnorm(n, mean = d, sd = 1)) * sqrt(n), n, c) < 0.05))
}, d, c, n_used)]
check[, mc_se := sqrt(power_sim * (1 - power_sim) / nsim)]
fwrite(check, file.path(out_dir, "samplesize_verification.csv"))
print(check, digits = 4)
