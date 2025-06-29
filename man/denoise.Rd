% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/denoise_noise.r
\name{denoise,GRaster-method}
\alias{denoise,GRaster-method}
\alias{denoise}
\alias{noise,GRaster-method}
\alias{noise}
\title{Remove or retain "noise" in a raster using PCA}
\usage{
\S4method{denoise}{GRaster}(x, scale = FALSE, percent = 80)

\S4method{noise}{GRaster}(x, scale = FALSE, percent = 80)
}
\arguments{
\item{x}{A \code{GRaster} with two or more layers.}

\item{scale}{Logical: If \code{TRUE}, input layers will be rescaled by dividing each layer by its overall population standard deviation. Note that rasters will always be centered (have their mean subtracted from values). Centering and scaling is recommended when rasters values are in different units. The default is \code{FALSE} (do not scale).}

\item{percent}{Numeric integer or integer in the range 50 to 99 (default is 80): Minimum total variation explained in the retained PC axes. Higher values will cause \code{denoise()} to remove less noise, and \code{noise()} to return less noise. If this value to too low to retain even one axis, the function will fail with a message to that effect.}
}
\value{
A multi-layer \code{GRaster} with one layer per input.
}
\description{
\code{denoise()} applies a principal component analysis (PCA) to layers of a \code{GRaster}, then uses the PCA to predict values back to a raster. This retains only coarse-scale trends, thereby removing "noise" (locally extreme values that fall far from a PC axis).

\code{noise()} does the opposite by first constructing the PCA, predicting values back to the raster, then subtracting these values from the original, removing coarse-scale trends and thereby leaving "noise".
}
\examples{
if (grassStarted()) {

# Setup
library(terra)

# Climate raster:
madChelsa <- fastData("madChelsa")

# Convert a SpatRaster to a GRaster:
chelsa <- fast(madChelsa)

### Denoise:
quiet <- denoise(chelsa, scale = TRUE)

compare1 <- c(chelsa[["bio1"]], quiet[["bio1"]])
plot(compare1)

compare2 <- c(chelsa[["bio7"]], quiet[["bio7"]])
plot(compare2)

### Noise:
loud <- noise(chelsa, scale = TRUE)

compare1 <- c(chelsa[["bio1"]], loud[["bio1"]])
plot(compare1)

compare2 <- c(chelsa[["bio7"]], loud[["bio7"]])
plot(compare2)

}
}
\seealso{
\code{\link[=princomp]{princomp()}}, \code{\link[stats:prcomp]{stats::prcomp()}}, \strong{GRASS} manual page for tool \code{i.pca} (see \code{grassHelp("i.pca")})
}
