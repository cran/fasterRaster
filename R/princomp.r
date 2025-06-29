#' Apply a principal component analysis (PCA) to layers of a GRaster
#'
#' @description This function applies a principal component analysis to layers of a `GRaster`.
#' 
#' @param x A `GRaster` with two or more layers.
#' 
#' @param scale Logical: If `TRUE` (default), input layers will be rescaled by dividing each layer by its overall population standard deviation. Rasters will always be centered (have their mean subtracted from values). Centering and scaling is recommended when rasters values are in different units.
#'
#' @param scores Logical: If `TRUE`, the `prcomp` object will have the scores attached to it. This can greatly increase the size of the object in memory if the input raster has many cells. It will also take more time. If `FALSE` (default), then skip returning scores.
#' 
#' @returns A multi-layer `GRaster` with one layer per principal component axis. The [pcs()] function can be used on the output raster to retrieve a `prcomp` object from the raster, which includes rotations (loadings) and proportions of variance explained.
#' 
#' @seealso [terra::princomp()], [terra::prcomp()]
#' 
#' @example man/examples/ex_princomp.r
#' 
#' @aliases princomp
#' @rdname princomp
#' @exportMethod princomp
methods::setMethod(
	f = "princomp",
	signature = c(x = "GRaster"),
	function(x, scale = TRUE, scores = FALSE) {

	if (nlyr(x) < 2L) stop("Input raster must have 2 or more layers.")

	.locationRestore(x)
	.region(x)

	input <- paste(sources(x), collapse = ",")
	src <- .makeSourceName("i_pca", "raster")

	args <- list(
		cmd = "i.pca",
		input = input,
		output = src,
		rescale = c(0, 0),
		flags = c(.quiet(), "overwrite"),
		intern = TRUE
	)

	if (scale) args$flags <- c(args$flags, "n")

	# execute PCA and get rasters
	info <- do.call(rgrass::execGRASS, args = args)
	layers <- 1L:nlyr(x)
	srcs <- paste0(src, ".", layers)
	out <- .makeGRaster(srcs, paste0("PC", layers))

	### get PCA information
	#######################

	n <- nlyr(x)

	# standard deviations
	sdev <- rep(NA_real_, n)

	# rotations
	rotation <- matrix(NA_real_, nrow = n, ncol = n, dimnames = list(names(x), names(out)))

	for (pc in layers) {
		
		this <- info[pc]

		# standard deviation
		start <- regexpr(this, pattern = " ")[1L] + 1L
		stop <- regexpr(this, pattern = "\\(")[1L] - 1L
		var <- substr(this, start, stop)
		var <- as.numeric(var)
		sd <- sqrt(var)
		sdev[pc] <- sd

		# rotations
		start <- regexpr(this, pattern = "\\(")[1L] + 1L
		end <- regexpr(this, pattern = ")")[1L] - 1L
		rots <- substr(this, start, end)
		rots <- strsplit(rots, ",")[[1L]]
		rots <- as.numeric(rots)

		rotation[ , pc] <- rots

	}

	# center
	center <- global(x, "mean")
	center <- c(center)[[1L]]
	names(center) <- names(x)

	# scale
	if (!scale) {
		scale <- FALSE
	} else {
		scale <- global(x, "sd")
		scale <- c(scale)[[1L]]
		names(scale) <- names(x)
	}

	pca <- list(
		sdev = sdev,
		rotation = rotation,
		center = center,
		scale = scale
	)

	# return scores
	if (scores) {

		sc <- as.points(out, values = TRUE)
		sc <- as.data.table(sc)
		sc <- as.matrix(sc)
		pca$scores <- sc

	}

	class(pca) <- "prcomp"
	attr(out, "pca") <- pca
	out

	} # EOF
)

#' Retrieve a principal components model from a PCA GRaster
#' 
#' @param x A `GRaster` created by [princomp()] 
#' 
#' @returns An object of class `prcomp`.
#' 
#' @seealso [princomp()], [terra::princomp()], tool `i.pca` in **GRASS**
#' 
#' @example man/examples/ex_princomp.r
#'
#' @aliases pcs
#' @rdname pcs
#' @export
pcs <- function(x) attr(x, "pca")
