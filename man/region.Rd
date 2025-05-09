% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/region.r
\name{.region,missing-method}
\alias{.region,missing-method}
\alias{.region}
\alias{.region,SpatRaster-method}
\alias{.region,GRegion-method}
\alias{.region,GRaster-method}
\alias{.region,GVector-method}
\alias{.regionExt,missing-method}
\alias{.regionExt}
\alias{.regionExt,numeric-method}
\alias{.regionExt,GSpatial-method}
\alias{.regionDim,missing-method}
\alias{.regionDim}
\alias{.regionDim,numeric-method}
\alias{.regionDim,GRegion-method}
\alias{.regionRes,missing-method}
\alias{.regionRes}
\alias{.regionRes,numeric-method}
\alias{.regionRes,GRegion-method}
\title{Report or change the extent, dimensions, and/or resolution of a region GRASS}
\usage{
\S4method{.region}{missing}(x)

\S4method{.region}{SpatRaster}(x)

\S4method{.region}{GRegion}(x)

\S4method{.region}{GRaster}(x, trim = NULL)

\S4method{.region}{GVector}(x)

\S4method{.regionExt}{missing}(x)

\S4method{.regionExt}{numeric}(x, respect)

\S4method{.regionExt}{GSpatial}(x, respect)

\S4method{.regionDim}{missing}(x)

\S4method{.regionDim}{numeric}(x, respect)

\S4method{.regionDim}{GRegion}(x, respect)

\S4method{.regionRes}{missing}(x)

\S4method{.regionRes}{numeric}(x, respect)

\S4method{.regionRes}{GRegion}(x, respect)
}
\arguments{
\item{x}{Any of:
\itemize{
\item Missing (default): Reports the extent, resolution, and dimensions of the current region. All other arguments will be ignored. You can also use \code{\link[=ext]{ext()}}, \code{\link[=dim]{dim()}}, and \code{\link[=res]{res()}} and related functions with missing arguments.
\item A \code{GSpatial}, \code{GRegion}, \code{GRaster}, \code{GVector} object: Sets the region"s extent, dimensions, and/or resolution to those of the object.
\item A \code{numeric} vector. This will resize the region's extent, resample the region's resolution/dimensions, or both, to ensure the desired dimensions or resolution are retained:
* 2 values for \code{.regionDim()}: Number of rows and columns
* 4 values for \code{.regionExt()}: Westernmost and easternmost easting (longitude), and southernmost and northernmost northing (latitude)
* 2 values for \code{.regionRes()}: Size of cells in the x- and y-dimensions
}}

\item{trim}{A \code{GRaster} or \code{NULL} (default). If a \code{GRaster}, then the region will be trimmed to the non-\code{NA} cells in this raster. \code{trim} can only be non-\code{NULL} if \code{x} is a \code{GRaster}. Ignored if \code{NULL}.}

\item{respect}{Character or \code{GRaster}: Indicates what aspect(s) of the current region to retain. Different functions allow for a different aspect to be retained. Partial matching is used.
\itemize{
\item \code{.regionDim()}: \code{"extent"} (extent unchanged, resolution may be changed) or \code{"resolution"} (resolution unchanged, extent may be changed).
\item \code{.regionExt()}: \code{"dimensions"} (dimensions unchanged, extent may be changed) or \code{"resolution"} (resolution unchanged, extent may be changed).
\item \code{.regionRes()}: \code{"extent"} (extent may be changed and/or dimensions may be changed to accommodate desired cell size) or \code{"dimensions"} (extent may be changed, dimensions unchanged).
Alternatively, a \code{GRaster} can be supplied:
\item \code{.regionDim()}: New region will have same extent and resolution.
\item \code{.regionExt()}: New region will have same dimensions and resolution.
\item \code{.regionRes()}: New region will have same extent and dimensions.
}

In this case, the new region"s registration will be the same as this raster, and cell resolution will be the same

Note: In most cases extent cannot be retained exactly if the resolution is changed. When resolution is changed, the actual extent will be the user-supplied extent expanded by zero to one rows or zero to one columns to accommodate an integer number of cells of the desired size. The western and northern limits of the extent will be retained, while the eastern and southern limits of the extent will be moved to accommodate an integer number of columns and rows.}
}
\value{
The value returned depends on how the function is used:
\itemize{
\item If used with no arguments, \code{.region()} returns a \code{GRegion} object.
\item If used with no arguments, \code{.regionDim()}, \code{.regionExt()}, and \code{.regionRes()} return numeric or integer vectors.
\item If the function is used to change reshape/resample the region, it returns a \code{GRegion} object reflecting the region \emph{before} it was changed. This allows users to revert to the original region if desired.
}
}
\description{
These functions either change the extent, dimensions, and/or resolution of a \strong{GRASS} "region" or report the current region's extent, dimensions, and/or resolution (see \code{vignette("regions", package = "fasterRaster")}). These functions are mostly used internally and rarely of interest to most users.
\itemize{
\item \code{.region()}: All 2D and 3D aspects of a region.
\item \code{.regionDim()}: x- and y-dimensions.
\item \code{.regionExt()}: x- and y-extent.
\item \code{.regionRes()}: x- and y-resolution.
}
}
\details{
When resizing extent, \strong{terra} keeps the \code{xmin} (west) and \code{ymax} (north) the fixed and shifts \code{xmax} (east) and \code{ymin} (south) as needed. To retain as much fidelity between \strong{fasterRaster} and \strong{terra} as possible, these functions do the same to the region.
}
\keyword{internal}
