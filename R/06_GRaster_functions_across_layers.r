#' @title Mathematical operations on two or more GRasters
#'
#' @description These functions can be applied to a "stack" of `GRaster`s with two or more layers. They return a single-layered `GRaster`.  If you want to summarize across cells in a raster (e.g., calculate the mean value of all cells on a raster), use [global()]. Options include:
#' * Numeration: `count()` (number of non-`NA` cells), `sum()`.
#' * Central tendency: `mean()`, `mmode()` (mode), `median()`.
#' * Extremes: `min()`, `max()`, `which.min()` (index of raster with the minimum value), `which.max()` (index of the raster with the maximum value)
#' * Dispersion: `range()`, `stdev()` (standard deviation), `var()` (sample variance), `varpop()` (population variance), `nunique()` (number of unique values), `quantile()` (use argument `probs`), `skewness()`, and `kurtosis()`.
#' * `NA`s: `anyNA()` (any cells are `NA`?), `allNA()` (are all cells `NA`?)
#'
#' @param x A `GRaster`. Typically, this raster will have two or more layers. Values will be calculated within cells across rasters.
#'
#' @param prob Numeric: Quantile to calculate. Used for `quantile()`.
#'
#' @param pop Logical (for `stdev()`): If `TRUE` (default), calculate the population standard deviation across layers. If `FALSE`, calculate the sample standard deviation.
#'
#' @param na.rm Logical: If `FALSE` (default), of one cell value has an `NA`, the result will be `NA`. If `TRUE`, `NA`s are ignored.
#'
#' @returns A `GRaster`.
#'
#' @example man/examples/ex_GRaster_arithmetic_across_layers.r
#'
#' @aliases mean
#' @rdname functions
#' @exportMethod mean
setMethod(
	"mean",
	signature(x = "GRaster"),
	function(x, na.rm = FALSE) {

		fx <- "average"
		fxName <- "mean"
		.genericMultiLayer(fx = fx, fxName = fxName, x = x, na.rm = na.rm)
		
	} # EOF
)

#' @aliases mmode
#' @rdname functions
#' @exportMethod mmode
setMethod(
	"mmode",
	signature(x = "GRaster"),
	function(x, na.rm = FALSE) {

	fx <- "mode"
	fxName <- "mode"
	.genericMultiLayer(fx = fx, fxName = fxName, x = x, na.rm = na.rm)
	
	} # EOF
)

#' @aliases median
#' @rdname functions
#' @exportMethod median
setMethod(
	"median",
	signature(x = "GRaster"),
	function(x, na.rm = FALSE) {

		fx <- "median"
		fxName <- "median"
		.genericMultiLayer(fx = fx, fxName = fxName, x = x, na.rm = na.rm)
		
	} # EOF
)

#' @aliases count
#' @rdname functions
#' @exportMethod count
setMethod(
	"count",
	signature(x = "GRaster"),
	function(x) {

		fx <- "count"
		fxName <- "count"
		.genericMultiLayer(fx = fx, fxName = fxName, x = x, na.rm = TRUE)
		
	} # EOF
)

#' @aliases sum
#' @rdname functions
#' @exportMethod sum
setMethod(
	"sum",
	signature(x = "GRaster"),
	function(x, na.rm = FALSE) {

		fx <- "sum"
		fxName <- "sum"
		.genericMultiLayer(fx = fx, fxName = fxName, x = x, na.rm = na.rm)
		
	} # EOF
)

#' @aliases min
#' @rdname functions
#' @exportMethod min
setMethod(
	"min",
	signature(x = "GRaster"),
	function(x, na.rm = FALSE) {

		fx <- "minimum"
		fxName <- "min"
		.genericMultiLayer(fx = fx, fxName = fxName, x = x, na.rm = na.rm)
		
	} # EOF
)

#' @aliases max
#' @rdname functions
#' @exportMethod max
setMethod(
	"max",
	signature(x = "GRaster"),
	function(x, na.rm = FALSE) {

		.locationRestore(x)
		
		fx <- "maximum"
		fxName <- "max"
		.genericMultiLayer(fx = fx, fxName = fxName, x = x, na.rm = na.rm)
		
	} # EOF
)

#' @aliases which.min
#' @rdname functions
#' @exportMethod which.min
setMethod(
	"which.min",
	signature(x = "GRaster"),
	function(x) {

		fx <- "min_raster"
		fxName <- "whichmin"
		out <- .genericMultiLayer(fx = fx, fxName = fxName, x = x, na.rm = TRUE)
		out + 1
		
	} # EOF
)

#' @aliases which.max
#' @rdname functions
#' @exportMethod which.max
setMethod(
	"which.max",
	signature(x = "GRaster"),
	function(x) {

		fx <- "max_raster"
		fxName <- "whichmax"
		out <- .genericMultiLayer(fx = fx, fxName = fxName, x = x, na.rm = TRUE)
		out + 1
		
	} # EOF
)

