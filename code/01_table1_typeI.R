## Table 1: rejection rates under the point null and the distributional null
source("00_setup.R")

set.seed(2024)
nsim <- 10000

sim_typeI <- function(n, c, nsim = 10000) {
  rejections <- replicate(nsim, {
    # Point null: mu = 0
    x <- rnorm(n, mean = 0, sd = 1)
    z_point <- mean(x) * sqrt(n)
    # Distributional null: mu ~ N(0, c^2), sigma = 1
    mu <- rnorm(1, mean = 0, sd = c)
    y <- rnorm(n, mean = mu, sd = 1)
    z_dist <- mean(y) * sqrt(n)
    c(point = CalP_uncertainty(z_point, n, c) < 0.05,
      dist = CalP_uncertainty(z_dist, n, c) < 0.05)
  })
  data.table(n = n, c = c,
             Point = mean(rejections["point", ]),
             Distributional = mean(rejections["dist", ]))
}

scenarios <- CJ(n = c(30, 100, 500, 1000, 5000), c = c(0, 0.01, 0.05, 0.1))
results_typeI <- rbindlist(lapply(1:nrow(scenarios), function(i) {
  sim_typeI(scenarios$n[i], scenarios$c[i], nsim)
}))

fwrite(results_typeI, file.path(out_dir, "table1_typeI.csv"))
print(dcast(results_typeI, n ~ c, value.var = c("Point", "Distributional")))
