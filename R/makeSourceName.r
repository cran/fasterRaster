#' Make unique GRASS name for rasters, vectors, etc.
#'
#' @param x Character or `NULL`: Descriptive string. **Developers, please note**: To assist with debugging, **GRASS** objects created by a **GRASS** tool have the tool named in this argument (with underscores). Example: "v_in_ogr" or "r_resample".
#' 
#' @param type Character: `raster`, `raster3D`, `vector`, or `table`.
#' 
#' @param n Numeric integer: Number of names to make
#'
#' @param name `NULL` (default) or `character`: Name of the output, attached as an attribute.
#' 
#' @returns Character vector.
#' 
#' @keywords internal
.makeSourceName <- function(x = NULL, type = NULL, n = 1L, name = NULL) {

	if (is.null(x) & is.null(type)) stop("Both `x` and `type` cannot be NULL at the same time.")

 	type <- tolower(type)

	names <- ""
	if (!is.null(x)) {
		if (inherits(x, "SpatRaster")) {
			
			type <- "raster"
			names <- names(x)
			names <- .fixNames(names)
			n <- terra::nlyr(x)
			
		} else if (inherits(x, "GRaster")) {

			type <- "raster"
			names <- names(x)
			names <- .fixNames(names)
			n <- nlyr(x)

		} else if (inherits(x, c("SpatVector", "sf"))) {
			type <- "vector"
		} else if (inherits(x, "character")) {
			type <- x
		}
	} else {
		type <- omnibus::pmatchSafe(type, c("raster", "raster3d", "vector", "group", "region", "table"))
	}

	type[type == "raster3d"] <- "rast3d"
	type[type %in% c("GRaster", "raster")] <- "rast"
	type[type %in% c("GVector", "vector")] <- "vect"
 	type[type == "group"] <- "group"
	type[type == "region"] <- "region"
	type[type == "table"] <- "table"

	src <- omnibus::rstring(1L)
	if (n > 1L) src <- paste0(src, "_", 1L:n)
	src <- if (names[1L] != "") {
  		paste0(type, "_", names, "_", src)
	} else {
  		paste0(type, "_", src)
	}
	if (!is.null(name)) names(src) <- name
	src

}

.fixNames <- function(names) {

	names <- gsub(names, pattern = " ", replacement="_")
	names <- gsub(names, pattern = "\\.", replacement="_")
	names <- gsub(names, pattern = "\\+", replacement="_")
	names <- gsub(names, pattern = "-", replacement="_")
	names <- gsub(names, pattern = "\\?", replacement="_")
	names <- gsub(names, pattern = "!", replacement="_")
	names <- gsub(names, pattern = "\\*", replacement="_")
	names <- gsub(names, pattern = "\\(", replacement="_")
	names <- gsub(names, pattern = "\\)", replacement="_")
	names <- gsub(names, pattern = "\\[", replacement="_")
	names <- gsub(names, pattern = "\\]", replacement="_")
	names <- gsub(names, pattern = "\\|", replacement="_")
	names <- gsub(names, pattern = "@", replacement="_")
	names <- gsub(names, pattern = "\\$", replacement="_")
	names <- gsub(names, pattern = "#", replacement="_")
	names <- gsub(names, pattern = "%", replacement="_")
	names <- gsub(names, pattern = "\\^", replacement="_")
	names <- gsub(names, pattern = "&", replacement="_")
	names <- gsub(names, pattern = "=", replacement="_")
	names <- gsub(names, pattern = "\\'", replacement="_")
	names <- gsub(names, pattern = "\\{", replacement="_")
	names <- gsub(names, pattern = "}", replacement="_")
	names <- gsub(names, pattern = ";", replacement="_")
	names <- gsub(names, pattern = ":", replacement="_")
	names <- gsub(names, pattern = "<", replacement="_")
	names <- gsub(names, pattern = ">", replacement="_")
	names <- gsub(names, pattern = "/", replacement="_")
	names <- gsub(names, pattern = "`", replacement="_")
	names <- gsub(names, pattern = "~", replacement="_")
	names

}
