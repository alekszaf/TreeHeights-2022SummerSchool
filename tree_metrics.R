# Retrieve the individual tree metrics. Before proceeding ensure that non-tree objects are filtered off.
library(lidR)
library(sf)

# Load the normalized LAS file
las_file = file.choose()
las = readLAS(las_file, filter = "-drop_z_below 1")

metrics <- crown_metrics(las, .stdtreemetrics, geom = "convex")
#plot(metrics["Z"], pal = heat.colors, axes = TRUE, main="Tree heights (m)")

#setwd(choose.dir())
write.csv(metrics, sprintf("%s_tree_metrics.csv",substr(las_file,start=1,stop=(nchar(las_file)-4))))
write_sf(metrics, sprintf("%s_tree_metrics.shp",substr(las_file,start=1,stop=(nchar(las_file)-4))))

