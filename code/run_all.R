## Run every script in order from the code/ directory:  Rscript run_all.R
scripts <- sort(list.files(".", pattern = "^0[1-9]_.*\\.R$"))
for (s in scripts) {
  cat("\n==== ", s, " ====\n", sep = "")
  t0 <- Sys.time()
  source(s, local = new.env(), echo = FALSE)
  cat(sprintf("done in %.1f s\n", as.numeric(difftime(Sys.time(), t0, units = "secs"))))
}
writeLines(capture.output(sessionInfo()), file.path("output", "sessionInfo.txt"))
