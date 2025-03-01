if (grassStarted()) {

# Setup
library(terra)

# Example data: Elevation and land cover
madElev <- fastData("madElev")
madForest2000 <- fastData("madForest2000")
madCover <- fastData("madCover")

# Convert to GRasters:
elev <- fast(madElev)
forest2000 <- fast(madForest2000)
cover <- fast(madCover)

# Rename
names(elev) <- "elev"
names(forest2000) <- "forest"

# Geometric statistics for an integer raster zoned by elevation:
fun <-
  "= if (elev <400 & forest == 1, 0, if (elev >=400 & forest == 1, 1, null()))"
forestByElev <- app(c(elev, forest2000), fun = fun)
plot(forestByElev, main = "forest < 400 m & >= 400 m")
zonalGeog(forestByElev)

# Geometric statistics for a categorical raster:
zonalGeog(cover)

}
