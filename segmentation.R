las = readLAS("C:\\Users\\b7079552\\OneDrive - Newcastle University\\2022_summer_school\\01_data\\ALS\\01_AOI_point_clouds\\ALS_2017_plot_normZ_fltr.las", select="xyz", filter = "-drop_z_below 0")

print("File loaded")

chm <- grid_canopy(las, 0.2, p2r(0.2))
ker <- matrix(1,3,3)
chm <- raster::focal(chm, w = ker, fun = mean, na.rm = TRUE)

ttops <- tree_detection(chm, lmf(ws = 1, hmin = 2))

raster::plot(chm, col = height.colors(30), xlab="Easting", ylab="Northing")
raster::plot(ttops, add = TRUE, pch = 1, cex = 2, col = "black", legend = FALSE, xlab="Easting", ylab="Northing")

las <- lastrees(las, dalponte2016(chm, ttops, th_tree = 5, th_seed = 0.45, th_cr = 0.55, max_cr = 15, ID = "treeID"))

plot(las, color = "treeID")

write.csv(las@data, "C:\\Users\\b7079552\\OneDrive - Newcastle University\\2022_summer_school\\01_data\\ALS\\01_AOI_point_clouds\\Segmented\\PlotB_D2016_chm0.2_ws2.csv")

metric = tree_metrics(las, .stdtreemetrics)
hulls  = tree_hulls(las)
hulls@data = dplyr::left_join(hulls@data, metric@data) #joins two data tables (hulls and metric) together
spplot(hulls, "Z")

write.csv(hulls@data, "C:\\Users\\b7079552\\OneDrive - Newcastle University\\2022_summer_school\\01_data\\ALS\\01_AOI_point_clouds\\Segmented\\PlotB_D2016_chm0.2_ws2_metrics.csv")
