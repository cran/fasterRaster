## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
fig.path = 'man/figures/'

## ----install, eval = FALSE----------------------------------------------------
# install.packages("fasterRaster")

## ----install_dev, eval = FALSE------------------------------------------------
# remotes::install_github("adamlilith/fasterRaster", dependencies = TRUE)

## ----packages-----------------------------------------------------------------
library(terra)
library(sf)
library(data.table)
library(fasterRaster)

## ----grassDir_examples, eval = FALSE------------------------------------------
# grassDir <- "C:/Program Files/GRASS GIS 8.4" # Windows
# grassDir <- "/Applications/GRASS-8.4.app/Contents/Resources" # Mac OS
# grassDir <- "/usr/local/grass" # Linux

## ----grassDir, echo = FALSE---------------------------------------------------
grassDir <- "C:/Program Files/GRASS GIS 8.4" # Windows

## ----faster_grassDir, eval = FALSE--------------------------------------------
# faster(grassDir = grassDir)

## ----madElev, eval = FALSE----------------------------------------------------
# madElev <- fastData("madElev") # example SpatRaster
# madElev
# 
# class       : SpatRaster
# dimensions  : 1024, 626, 1  (nrow, ncol, nlyr)
# resolution  : 59.85157, 59.85157  (x, y)
# extent      : 731581.6, 769048.6, 1024437, 1085725  (xmin, xmax, ymin, ymax)
# coord. ref. : Tananarive (Paris) / Laborde Grid
# source      : madElev.tif
# name        : madElev
# min value   :       1
# max value   :     570

## ----elev, eval = FALSE-------------------------------------------------------
# elev <- fast(madElev)
# elev
# 
# class       : GRaster
# topology    : 2D
# dimensions  : 1024, 626, NA, 1 (nrow, ncol, ndepth, nlyr)
# resolution  : 59.85157, 59.85157, NA (x, y, z)
# extent      : 731581.552, 769048.635, 1024437.272, 1085725.279 (xmin, xmax, ymin, ymax)
# coord ref.  : Tananarive (Paris) / Laborde Grid
# name(s)     : madElev
# datatype    : integer
# min. value  :       1
# max. value  :     570

## ----elev_from_file, eval = FALSE---------------------------------------------
# rastFile <- system.file("extdata", "madElev.tif", package = "fasterRaster")
# elev2 <- fast(rastFile)

## ----madRivers, eval = FALSE--------------------------------------------------
# madRivers <- fastData("madRivers") # sf vector
# madRivers
# 
# Simple feature collection with 11 features and 5 fields
# Geometry type: LINESTRING
# Dimension:     XY
# Bounding box:  xmin: 731627.1 ymin: 1024541 xmax: 762990.1 ymax: 1085580
# Projected CRS: Tananarive (Paris) / Laborde Grid
# First 10 features:
#        F_CODE_DES          HYC_DESCRI      NAM ISO     NAME_0                       geometry
# 1180 River/Stream Perennial/Permanent MANANARA MDG Madagascar LINESTRING (739818.2 108005...
# 1185 River/Stream Perennial/Permanent MANANARA MDG Madagascar LINESTRING (739818.2 108005...
# 1197 River/Stream Perennial/Permanent      UNK MDG Madagascar LINESTRING (747857.8 108558...
# 1216 River/Stream Perennial/Permanent      UNK MDG Madagascar LINESTRING (739818.2 108005...
# 1248 River/Stream Perennial/Permanent      UNK MDG Madagascar LINESTRING (762990.1 105737...
# 1256 River/Stream Perennial/Permanent      UNK MDG Madagascar LINESTRING (742334.2 106858...
# 1257 River/Stream Perennial/Permanent      UNK MDG Madagascar LINESTRING (731803.7 105391...
# 1264 River/Stream Perennial/Permanent      UNK MDG Madagascar LINESTRING (755911.6 104957...
# 1300 River/Stream Perennial/Permanent      UNK MDG Madagascar LINESTRING (731871 1044531,...
# 1312 River/Stream Perennial/Permanent      UNK MDG Madagascar LINESTRING (750186.1 103441...

