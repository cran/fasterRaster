#' Spatial bounds of a GRaster or GVector
#'
#' @description These functions return the extent of a `GSpatial` object (`GRegions`, `GRaster`s, and `GVector`s):
#' 
#' * `ext()`: 2-dimensional spatial extent (i.e., westernmost/easternmost and southernmost/northernmost coordinates of area represented).\cr
#' * `zext()`: Vertical extent (i.e., topmost and bottom-most elevation of the volume represented). The vertical extent is not `NA` only if the object is 3-dimensional.\cr
#' * `W()`, `E()`, `N()`, `S()`: Coordinates of one side of horizontal extent.\cr
#' * `top()` and `bottom()`: Coordinates of top and bottom of vertical extent.\cr
#' 
#' @param x An object that inherits from `GSpatial` (i.e., a `GRaster` or `GVector`) or missing. If missing, then the horizontal or vertical extent of the currently active "region" is returned (see `vignette("regions", package = "fasterRaster")`).
#' 
#' @param vector Logical: If `FALSE` (default), return a `SpatExtent` object. If `TRUE`, return the extent as a named vector.
#' 
#' @param char Logical: If `FALSE` (default), return a numeric value. If `TRUE`, return as a character.
#' 
#' @returns The returned values depend on the function:
#' * `ext()`: A `SpatExtent` object (**terra** package) or a numeric vector.
#' * `zext()`: A numeric vector.
#' * `W()`, `E()`, `N()`, `S()`, `top()`, and `bottom()`: A numeric value or character.
#'
#' @seealso [terra::ext()], [sf::st_bbox()]
#' 
#' @example man/examples/ex_GRaster_GVector.r
#'
#' @aliases ext
#' @rdname ext
#' @exportMethod ext
methods::setMethod(
	f = "ext",
	signature = "missing",
	definition = function(x, vector = FALSE) ext(.region(), vector = vector)
)

#' @aliases ext
#' @rdname ext
#' @exportMethod ext
methods::setMethod(
	f = "ext",
	signature = "GSpatial",
	definition = function(x, vector = FALSE) {

	out <- c(x@extent[1L], x@extent[2L], x@extent[3L], x@extent[4L])
	names(out) <- c("xmin", "xmax", "ymin", "ymax")
	if (!vector) out <- terra::ext(out)
	out

	} # EOF
)

#' @aliases zext
#' @rdname ext
#' @exportMethod zext
methods::setMethod(
	f = "zext",
	signature = "missing",
 	definition = function(x) zext(.region())
)

#' @aliases zext
#' @rdname ext
#' @exportMethod zext
methods::setMethod(
	f = "zext",
	signature = "GSpatial",
	definition = function(x) {
	x@zextent
})

#' @aliases W
#' @rdname ext
#' @exportMethod W
methods::setMethod(
	f = "W",
	signature = "missing",
	definition = function(x, char = FALSE) {
	out <- unname(ext(.region(), vector = TRUE)["xmin"])
	if (char) out <- as.character(out)
	out
})

#' @aliases W
#' @rdname ext
#' @exportMethod W
methods::setMethod(
	f = "W",
	signature = "GSpatial",
	definition = function(x, char = FALSE) {
	out <- unname(ext(x, vector = TRUE)["xmin"])
	if (char) out <- as.character(out)
	out
})

#' @aliases E
#' @rdname ext
#' @exportMethod E
methods::setMethod(
	f = "E",
	signature = "missing",
	definition = function(x, char = FALSE) {
	out <- unname(ext(.region(), vector = TRUE)["xmax"])
	if (char) out <- as.character(out)
	out
})

#' @aliases E
#' @rdname ext
#' @exportMethod E
methods::setMethod(
	f = "E",
	signature = "GSpatial",
	definition = function(x, char = FALSE) {
	out <- unname(ext(x, vector = TRUE)["xmax"])
	if (char) out <- as.character(out)
	out
})

#' @aliases N
#' @rdname ext
#' @exportMethod N
methods::setMethod(
	f = "N",
	signature = "missing",
	definition = function(x, char = FALSE) {
	out <- unname(ext(.region(), vector = TRUE)["ymax"])
	if (char) out <- as.character(out)
	out
})

#' @aliases N
#' @rdname ext
#' @exportMethod N
methods::setMethod(
	f = "N",
	signature = "GSpatial",
	definition = function(x, char = FALSE) {
	out <- unname(ext(x, vector = TRUE)["ymax"])
	if (char) out <- as.character(out)
	out
})

#' @aliases S
#' @rdname ext
#' @exportMethod S
methods::setMethod(
	f = "S",
	signature = "missing",
	definition = function(x, char = FALSE) {
	out <- unname(ext(.region(), vector = TRUE)["ymin"])
	if (char) out <- as.character(out)
	out
})

