## Figures 1-3: null with uncertainty, p-value shrinkage, MDE (deterministic)
source("00_setup.R")

# Figure 1
h <- CJ(x = seq(-10, 10, by = 0.01), tau = c(0.5, 1, 2, 4, 8))
h[, Density := dnorm(x, sd = tau)]
fig1 <- ggplot(h, aes(x, Density, colour = factor(tau))) +
  geom_line(linewidth = 0.8) +
  labs(color = expression(tau)) +
  xlab(expression(mu[0])) +
  scale_color_brewer(palette = "Set1")

# Figure 2
comp <- CJ(Z = seq(0, 7, by = 0.001), N = c(25, 100, 400, 10000), c = c(0, 0.01, 0.05, 0.1, 0.2))
comp[, p := CalP_uncertainty(Z, N, c)]
setkey(comp, Z, N)
dd <- comp[c == 0][comp]
fig2 <- ggplot(dd, aes(p, i.p, color = factor(i.c))) +
  geom_line(linewidth = 0.7) +
  facet_wrap(~N, ncol = 2, labeller = label_bquote(cols = italic(n) == .(N))) +
  scale_x_continuous(expression(italic(p)), trans = reverselog_trans(10),
                     breaks = c(0.5, 0.05, 0.005), limits = c(1, 10^(-3))) +
  scale_y_continuous(expression(italic(p)[italic(c)*sigma]), trans = reverselog_trans(10),
                     breaks = c(0.5, 0.05, 0.005), limits = c(1, 10^(-3))) +
  labs(color = expression(italic(c))) +
  scale_color_brewer(palette = "Set1")

# Figure 3
c_vals <- c(0, 0.01, 0.05, 0.1, 0.2)
mde_data <- CJ(n = 10^seq(0.5, 5, by = 0.01), c = c_vals)
mde_data[, MDE := qnorm(0.975) * sqrt(1/n + c^2)]
fig3 <- ggplot(mde_data, aes(n, MDE, color = factor(c))) +
  geom_line(linewidth = 0.8) +
  scale_x_log10("Sample size (n)", breaks = 10^(1:5), labels = scales::comma) +
  scale_y_log10("Minimum Detectable Effect", breaks = c(0.01, 0.05, 0.1, 0.2, 0.5, 1)) +
  labs(color = expression(italic(c))) +
  scale_color_brewer(palette = "Set1") +
  geom_hline(yintercept = qnorm(0.975) * c_vals[-1], linetype = "dashed", alpha = 0.3)

plot_list <- list(fig1_null_uncertainty = fig1, fig2_p_shrinkage = fig2, fig3_mde = fig3)
for (nm in names(plot_list)) {
  ggsave(file.path(out_dir, paste0(nm, ".pdf")), plot_list[[nm]], width = 8, height = 5)
}
