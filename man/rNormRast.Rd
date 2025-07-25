% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rNormRast.r
\name{rNormRast,GRaster-method}
\alias{rNormRast,GRaster-method}
\alias{rNormRast}
\title{Create a raster with random values drawn from a normal distribution}
\usage{
\S4method{rNormRast}{GRaster}(x, n = 1, mu = 0, sigma = 1, seed = NULL)
}
\arguments{
\item{x}{A \code{GRaster}: The output will have the same extent and dimensions as this raster.}

\item{n}{An integer: Number of rasters to generate.}

\item{mu, sigma}{Numeric: Mean and sample standard deviation of output. If creating more than one raster, you can provide one value per raster. If there are fewer, they will be recycled.}

\item{seed}{Numeric integer or \code{NULL}: Random seed. If \code{NULL}, then a random seed is used for each raster. If provided, there should be one seed value per raster.}
}
\value{
A \code{GRaster}.
}
\description{
\code{rNormRast()} creates a raster with values drawn from a normal distribution.
}
\examples{
if (grassStarted()) {

# Setup
library(sf)
library(terra)

# Elevation raster
madElev <- fastData("madElev")

# Convert a SpatRaster to a GRaster:
elev <- fast(madElev)

### Create a raster with values drawn from a uniform distribution:
unif <- rUnifRast(elev)
plot(unif)

### Create a raster with values drawn from a normal distribution:
norms <- rNormRast(elev, n = 2, mu = c(5, 10), sigma = c(2, 1))
plot(norms)
hist(norms, bins = 100)

# Create a raster with random, seemingly normally-distributed values:
rand <- rSpatialDepRast(elev, dist = 1000)
plot(rand)

# Values appear normal on first inspection:
hist(rand)

# ... but actually are patterned:
hist(rand, bins = 100)

# Create a fractal raster:
fractal <- fractalRast(elev, n = 2, dimension = c(2.1, 2.8))
plot(fractal)
hist(fractal)

### Random walker rasters

# One random walker
walk <- rWalkRast(elev)
plot(walk)

# Random walker with self-avoidance:
walkAvoid <- rWalkRast(elev, steps = 1000, avoid = TRUE, seed = 1)
plot(walkAvoid)

# 10 random walkers:
walk10 <- rWalkRast(elev, n = 10)
plot(walk10)

# 10 random walkers starting in same place:
walkSame10 <- rWalkRast(elev, n = 10, sameStart = TRUE)
plot(walkSame10)


}
}
\seealso{
\code{\link[=rSpatialDepRast]{rSpatialDepRast()}}, \code{\link[=fractalRast]{fractalRast()}}, \code{\link[=rUnifRast]{rUnifRast()}}, \code{\link[=rWalkRast]{rWalkRast()}}, \strong{GRASS} manual page for tool \code{r.random.surface} (see \code{grassHelp("r.random.surface")})
}
