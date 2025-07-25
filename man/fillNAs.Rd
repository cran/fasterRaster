% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fillNAs.r
\name{fillNAs,GRaster-method}
\alias{fillNAs,GRaster-method}
\alias{fillNAs}
\title{Fill NA cells in a raster using interpolation}
\usage{
\S4method{fillNAs}{GRaster}(
  x,
  lambda = NULL,
  method = "bilinear",
  min = -Inf,
  max = Inf,
  cells = Inf
)
}
\arguments{
\item{x}{A \code{GRaster}.}

\item{lambda}{Either \code{NULL} (default), or a numeric value > 0: If \code{NULL}, then the function will use leave-one-out crossvalidation to find the optimal value.}

\item{method}{Character: Type of spline, either "\code{bilinear}" (default), "\code{bicubic}", or "\code{RST}" (regularized splines with tension). Partial matching is used and case is ignored.

\strong{Note}: The RST method will often display warnings, but these can be ignored.}

\item{min, max}{Numeric: Lowest and highest values allowed in the interpolated values. Values outside these bounds will be truncated to the minimum/maximum value(s) allowed. The default imposes no constraints. For multi-layered rasters, you can supply a single value for \code{min} and/or \code{max}, or multiple values (one per layer). Values will be recycled if there are fewer than one or them per layer in the raster.}

\item{cells}{Integer or numeric integer: Number of cells away from the non-\code{NA} cells to fill. For example, if \code{cells = 2}, then only cells within a 2-cell buffer of non-\code{NA} cells will be filled. The default is \code{Inf} (fill all possible cells--some methods may not be able to do this, depending on the configuration of the raster).}
}
\value{
A \code{GRaster}.
}
\description{
This function uses splines to fill \code{NA} cells in a raster based on the values of nearby cells. Depending on the method used, not all \code{NA} cells can be filled.
}
\examples{
if (grassStarted()) {

# Setup
library(terra)

# Elevation raster:
madElev <- fastData("madElev")

# Convert a SpatRaster to a GRaster:
elev <- fast(madElev)

### Fill NAs:
bilinear <- fillNAs(elev)
bicubic <- fillNAs(elev, method = "bicubic")
rst <- fillNAs(elev, method = "rst")

maps <- c(elev, bilinear, bicubic, rst)
names(maps) <- c("original", "bilinear", "bicubic", "RST")
plot(maps)

### Constrain interpolated values to > 0
constrained <- fillNAs(elev, min = 0)

# Compare unconstrained and constrained:
minmax(bilinear)
minmax(constrained)

### Interpolate to only first 10 cells away from non-NA cells:
restrained <- fillNAs(elev, cells = 10)

maps <- c(elev, restrained)
names(maps) <- c("Original", "within 10 cells")
plot(maps)

}
}
\seealso{
\code{\link[terra:interpNear]{terra::interpNear()}}, \strong{GRASS} tool \code{r.fillnulls} (see \code{grassHelp("r.fillnulls")})
}
