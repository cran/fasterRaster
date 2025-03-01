#' Coerce raster to integer, float, or double precision
#'
#' @description In **fasterRaster**, rasters can have three data types: "factor" (categorical rasters), "integer" (integers), "float" (floating point values, accurate to 6th to 9th decimal places), and "double" (double-precision values, accurate to the 15th to 17th decimal places). The type of raster can be checked with:
#'
#' * `as.int()`: Coerce values to integers (**GRASS** type `CELL`).
#' * `as.float()`: Coerce values to floating-point precision.
#' * `as.doub()`: Coerce values to double-floating point precision.
#' * Integer rasters can be converted categorical rasters by adding "levels" tables with \code{\link[fasterRaster]{levels<-}} or [categories()].
#' 
#' @param x A `GRaster`.
#' 
#' @returns A `GRaster`.
#' 
#' @seealso [datatype()], [terra::datatype()], [is.int()], [is.float()], [is.doub()], \code{\link[fasterRaster]{levels<-}}, `vignette("GRasters", package = "fasterRaster")`
#'
#' @example man/examples/ex_GRaster.r
#' 
#' @aliases as.int
#' @rdname as.int
#' @exportMethod as.int
methods::setMethod(
    f = "as.int",
    signature = c(x = "GRaster"),
    function(x) .as.type(x, fx = "int")
)

#' @aliases as.float
#' @rdname as.int
#' @exportMethod as.float
methods::setMethod(
    f = "as.float",
    signature = c(x = "GRaster"),
    function(x) .as.type(x, fx = "float")
)

#' @aliases as.doub
#' @rdname as.int
#' @exportMethod as.doub
methods::setMethod(
    f = "as.doub",
    signature = c(x = "GRaster"),
    function(x) .as.type(x, fx = "double")
)

# x: GRaster
# fx: "int", "float", "double"
.as.type <- function(x, fx) {

    .locationRestore(x)
    .region(x)

    for (i in 1L:nlyr(x)) {

        src <- .makeSourceName("as_raster_type", "rast")
        ex <- paste0(src, " = ", fx, "(", sources(x)[i], ")")
        rgrass::execGRASS(cmd = "r.mapcalc", expression = ex, flags = c(.quiet(), "overwrite"))

        this <- .makeGRaster(src, names(x)[i])
        if (i == 1L) {
            out <- this
        } else {
            out <- c(out, this)
        }

    }
    out

} # EOF
