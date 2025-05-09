% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/location.r, R/locationDelete.r
\name{.location,GLocation-method}
\alias{.location,GLocation-method}
\alias{.location}
\alias{.location,missing-method}
\alias{.locationDelete}
\title{GRASS "location" of an object or the active session}
\usage{
\S4method{.location}{GLocation}(x)

\S4method{.location}{missing}(x)

.locationDelete(location, mapset = NULL, workDir = NULL)
}
\arguments{
\item{x}{Either:
\itemize{
\item Missing: Reports location of currently active project/location.
\item A \code{GLocation} object or an object that contains the \code{GLocation} class (i.e., a \code{GSpatial} object: a \code{GRaster} or \code{GVector}).
}}

\item{location}{Character: Name of the \strong{GRASS} "location".}

\item{mapset}{Character or \code{NULL} (default): Name of the mapset to delete. If \code{NULL}, then all mapsets in the given "location" will be deleted.}

\item{workDir}{Character: Either \code{NULL} (default) or a character string of the directory in which the location to be removed resides. If \code{NULL}, then the working directory will be obtained from \code{faster("workDir")}.}
}
\value{
A character string.

If successful, \code{TRUE} (invisibly). If not, then \code{FALSE} (also invisibly), plus a warning.
}
\description{
\strong{GRASS} "projects" or "locations" are sets of one or more rasters and/or vectors with the same coordinate reference systems, and may or may not represent the same actual location on Earth. \strong{GRASS} "mapsets" are like sub-folders of locations, and are collections of rasters and/or vectors typically related to the same general project. Typical users will not need to make changes to the default location (called "location") or mapset (called "PERMANENT"). See \code{vignette("projects_mapsets", package = "fasterRaster")}.

This function deletes a \strong{GRASS} "project"/"location", rasters, and vectors therein. This function should be used cautiously and is mainly of use to developers. See \code{vignette("projects_mapsets", package = "fasterRaster")}.
}
\seealso{
\code{\link[=.mapset]{.mapset()}}
}
\keyword{internal}