## ----rivers, eval = FALSE-----------------------------------------------------
# rivers <- fast(madRivers)
# rivers
# 
# class       : GVector
# geometry    : 2D lines
# dimensions  : 11, 11, 5 (geometries, sub-geometries, columns)
# extent      : 731627.0998, 762990.1321, 1024541.23477, 1085580.45359 (xmin, xmax, ymin, ymax)
# coord ref.  : Tananarive (Paris) / Laborde Grid
# names       :   F_CODE_DES      HYC_DESCRI      NAM   ISO     NAME_0
# type        :        <chr>           <chr>    <chr> <chr>      <chr>
# values      : River/Stream Perennial/Perm~ MANANARA   MDG Madagascar
#               River/Stream Perennial/Perm~ MANANARA   MDG Madagascar
#               River/Stream Perennial/Perm~      UNK   MDG Madagascar
#               (and 8 more rows)

## ----how_to_plot, eval = FALSE------------------------------------------------
# plot(elev)
# plot(rivers, col = 'lightblue', add = TRUE)

## ----multiplication, eval = FALSE---------------------------------------------
# elev_feet <- elev * 3.28084
# elev_feet
# 
# class       : GRaster
# topology    : 2D
# dimensions  : 1024, 626, NA, 1 (nrow, ncol, ndepth, nlyr)
# resolution  : 59.85157, 59.85157, NA (x, y, z)
# extent      : 731581.552, 769048.635, 1024437.272, 1085725.279 (xmin, xmax, ymin, ymax)
# coord ref.  : Tananarive (Paris) / Laborde Grid
# name(s)     :    layer
# datatype    :   double
# min. value  :   3.2808
# max. value  : 1870.056

## ----log, eval = FALSE--------------------------------------------------------
# log10_elev <- log10(elev)
# log10_elev
# 
# class       : GRaster
# topology    : 2D
# dimensions  : 1024, 626, NA, 1 (nrow, ncol, ndepth, nlyr)
# resolution  : 59.85157, 59.85157, NA (x, y, z)
# extent      : 731581.552, 769048.635, 1024437.272, 1085725.279 (xmin, xmax, ymin, ymax)
# coord ref.  : Tananarive (Paris) / Laborde Grid
# name(s)     :              log
# datatype    :           double
# min. value  :                0
# max. value  : 2.75587485567249

## ----distance_buffers, eval = FALSE-------------------------------------------
# dist <- distance(elev, rivers)
# dist
# 
# class       : GRaster
# topology    : 2D
# dimensions  : 1024, 626, NA, 1 (nrow, ncol, ndepth, nlyr)
# resolution  : 59.85157, 59.85157, NA (x, y, z)
# extent      : 731581.552, 769048.635, 1024437.272, 1085725.279 (xmin, xmax, ymin, ymax)
# coord ref.  : Tananarive (Paris) / Laborde Grid
# name(s)     :         distance
# datatype    :           double
# min. value  :                0
# max. value  : 21310.9411762729

## ----buffer, eval = FALSE-----------------------------------------------------
# 
# river_buff <- buffer(rivers, 2000)
# river_buff
# 
# class       : GVector
# geometry    : 2D polygons
# dimensions  : 1, 5, 0 (geometries, sub-geometries, columns)
# extent      : 729629.19151, 764989.97343, 1022544.92079, 1087580.24979 (xmin, xmax, ymin, ymax)
# coord ref.  : Tananarive (Paris) / Laborde Grid
# 

## ----plot_rivers_buffer, eval = FALSE-----------------------------------------
# plot(dist)
# plot(rivers, col = 'lightblue', add = TRUE)
# plot(river_buff, border = 'white', add = TRUE)

## ----rast, eval = FALSE-------------------------------------------------------
# terra_elev <- rast(elev)

## ----vect, eval = FALSE-------------------------------------------------------
# terra_rivers <- vect(rivers)
# sf_rivers <- st_as_sf(rivers)

## ----write, eval = FALSE------------------------------------------------------
# elev_temp_file <- tempfile(fileext = ".tif") # save as GeoTIFF
# writeRaster(elev, elev_temp_file)
# 
# vect_temp_file <- tempfile(fileext = ".shp") # save as shapefile
# writeVector(rivers, vect_temp_file)

