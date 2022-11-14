las = readLAS("C:\\Users\\b7079552\\OneDrive - Newcastle University\\2022_summer_school\\01_data\\TLS\\20220921_vz2000_p1.las")

dtm <- rasterize_terrain(las, 1, knnidw(k = 6L, p = 2))
nlas <- normalize_height(las, dtm)

writeLAS(nlas, "C:\\Users\\b7079552\\OneDrive - Newcastle University\\2022_summer_school\\01_data\\TLS\\20220921_VZ2000i_p1_normZ.las", index = FALSE)