#' @aliases S
#' @rdname ext
#' @exportMethod S
methods::setMethod(
	f = "S",
	signature = "GSpatial",
	definition = function(x, char = FALSE) {
	out <- unname(ext(x, vector = TRUE)["ymin"])
	if (char) out <- as.character(out)
	out
})

#' @aliases top
#' @rdname ext
#' @exportMethod top
methods::setMethod(
	f = "top",
	signature = c(x = "missing"),
	definition = function(x, char = FALSE) {
	out <- unname(zext(.region())["top"])
	if (char) out <- as.character(out)
	out
})

#' @aliases top
#' @rdname ext
#' @exportMethod top
methods::setMethod(
	f = "top",
	signature = "GSpatial",
	definition = function(x, char = FALSE) {
	out <- unname(zext(x)["top"])
	if (char) out <- as.character(out)
	out
})

#' @aliases bottom
#' @rdname ext
#' @exportMethod bottom
methods::setMethod(
	f = "bottom",
	signature = c(x = "GSpatial"),
	definition = function(x, char = FALSE) {
	out <- unname(zext(.region())["bottom"])
	if (char) out <- as.character(out)
	out
})

#' @aliases bottom
#' @rdname ext
#' @exportMethod bottom
methods::setMethod(
	f = "bottom",
	signature = "GSpatial",
	definition = function(x, char = FALSE) {

	out <- unname(zext(x)["bottom"])
	if (char) out <- as.character(out)
	out

	} # EOF
)

#' Function to get extent from a "sources" name of a raster or vector
#'
#' @param x A `GRaster`, `GSpatial`, or a character ([sources()] name of a `GRaster` or `GVector`).
#'
#' @param rastOrVect Either `NULL` (class taken from `x`, but `x` cannot be a character), or "`raster`" or "`vector`" (partial matching is used).
#'
#' @returns A numeric vector.
#'
#' @keywords internal
.ext <- function(x, rastOrVect = NULL) {

	if (inherits(x, "GRaster")) {
		x <- sources(x)
		rastOrVect <- "raster"
	} else if (inherits(x, "GVector")) {
		x <- sources(x)
		rastOrVect <- "vector"
	}

	if (is.null(rastOrVect)) stop("Cannot determine if x is a raster or vector. Use argument rastOrVect.")
	rastOrVect <- omnibus::pmatchSafe(rastOrVect, c("raster", "vector"), nmax = 1L)

	if (rastOrVect == "raster") {
		info <- .rastInfo(x)
	} else {
		info <- .vectInfo(x)
	}

	c(xmin = info$west, xmax = info$east, ymin = info$south, ymax = info$north)	

}

# #' @aliases st_bbox
# #' @rdname ext
# #' @exportMethod st_bbox
# methods::setMethod(
#     f = "st_bbox",
#     signature = c(obj = "missing"),
#     function(obj, ...) {
#         out <- ext(vector = TRUE)
#         names(out) <- c("xmin", "xmax", "ymin", "ymax")
#         sf::st_bbox(out, crs = st_crs())
#     } # EOF
# )

# #' @aliases st_bbox
# #' @rdname ext
# #' @exportMethod st_bbox
# methods::setMethod(
# 	f = "st_bbox",
# 	signature = c(obj = "GSpatial"),
# 	function(obj, ...) {

# 	out <- obj@extent
# 	names(out) <- c('xmin', 'xmax', 'ymin', 'ymax')
# 	sf::st_bbox(out, crs = st_crs(obj))
	
# 	} # EOF
# )

# #' @rdname ext
# #' @export
# st_bbox <- function(obj, ...) {
# 	dots <- list(...)
# 	if (any(names(dots) == "vector")) {
# 		vector <- dots$vector
# 	} else {
# 		vector <- FALSE
# 	}
#     if (missing(obj)) obj <- .region()
#     if (inherits(obj, "GSpatial")) {
#         out <- obj@extent
#         out <- c(out[1L], out[3L], out[2L], out[4L])
#         names(out) <- c("xmin", "ymin", "xmax", "ymax")
#         if (!vector) out <- sf::st_bbox(out, crs = st_crs(obj))
#     } else {
#         out <- sf::st_bbox(obj, ...)
#         if (vector) out <- as.vector(out)
#     }
#     out
# }

# #' @rdname ext
# #' @exportMethod st_bbox
# setMethod("st_bbox", definition = function(obj, ...) st_bbox(obj, ...))

# st_bbox <- function(obj, ...) UseMethod("st_bbox", obj)

# #' @aliases st_bbox
# #' @rdname ext
# #' @export
# st_bbox <- function(obj, ...) UseMethod("st_crs", obj)
