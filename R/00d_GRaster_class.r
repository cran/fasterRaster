#' @title Classes for "fasterRaster" locations, rasters, and vectors
#'
#' @aliases GRaster
#' @rdname GLocation
#' @exportClass GRaster
GRaster <- methods::setClass(
	"GRaster",
	contains = "GRegion",
	slots = list(
		projection = "character",
		datatypeGRASS = "character",
		nLayers = "integer",
		names = "character",
		minVal = "numeric",
		maxVal = "numeric",
		activeCat = "integer",
		levels = "list"
	),
	prototype = prototype(
		projection = NA_character_,
		datatypeGRASS = NA_character_,
		nLayers = NA_integer_,
		names = NA_character_,
		minVal = NA_real_,
		maxVal = NA_real_,
		activeCat = NA_integer_,
		levels = list(data.table::data.table(NULL))
	)
)

#' Evaluate the @levels column slot of a `GRaster`
#'
#' @description Test whether a list of "levels" tables is valid. First column must be integer. Must have >= 2 columns.
#' 
#' @param object A `GRaster`.
#' @returns `TRUE` if invalid, `FALSE` otherwise.
#'
#' @noRd
.validLevelTable <- function(object) {

	levels <- object@levels
	nlevs <- .nlevels(levels)

	for (i in seq_along(levels)) {
	
		nr <- nlevs[i]
	
		if (nr != 0) {
	
			if (object@datatypeGRASS[i] != "CELL") {
				return(TRUE)
			# } else if (nr == 1L) {
				# return(TRUE)
			} else if (!inherits(levels[[i]][[1L]], "integer")) {
				return(TRUE)
			}
		
		}
	
	}
	FALSE

}

#' Evaluate the @activeCat slot of a GRaster
#'
#' @description Test whether `@activeCat` values are valid.
#' 
#' @param object A `GRaster`.
#' @returns `TRUE` if invalid, `FALSE` otherwise.
#'
#' @noRd
.validActiveCat <- function(object) {

	bad <- FALSE
	numCols <- sapply(object@levels, ncol)
	
	isFact <- is.factor(object)

	if (any(isFact & is.na(object@activeCat))) {
		bad <- TRUE
	} else if (any(isFact & (object@activeCat < 1L | object@activeCat > numCols))) {
		bad <- TRUE
	}
	bad

}

#' Evaluate whether a raster's datatype can accommodate levels
#'
#' @description A `GRaster` must have the `CELL` datatype to have levels.
#' 
#' @param object A `GRaster`
#' @returns `TRUE` if invalid, `FALSE` otherwise.
#'
#' @noRd
.canMakeRasterCategorical <- function(object) {

	dt <- object@datatypeGRASS
	numLevels <- nlevels(object)
	if (any(numLevels > 0L)) {
		out <- any(dt[numLevels > 0L] != "CELL")
	} else {
		out <- FALSE
	}
	out

}

#' Test if GRaster is valid
#'
#' @noRd
methods::setValidity("GRaster",
	function(object) {
		if (!all(object@datatypeGRASS %in% c("CELL", "FCELL", "DCELL"))) {
			paste0("@datatypeGRASS can only be NA, ``CELL`, `FCELL`, or `DCELL`.")
		} else if (!is.na(object@dimensions[3L]) && object@dimensions[3L] <= 0L) {
			"Third value in @dimensions must be NA or a positive integer."
		} else if (!is.na(object@resolution[3L]) && object@resolution[3L] <= 0) {
			"Third value in @resolution must be NA or a positive real value."
		} else if (object@nLayers < 1) {
			"@nLayers must be a positive integer."
		} else if (object@nLayers != length(object@sources)) {
			"@nLayers is different from the number of @sources."
		} else if (object@nLayers != length(object@names)) {
			"@names must be @nLayers in length."
		} else if (object@nLayers != length(object@minVal)) {
			"@minVal must be @nLayers in length."
		} else if (object@nLayers != length(object@maxVal)) {
			"@maxVal must be @nLayers in length."
		} else if (length(object@activeCat) != object@nLayers) {
			"The number of @activeCat values must be the same as the number of @nLayers."
		} else if (length(object@levels) != object@nLayers) {
			"The number of tables in @levels must be the same as the number of @nLayers."
		} else if (.canMakeRasterCategorical(object)) {
			"Only rasters of datatype `CELL` can be categorical."
		} else if (.validLevelTable(object)) {
			"Each table must be a NULL `data.table`, or if not, the first column\n  must be an integer, and there must be >1 columns."
		} else if (.validActiveCat(object)) {
			"@activeCat must be `NA_integer_`, or an integer between 1 and the number of columns in each `data.table` in @levels, minus 1."
		} else {
			TRUE
		}
	} # EOF
)

