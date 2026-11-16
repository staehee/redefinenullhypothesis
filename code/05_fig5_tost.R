## Figure 5 and Section 3.3 inline values: comparison with TOST
source("00_setup.R")

set.seed(2024)
nsim <- 3000

compare_methods <- function(d, n, c, equiv_bound, nsim) {
  results <- replicate(nsim, {
    x1 <- rnorm(n/2, mean = 0, sd = 1)
    x2 <- rnorm(n/2, mean = d, sd = 1)
    mean_diff <- mean(x2) - mean(x1)
    se_diff <- sqrt(2 / (n/2))
    z_stat <- mean_diff / se_diff
    n_eff <- (n/2)^2 / n
    p_trad <- 2 * (1 - pnorm(abs(z_stat)))
    p_uncert <- CalP_uncertainty(z_stat, n_eff, c)
    t_lower <- (mean_diff - (-equiv_bound)) / se_diff
    t_upper <- (equiv_bound - mean_diff) / se_diff
    p_tost_equiv <- max(pnorm(-t_lower), pnorm(-t_upper))
    c(trad = p_trad < 0.05, uncert = p_uncert < 0.05, tost_equiv = p_tost_equiv < 0.05)
  })
  data.table(n = n, d = d,
             Traditional = mean(results["trad", ]),
             Uncertainty = mean(results["uncert", ]),
             TOST_equiv = mean(results["tost_equiv", ]))
}

grid_tost <- CJ(n = c(200, 2000), d = seq(0, 0.5, by = 0.02))
comparison <- rbindlist(lapply(seq_len(nrow(grid_tost)), function(i) {
  compare_methods(grid_tost$d[i], grid_tost$n[i], c = 0.1, equiv_bound = 0.2, nsim = nsim)
}))
fwrite(comparison, file.path(out_dir, "fig5_tost.csv"))

comparison_long <- melt(comparison, id.vars = c("n", "d"), variable.name = "Method", value.name = "Rate")
comparison_long[, Method := factor(Method, levels = c("Traditional", "Uncertainty", "TOST_equiv"),
                                   labels = c("Traditional test (reject point null)",
                                              "Uncertainty-adjusted test (c = 0.1)",
                                              "TOST (equivalence established)"))]
mde_tost <- data.table(n = c(200, 2000))[, MDE := qnorm(0.975) * sqrt(4/n + 0.1^2)]
mde_label <- mde_tost[, .(n, x = MDE + 0.01, y = 0.08, label = sprintf("MDE = %.3f", MDE))]

fig5 <- ggplot(comparison_long, aes(d, Rate, color = Method, linetype = Method)) +
  geom_line(linewidth = 0.8) +
  geom_vline(data = mde_tost, aes(xintercept = MDE), linetype = "dotted") +
  geom_vline(xintercept = qnorm(0.975) * 0.1, linetype = "dashed", alpha = 0.4) +
  geom_text(data = mde_label, aes(x = x, y = y, label = label), inherit.aes = FALSE, hjust = 0, size = 3) +
  facet_wrap(~n, labeller = label_bquote(cols = italic(n) == .(n))) +
  scale_x_continuous("True effect size (d)") +
  scale_y_continuous("Rate", limits = c(0, 1)) +
  scale_color_brewer(palette = "Set1") +
  theme(legend.position = "bottom", legend.title = element_blank()) +
  guides(color = guide_legend(nrow = 2), linetype = guide_legend(nrow = 2))
ggsave(file.path(out_dir, "fig5_tost.pdf"), fig5, width = 8, height = 4.5)

print(comparison[(n == 2000 & d %in% c(0)) | (n == 2000 & abs(d - 0.14) < 1e-8) | (n == 2000 & abs(d - 0.3) < 1e-8)])
