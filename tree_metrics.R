# Retrieve the individual tree metrics. Before proceeding ensure that non-tree objects are filtered off.
library(lidR)

# Load the normalized LAS file
las = file.choose()
las = readLAS(las, filter = "-drop_z_below 1")

metrics <- crown_metrics(las, .stdtreemetrics, geom = "convex")
plot(metrics["Z"], pal = heat.colors, axes = TRUE, main="Tree heights (m)")

setwd(choose.dir())
write.csv(metrics, "TLS_Plot2_metrics.csv")