#' @aliases sdpop
#' @rdname functions
#' @exportMethod sdpop
setMethod(
	"sdpop",
	signature(x = "numeric"),
	function(x, na.rm = FALSE) {
	sqrt(varpop(x, na.rm = na.rm))
	} # EOF
)

#' @aliases varpop
#' @rdname functions
#' @exportMethod varpop
setMethod(
	"varpop",
	signature(x = "GRaster"),
	function(x, na.rm = FALSE) {

		fx <- "variance"
		fxName <- "varpop"
		.genericMultiLayer(fx = fx, fxName = fxName, x = x, na.rm = na.rm)
		
	} # EOF
)

#' @aliases varpop
#' @rdname functions
#' @exportMethod varpop
setMethod(
	"varpop",
	signature(x = "numeric"),
	function(x, na.rm = FALSE) {

	if (na.rm & anyNA(x)) x <- x[!is.na(x)]
	ss <- sum((x - mean(x))^2)
	n <- length(x)
	ss / n
		
	} # EOF
)

#' @aliases stdev
#' @rdname functions
#' @exportMethod stdev
setMethod(
	"stdev",
	signature(x = "GRaster"),
	function(x, pop = TRUE, na.rm = FALSE) {

	.locationRestore(x)
	.region(x)

	# sample standard deviation
	if (!pop) {

		# sum of squares
		srcSS <- .makeSourceName("ss", "raster")
		srcMean <- .genericMultiLayer(fx = "average", fxName = "mean", x = x, na.rm = na.rm, return = "source")
		ex <- paste0(srcSS, " = ", paste0("(", sources(x), " - ", srcMean, ")^2", collapse=" + "))
		rgrass::execGRASS(
			cmd = "r.mapcalc",
			expression = ex,
			flags = c(.quiet(), "overwrite")
		)

		# N
		srcCount <- .genericMultiLayer(fx = "count", fxName = "count", x = x, na.rm = na.rm, return = "source")
		srcCountMinus1 <- .makeSourceName("nMinus1", "rast")
		ex <- paste0(srcCountMinus1, " = ", srcCount, " - 1")
		rgrass::execGRASS(
			cmd = "r.mapcalc",
			expression = ex,
			flags = c(.quiet(), "overwrite")
		)

		# SD
		prec <- .getPrec(x, NULL)

		src <- .makeSourceName("sd", "rast")
		ex <- paste0(src, " = ", prec, "(sqrt(", srcSS, " / ", srcCountMinus1, "))")
		
		rgrass::execGRASS(
			cmd = "r.mapcalc",
			expression = ex,
			flags = c(.quiet(), "overwrite")
		)

		.rm(c(srcSS, srcCount), type = "raster", warn = FALSE)

		out <- .makeGRaster(src, "sd")

	# population standard deviation
	} else {
	
		fx <- "stddev"
		fxName <- "sdpop"
		out <- .genericMultiLayer(fx = fx, fxName = fxName, x = x, na.rm = na.rm)
		
	}
	out
	
	} # EOF
)

#' @aliases var
#' @rdname functions
#' @exportMethod var
setMethod(
	"var",
	signature(x = "GRaster"),
	function(x, na.rm = FALSE) {

	.locationRestore(x)
	.region(x)

	# sum of squares
	srcSS <- .makeSourceName("ss", "rast")
	srcMean <- .genericMultiLayer(fx = "average", fxName = "mean", x = x, na.rm = na.rm, return = "source")
	ex <- paste0(srcSS, " = ", paste0("(", sources(x), " - ", srcMean, ")^2", collapse=" + "))
	rgrass::execGRASS(
		cmd = "r.mapcalc",
		expression = ex,
		flags = c(.quiet(), "overwrite")
	)

	# N
	srcCount <- .genericMultiLayer(fx = "count", fxName = "count", x = x, na.rm = na.rm, return = "source")
	srcCountMinus1 <- .makeSourceName("nMinus1", "rast")
	ex <- paste0(srcCountMinus1, " = ", srcCount, " - 1")
	rgrass::execGRASS(
		cmd = "r.mapcalc",
		expression = ex,
		flags = c(.quiet(), "overwrite")
	)

	# variance
	prec <- .getPrec(x, NULL)

	src <- .makeSourceName("var", "rast")
	ex <- paste0(src, " = ", prec, "(", srcSS, " / ", srcCountMinus1, ")")
	
	rgrass::execGRASS(
		cmd = "r.mapcalc",
		expression = ex,
		flags = c(.quiet(), "overwrite")
	)
	
	.rm(c(srcSS, srcCount), type = "raster", warn = FALSE)
	.makeGRaster(src, "var")
		
	} # EOF
)

