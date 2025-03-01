#' Number of categories in a categorical raster
#'
#' @description This function reports the number of categories (levels) in a categorical `GRaster`.
#'
#' @param x A `GRaster`.
#'
#' @return A named, numeric vector of integers. The values represent the number of categories (rows) that appear in the raster's levels table.
#'
#' @seealso [levels()], [terra::levels()], [droplevels()], `vignette("GRasters", package = "fasterRaster")`
#'
#' @example man/examples/ex_GRaster_categorical.r
#'
#' @aliases nlevels
#' @rdname nlevels
#' @exportMethod nlevels
setMethod(
    f = "nlevels",
    signature = "GRaster",
    definition = function(x) {

	out <- sapply(x@levels, nrow)
	names(out) <- names(x)
	out

	} # EOF
)

#' Count number of levels from a data.frame/table, list, or SpatRaster
#'
#' @description Counts number of levels in a character string (specifically, the empty string `""`), a `data.frame`, `data.table`, or list of `data.frame`s or `data.table`s or empty strings.
#'
#' @param x A `GRaster`, `SpatRaster`, *or* a `data.frame`, `data.table`, an empty string, or a list thereof.
#'
#' @keywords internal
.nlevels <- function(x) {

	if (inherits(x, c("SpatRaster", "GRaster"))) x <- levels(x)
	
	if (!is.list(x)) x <- list(x)
	n <- rep(NA_integer_, length(list))

	for (i in seq_along(x)) {
	
		if (inherits(x[[i]], "character")) {
			if (is.null(x[[i]]) || x[[i]] == "") {
				n[i] <- 0L
			} else {
				stop("Argument x must be a data frame, data table, an empty string or a list of any of these.")
			}
		} else if (inherits(x[[i]], c("data.frame", "data.table"))) {
			n[i] <- nrow(x[[i]])
		}
	}
	n

}
