library(lidR)
library(sp)
library(raster)
library(dplyr)

# Load the normalized LAS file
las_file = file.choose()
las = readLAS(las_file, filter = "-drop_z_below 1")

# Assign a coordinate system (UTM 32N)
st_crs(las) <- 32632

#Create Canopy Height Model

# Simple CHM
#chm <- rasterize_canopy(las, res = 1, algorithm = p2r())

#Pit-free CHM
chm <- rasterize_canopy(las, res = 2, pitfree(max_edge = c(0, 2.5)), pkg = "terra")
chm <- rasterize_canopy(las, res = 0.2, pitfree(max_edge = c(0, 2.5)), pkg = "terra")

# Plot the canopy height model
col <- height.colors(25)
plot(chm, col = col)

#Detect the tree tops
ttops <- locate_trees(chm, lmf(ws = 8, hmin = 3))

#Plot the tree tops
plot(chm, col = height.colors(50))
plot(sf::st_geometry(ttops), add = TRUE, pch = 3)

#Segmentation - select one of the methods

# Raster-based methods
#las <- segment_trees(las, silva2016(chm, ttops))

#las <- segment_trees(las, watershed(chm, th_tree = 2, tol = 1, ext = 1))

las <- segment_trees(las, dalponte2016(chm, ttops, max_cr = 15))

# Point cloud-based methods (very slow with large point clouds)
#las <- segment_trees(las, li2012())

# Plot the segmented point cloud
#plot(las, color = "treeID", pal = col)


# COnvert the NA values to 0
las@data[is.na(las@data)] <- 0

#Select output directory
#setwd(choose.dir())

# Save the output point cloud as CSV and LAS
write.csv(las@data, sprintf("%s_chm1.5_ws0.8_dalponte.csv",substr(las_file,start=1,stop=(nchar(las_file)-4))))
writeLAS(las, sprintf("%s_chm1.5_ws0.8_dalponte.las",substr(las_file,start=1,stop=(nchar(las_file)-4))))