#' Create a GRaster
#'
#' @description Create a `GRaster` from a raster existing in the current **GRASS** session.
#'
#' @param src Character (name of the raster in **GRASS) or a `rastInfo` object.
#' @param names Character: Name of the raster.
#' @param levels `NULL` (default), a `data.frame`, `data.table`, an empty string (`""`), or a list of `data.frame`s, `data.table`s, and/or empty strings: These become the raster's [levels()]. If `""`, then no levels are defined.
#' @param ac Vector of numeric/integer values >=1, or `NULL` (default): Active category column (offset by 1, so 1 really means the second column, 2 means the third, etc.). A value of `NULL` uses an automated procedure to figure it out.
#' @param fail Logical: If `TRUE` (default), and the raster either has a 0 east-west or north-south extent, then exit the function with an error. If `fail` is `FALSE`, then display a warning and return `NULL`.
#'
#' @returns A `GRaster`.
#'
#' @seealso [.makeGVector()]
#'
#' @keywords internal
.makeGRaster <- function(src, names = "raster", levels = "", ac = NULL, fail = TRUE) {

	if (inherits(src, "rastInfo")) {
		info <- src
		src <- info$sources
	} else {
		info <- .rastInfo(src)
	}

	if (!all(.exists(src))) stop("No raster was created in GRASS. The error is likely in the calling function.")

	# test for zero extent
	if (any(abs(info$west - info$east) < omnibus::eps()) | any(abs(info$north - info$south) < omnibus::eps())) {
		msg <- "Raster has 0 east-west extent and/or north-south extent."
		if (fail) {
			stop(msg)
		} else {
			warning(msg)
			return(NULL)
		}
	}

	# levels: convert empty strings to NULL data.tables and data.frames to data.tables
	if (is.null(levels) || all(levels == "")) levels <- data.table::data.table(NULL)
	if (!inherits(levels, "list")) levels <- list(levels)
	levels <- lapply(levels, data.table::as.data.table)
	if (length(levels) == 1L & length(src) > 1L) for (i in 2L:length(src)) levels[[i]] <- levels[[1L]]

	# active category and levels
	if (is.null(ac)) {
		
		ac <- rep(NA_integer_, length(levels))
		for (i in seq_along(levels)) {
			if (is.null(levels[[i]]) || (is.character(levels[[i]]) && levels[[i]] == "")) {
				ac[i] <- NA_integer_
				levels[[i]] <- data.table::data.table(NULL)
			} else if (!inherits(levels[[i]], "data.table")) {
				ac[i] <- 2L
				levels[[i]] <- data.table::data.table(levels[[i]])
			} else if (inherits(levels[[i]], "data.table")) {
				ac[i] <- 2L
			}
		}
	
	} else {
		ac <- as.integer(ac)
		ac <- ac + 1L
	}

	# nLayers <- length(info$sources)
	nLayers <- length(src)
	if (length(names) < nLayers) names <- rep(names, length.out = nLayers)

	out <- methods::new(
		"GRaster",
		location = .location(),
		mapset = "PERMANENT",
		workDir = faster("workDir"),
		crs = crs(),
		projection = info[["projection"]][1L],
		topology = info[["topology"]][1L],
		extent = c(info[["west"]][1L], info[["east"]][1L], info[["south"]][1L], info[["north"]][1L]),
		zextent = c(info[["zbottom"]][1L], info[["ztop"]][1L]),
		nLayers = nLayers,
		dimensions = c(info[["rows"]][1L], info[["cols"]][1L], info[["depths"]][1L]),
		resolution = c(info[["ewres"]][1L], info[["nsres"]][1L], info[["tbres"]][1L]),
		sources = src,
		names = names,
		datatypeGRASS = info[["grassDataType"]],
		minVal = info[["minVal"]],
		maxVal = info[["maxVal"]],
		activeCat = ac,
		levels = levels
	)
	out <- .makeUniqueNames(out)
	# out <- droplevels(out, layer = 1L:nLayers)
	out

}