#' @aliases nunique
#' @rdname functions
#' @exportMethod nunique
setMethod(
	"nunique",
	signature(x = "GRaster"),
	function(x, na.rm = FALSE) {

		fx <- "diversity"
		fxName <- "nunique"
		.genericMultiLayer(fx = fx, fxName = fxName, x = x, na.rm = na.rm)
		
	} # EOF
)

#' @aliases skewness
#' @rdname functions
#' @exportMethod skewness
setMethod(
	"skewness",
	signature(x = "GRaster"),
	function(x, na.rm = FALSE) {

		fx <- "skewness"
		fxName <- "skewness"
		.genericMultiLayer(fx = fx, fxName = fxName, x = x, na.rm = na.rm)
		
	} # EOF
)

#' @aliases kurtosis
#' @rdname functions
#' @exportMethod kurtosis
setMethod(
	"kurtosis",
	signature(x = "GRaster"),
	function(x, na.rm = FALSE) {

		fx <- "kurtosis"
		fxName <- "kurtosis"
		.genericMultiLayer(fx = fx, fxName = fxName, x = x, na.rm = na.rm)
		
	} # EOF
)

#' @aliases range
#' @rdname functions
#' @exportMethod range
setMethod(
	"range",
	signature(x = "GRaster"),
	function(x, na.rm = FALSE) {

		fx <- "range"
		fxName <- "range"
		.genericMultiLayer(fx = fx, fxName = fxName, x = x, na.rm = na.rm)
		
	} # EOF
)

#' @aliases quantile
#' @rdname functions
#' @exportMethod quantile
setMethod(
	"quantile",
	signature(x = "GRaster"),
	function(x, prob, na.rm = FALSE) {

    .locationRestore(x)
    .region(x)

	fx <- "quantile"
	fxName <- "quantile"
	
	src <- .makeSourceName(fxName, "rast")
	args <- list(
		cmd = "r.series",
		input = paste(sources(x), collapse=","),
		output = src,
		method = fx,
		quantile = prob,
		nprocs = faster("cores"),
		memory = faster("memory"),
		flags = c(.quiet(), "overwrite")
	)
	
	if (na.rm) args$flags <- c(args$flags, "n")
	
	do.call(rgrass::execGRASS, args = args)
	.makeGRaster(src, fxName)
		
	} # EOF
)

#' @aliases anyNA
#' @rdname functions
#' @exportMethod anyNA
setMethod(
	"anyNA",
	signature(x = "GRaster"),
	function(x) {

    .locationRestore(x)
    .region(x)

	src <- .makeSourceName("anyNA", "raster")

	nl <- nlyr(x)
	ex <- paste0("if(isnull(", sources(x), "))")
	ex <- paste(ex, collapse = " | ")
	ex <- paste0(src, " = ", ex)
	rgrass::execGRASS("r.mapcalc", expression = ex, flags = c(.quiet(), "overwrite"))
	.makeGRaster(src, "layer")

	} # EOF
)


#' @aliases allNA
#' @rdname functions
#' @exportMethod allNA
setMethod(
	"allNA",
	signature(x = "GRaster"),
	function(x) {

    .locationRestore(x)
    .region(x)

	src <- .makeSourceName("anyNA", "raster")

	nl <- nlyr(x)
	ex <- paste0("if(isnull(", sources(x), "))")
	ex <- paste(ex, collapse = " & ")
	ex <- paste0(src, " = ", ex)
	rgrass::execGRASS("r.mapcalc", expression = ex, flags = c(.quiet(), "overwrite"))
	.makeGRaster(src, "layer")

	} # EOF
)



# generic function for multi-layer functions
# fx: name of GRASS function
# fxName: stub name of output raster
# x: GRaster
# na.rm: T/F
# return: "GRaster" or "source"
#' @noRd
.genericMultiLayer <- function(fx, fxName, x, na.rm, return = "GRaster") {

	.locationRestore(x)
	.region(x)

	src <- .makeSourceName(fx, "rast")
	args <- list(
		cmd = "r.series",
		input = paste(sources(x), collapse=","),
		output = src,
		method = fx,
		nprocs = faster("cores"),
		memory = faster("memory"),
		flags = c(.quiet(), "overwrite")
	)
	
	if (!na.rm) args$flags <- c(args$flags, "n")
	do.call(rgrass::execGRASS, args = args)

	if (return == "GRaster") {
		if (fxName %in% c("mode", "min", "max")) {
			levels <- combineLevels(x)
		} else {
			levels <- NULL
		}
		out <- .makeGRaster(src, fxName, levels = levels)
	} else if (return == "source") {
		out <- src
	} else {
		stop("Invalid value for `return`.")
	}
	out

}
