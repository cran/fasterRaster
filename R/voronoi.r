#' Voronoi tessellation
#'
#' @description This function creates a Voronoi tessellation from a set of spatial points or polygons.
#'
#' @param x A `GVector` "points" object.
#' @param buffer Numeric: By default, this function creates a vector that has an extent exactly the same as the input data. However, the apparent extent can be changed by setting this value to a value different from 0. Negative values reduce the size of the extent, and positive extend it.  Units are in map units.
#'
#' @returns A `GVector`.
#'
#' @seealso [terra::voronoi()], [sf::st_voronoi()], tool `v.voronoi` in **GRASS**
#'
#' @example man/examples/ex_delaunay_voronoi.r
#'
#' @aliases voronoi
#' @rdname voronoi
#' @exportMethod voronoi
methods::setMethod(
	f = "voronoi",
	signature = c(x = "GVector"),
	definition = function(x, buffer = 0) {

	if (!(geomtype(x) %in% c("points", "polygons"))) stop("The vector must represent spatial points or polygons.")
	
	.locationRestore(x)

	# do not expand region beyond x
	.regionExt(x, respect = "dimensions")
	if (buffer != 0) {
		
		# set region extent to buffered vector
		extent <- .regionExt()
		w <- extent["xmin"]
		e <- extent["xmax"]
		s <- extent["ymin"]
		n <- extent["ymax"]
		
		w <- w - buffer
		e <- e + buffer
		s <- s - buffer
		n <- n + buffer
		
		w <- as.character(w)
		e <- as.character(e)
		s <- as.character(s)
		n <- as.character(n)
		
		rgrass::execGRASS("g.region", n = n, s = s, e = e, w = w, flags = c("o", .quiet(), "overwrite"))
		
	}

	src <- .makeSourceName("v_voronoi", "vect")
	args <- list(
		cmd = "v.voronoi",
		input = sources(x),
		output = src,
		flags = c(.quiet(), "overwrite")
	)

	if (geomtype(x) == "polygons") args$flags <- c(args$flags, "a")

	do.call(rgrass::execGRASS, args = args)
	.makeGVector(src)
	
	} # EOF
)
