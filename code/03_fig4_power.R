## Figure 4: power of the uncertainty-adjusted test
source("00_setup.R")

set.seed(2024)
nsim <- 5000

sim_power <- function(n, d, c, nsim = 5000) {
  rejections <- replicate(nsim, {
    x <- rnorm(n, mean = d, sd = 1)
    z <- mean(x) / (1/sqrt(n))
    CalP_uncertainty(z, n, c) < 0.05
  })
  mean(rejections)
}

power_data <- CJ(n = c(20, 50, 100, 200, 500, 1000, 2000), d = c(0.1, 0.2, 0.3, 0.5), c = c(0, 0.05, 0.1))
power_data[, power := mapply(sim_power, n, d, c, MoreArgs = list(nsim = nsim))]
fwrite(power_data, file.path(out_dir, "fig4_power.csv"))

fig4 <- ggplot(power_data, aes(n, power, color = factor(c), linetype = factor(c))) +
  geom_line(linewidth = 0.8) +
  geom_point(size = 2) +
  facet_wrap(~d, ncol = 2, labeller = label_bquote(cols = "Effect size d" == .(d))) +
  scale_x_log10("Sample size (n)") +
  scale_y_continuous("Power", limits = c(0, 1)) +
  labs(color = expression(italic(c)), linetype = expression(italic(c))) +
  geom_hline(yintercept = 0.8, linetype = "dashed", alpha = 0.5) +
  scale_color_brewer(palette = "Set1") +
  theme(legend.position = "bottom")
ggsave(file.path(out_dir, "fig4_power.pdf"), fig4, width = 8, height = 5)
