if (grassStarted()) {

# Setup
library(terra)

### GRasters

# Example data
madElev <- fastData("madElev") # elevation raster
madForest2000 <- fastData("madForest2000") # forest raster
madForest2014 <- fastData("madForest2014") # forest raster

# Convert SpatRasters to GRasters
elev <- fast(madElev)
forest2000 <- fast(madForest2000)
forest2014 <- fast(madForest2014)

# Re-assigning values of a GRaster
constant <- elev
constant[] <- pi
names(constant) <- "pi_raster"
constant

# Re-assigning specific values of a raster
replace <- elev
replace[replace == 1] <- -20
replace

# Subsetting specific values of a raster based on another raster
elevInForest <- elev[forest2000 == 1]
plot(c(elev, forest2000, elevInForest), nr = 1)

# Adding and replacing layers of a GRaster
rasts <- c(elev, constant, forest2000)

# Combine with another layer:
add(rasts) <- forest2014 # one way
rasts

rasts <- c(rasts, forest2014) # another way

### Subsetting GRaster layers

# Subset:
rasts <- c(elev, forest2000, forest2014)
rasts[[2:3]]
subset(rasts, 2:3)
subset(rasts, c("madForest2000", "madElev"))
rasts[[c("madForest2000", "madElev")]]
rasts$madForest2000

# Get every other layer:
rasts[[c(FALSE, TRUE)]]

### Replacing layers of a GRaster

# Replace a layer
logElev <- log(elev)
names(logElev) <- "logElev"
rasts$madForest2014 <- logElev
rasts

# Replace a layer:
rasts[[3]] <- forest2000
rasts

### GVectors

# example data
madDypsis <- fastData("madDypsis") # vector of points
madDypsis <- vect(madDypsis)

# Convert SpatVector to GVector
dypsis <- fast(madDypsis)

### Retrieving GVector columns

dypsis$species # Returns the column

dypsis[[c("year", "species")]] # Returns a GVector with these columns
dypsis[ , c("year", "species")] # Same as above

### Subsetting GVector geometries

# Subset three geometries
dypsis[c(1, 4, 10)]

# Subset three geometries and one column. Note order will always be the same
# in the output and may differ in order from terra subsetting.
dypsis[c(1, 4, 10), "species"]
dypsis[c(10, 4, 1), "species"] # fasterRaster: Same order as previous.
madDypsis[c(1, 4, 10), "species"]
madDypsis[c(10, 4, 1), "species"] # terra: different order as previous.

# Get geometries by data table condition
dypsis[dypsis$species == "Dypsis betsimisarakae"]

### (Re)assigning GVector column values

# New column
dypsis$pi <- pi
head(dypsis)

# Re-assign values
dypsis$pi <- "pie"
head(dypsis)

# Re-assign specific values
dypsis$institutionCode[dypsis$institutionCode == "MO"] <-
   "Missouri Botanical Garden"

}
