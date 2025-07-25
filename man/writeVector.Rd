% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/writeVector.r
\name{writeVector,GVector,character-method}
\alias{writeVector,GVector,character-method}
\alias{writeVector}
\alias{writeVector,missing,missing-method}
\title{Save a GVector to disk}
\usage{
\S4method{writeVector}{GVector,character}(
  x,
  filename,
  overwrite = FALSE,
  format = NULL,
  attachTable = TRUE,
  ...
)

\S4method{writeVector}{missing,missing}(x, filename)
}
\arguments{
\item{x}{A \code{GVector}.}

\item{filename}{Character: Path and file name.}

\item{overwrite}{Logical: If \code{FALSE} (default), do not save over existing files.}

\item{format}{Character or \code{NULL}: File format. If \code{NULL} (default), then the function will attempt to get the format from the file name extension. Partial matching is used and case is ignored. You can see a list of formats using \code{writeVector()} (no arguments). Some common formats include:
\itemize{
\item \code{"GPKG"}: OGC GeoPackage (extension \code{.gpkg}).
\item \code{"CSV"}: Comma-separated value... saves the data table only, not the geometries (extension \code{.csv}).
\item \code{"ESRI Shapefile"}: ESRI shapefile (extension \code{.shp}).
\item \code{"GeoJSON"}: GeoJSON (extension \code{GeoJSON})
\item \code{"KML"}: Keyhole Markup Language (extension \code{.kml})
\item \code{"netCDF"}: NetCDF (extension \code{.ncdf})
\item \code{"XLSX"}: MS Office Open XML spreadsheet (extension \code{.xlsx}).
}}

\item{attachTable}{Logical: If \code{TRUE} (default), attach the attribute to table to the vector before saving it. If \code{FALSE}, the attribute table will not be attached.}

\item{...}{Additional arguments to send to \strong{GRASS} tool \code{v.out.ogr} (see \code{grassHelp("v.out.ogr")}).}
}
\value{
Invisibly returns a \code{GRaster} (the input, \code{x}). Also saves the vector to disk.
}
\description{
This function saves a \code{GVector} to disk directly from a \strong{GRASS} session.

By default, files will be of OGC GeoPackage format (extension "\code{.gpkg}"), but this can be changed with the \code{format} argument. You can see a list of supported formats by simply using this function with no arguments, as in \code{writeVector()}, or by consulting the online help page for \strong{GRASS} tool \code{v.out.ogr} (see \code{grassHelp("v.out.ogr")}).

Note that if the vector has a data table attached and at least one numeric or integer column has an \code{NA} or \code{NaN} value, the function will yield a warning like:

\if{html}{\out{<div class="sourceCode">}}\preformatted{Warning 1: Invalid value type found in record 2 for field column_with_NA_or_NaN. This warning will no longer be emitted.
}\if{html}{\out{</div>}}

Also note that despite the promise, this warning will be displayed again.
}
\examples{
if (grassStarted()) {

# Setup
library(terra)

# Example data
madRivers <- fastData("madRivers")

# What file formats can we attempt to write?
writeVector()

# Convert SpatVector to GVector
rivers <- fast(madRivers)
rivers

# Save GVector to disk as GeoPackage
filename <- tempfile(fileext = ".gpkg")
writeVector(rivers, filename)

# Save GVector to disk as ESRI Shapefile
filename <- tempfile(fileext = ".shp")
writeVector(rivers, filename)

# Save GVector to disk as Google Earth KML
filename <- tempfile(fileext = ".klm")
writeVector(rivers, filename)

# Save GVector data table to disk as comma-separated file
filename <- tempfile(fileext = ".csv")
writeVector(rivers, filename)

# Save GVector data table to disk as NetCDF
filename <- tempfile(fileext = ".ncdf")
writeVector(rivers, filename)

# Save GVector data table to disk as Excel file
filename <- tempfile(fileext = ".xlsx")
writeVector(rivers, filename)

}
}
\seealso{
\code{\link[terra:writeVector]{terra::writeVector()}}, \code{\link[sf:st_write]{sf::st_write()}}, \strong{GRASS} tool \code{v.out.ogr} (see \code{grassHelp("v.out.ogr")})

\code{\link[terra:writeVector]{terra::writeVector()}}, the \strong{GRASS} tool manual page for \code{v.out.ogr} (see \code{grassHelp("v.out.ogr")})
}
