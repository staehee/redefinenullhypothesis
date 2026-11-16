## Figure 7 and Section 5.3 inline value: uncertainty control vs Bonferroni (deterministic)
source("00_setup.R")

bf2 <- CJ(m = 10^seq(0, 6, by = 0.01), N = c(1500, 3000, 5000, 10000))
bf2[, `:=`(
  Bonferroni = qnorm(1 - 0.025/m),
  Uncertainty = qnorm(1 - 0.025) * sqrt(1 + N * cfun(0.01, m, 0.069)^2)
)]
bf3 <- melt(bf2, id.vars = c("m", "N"), measure.vars = c("Bonferroni", "Uncertainty"),
            variable.name = "Method", value.name = "zcut")
bf3[, Method := as.character(Method)]
bf3[Method == "Uncertainty", Method := paste0("Uncertainty (n=", N, ")")]
bf3[, pcut := 2 * (1 - pnorm(zcut))]

fig7 <- ggplot(bf3, aes(m, pcut, colour = Method)) +
  geom_line(linewidth = 0.7) +
  scale_x_log10(expression(italic(m) ~ "(number of hypotheses)"),
                breaks = 10^seq(0, 6), labels = trans_format("log10", math_format(10^.x))) +
  scale_y_continuous(expression(italic(p)[req]), trans = reverselog_trans(10),
                     breaks = 5 * 10^seq(-2, -8), limits = c(0.05, 5e-8)) +
  theme(legend.position = "bottom") +
  guides(color = guide_legend(nrow = 2))
ggsave(file.path(out_dir, "fig7_multiple.pdf"), fig7, width = 8, height = 5)

preq_1500 <- 2 * (1 - pnorm(qnorm(0.975) * sqrt(1 + 1500 * cfun(0.01, 1e6, 0.069)^2)))
fwrite(data.table(preq_n1500_m1e6 = preq_1500), file.path(out_dir, "multiple_preq.csv"))
print(preq_1500)
