#' Remove parts of a GRaster or GVector
#'
#' `crop()` removes parts of a `GRaster` or `GVector` that fall "outside" another raster or vector. You cannot make the `GRaster` or `GVector` larger than it already is (see [extend()]). Rasters may not be cropped to the exact extent, as the extent will be enlarged to encompass an integer number of cells. If you wish to remove certain cells of a raster, see [mask()].
#'
#' @param x A `GRaster` or `GVector` to be cropped.
#' @param y A `GRaster` or `GVector` to serve as a template for cropping.
#' @param extent Logical:
#' * If `y` is a "points" `GVector`: Use the convex hull around `y` to crop `x`.
#' * If `y` is a "lines" or "polygons" `GVector`: If `TRUE`, use the extent of `y` to crop `x`.
#' * if `y` is a `GVector`, `x` will be cropped to the extent of `y` (`extent` is ignored).
#' @param fail Logical: If `TRUE` (default), and the cropped object would have zero extent in at least one dimension, then exit the function with an error. If `FALSE`, then display a warning and return `NULL`.
#'  
#' @details Known differences from [terra::crop()]:
#' * If `x` and `y` are "points" vectors, and `extent` is `TRUE`, **terra** removes points that fall on the extent boundary. **fasterRaster** does not remove points on the extent boundary.
#' * If `x` is a "points" vector and `y` is a "lines" vectors, and `extent` is `FALSE`, **terra** uses the extent of `y` to crop the points.  **fasterRaster** uses the minimum convex hull of the lines vector.
#'
#' @return A `GRaster` or `GVector` (or `NULL` if `fail` is `FALSE` and the output would have a zero east-west and/or north-south extent).
#' 
#' @seealso [terra::crop()], [sf::st_crop()]
#' 
#' @example man/examples/ex_crop.r
#'
#' @aliases crop
#' @rdname crop
#' @exportMethod crop
methods::setMethod(
	f = "crop",
	signature = c(x = "GRaster"),
	definition = function(x, y, fail = TRUE) {
	
	if (inherits(y, "GVector")) {
		compareGeom(x, y)
	} else {
		if (crs(x) != crs(y)) stop("Rasters have different coordinate references systems.")
	}
	.locationRestore(x)

	### change region to match the extent of y but have the same resolution and registration as x
	if (W(y) <= W(x)) {
		w <- W(y)
	} else {
  		cells <- (W(y) - W(x)) / xres(x)
  		if (!omnibus::is.wholeNumber(cells)) {
			cells <- ceiling(cells)
		} else {
			cells <- round(cells)
		}
  		w <- W(x) + cells * xres(x)
	}

	if (E(y) >= E(x)) {
		e <- E(x)
	} else {
  		cells <- (E(x) - E(y)) / xres(x)
		if (inherits(y, "GVector")) {
			cells <- floor(cells)
		} else if (inherits(y, "GRaster")) {
   			if (omnibus::is.wholeNumber(cells)) {
				cells <- round(cells)
			} else {
				cells <- floor(cells)
			}
		}
  		e <- E(x) - cells * xres(x) # !!!???
	}

	if (S(y) <= S(x)) {
		s <- S(x)
	} else {
  		cells <- (S(y) - S(x)) / yres(x)
  		if (inherits(y, "GVector")) {
			cells <- floor(cells)
		} else if (inherits(y, "GRaster")) {
   			if (omnibus::is.wholeNumber(cells)) {
				cells <- round(cells)
			} else {
				cells <- ceiling(cells)
			}
		}
  		s <- S(x) + cells * yres(x) # !!!???
	}

	if (N(y) >= N(x)) {
		n <- N(x)
	} else {
  		cells <- (N(x) - N(y)) / yres(x)
		if (inherits(y, "GVector")) {
			cells <- floor(cells)
		} else if (inherits(y, "GRaster")) {
   			if (omnibus::is.wholeNumber(cells)) {
				cells <- round(cells)
			} else {
				cells <- ceiling(cells)
			}
		}
  		n <- N(x) - cells * yres(x)
	}

	w <- as.character(w)
	e <- as.character(e)
	s <- as.character(s)
	n <- as.character(n)
	ewres <- as.character(xres(x))
	nsres <- as.character(yres(x))

	rgrass::execGRASS(
		cmd = "g.region",
		w = w, e = e, s = s, n = n,
		ewres = ewres, nsres = nsres,
		flags = c(.quiet(), "overwrite")
	)

	### crop by creating copy of focal raster
	srcs <- .copyGSpatial(x, reshapeRegion = FALSE)
	.makeGRaster(srcs, names(x), levels = cats(x), ac = activeCats(x), fail = fail)

	} # EOF
)

#' @aliases crop
#' @rdname crop
#' @exportMethod crop
methods::setMethod(
	f = "crop",
	signature = c(x = "GVector"),
	definition = function(x, y, extent = FALSE, fail = TRUE) {

	compareGeom(x, y)
	.locationRestore(x)

	### crop
	src <- .makeSourceName("crop", "vector")
	if (inherits(y, "GVector")) {

		xgeom <- geomtype(x, grass = TRUE)
		ygeom <- geomtype(y, grass = TRUE)

		args <- list(
			cmd = "v.clip",
			input = sources(x),
			output = src,
			flags = c(.quiet(), "overwrite"),
			intern = TRUE
		)
		
		if (extent) {
			.regionExt(y, respect = "dim")
			args$flags <- c(args$flags, "r")
			args$clip <- sources(y)
		} else if (ygeom %in% c("point", "line")) {
			ch <- convHull(y)
			args$clip <- sources(ch)
		} else if (ygeom == "area") {
			args$clip <- sources(y)
		}

	} else if (inherits(y, "GRaster")) {

		.region(y)
		args <- list(
			cmd = "v.clip",
			input = sources(x),
			clip = sources(y),
			output = src,
			flags = c("r", .quiet(), "overwrite")
		)

	}

	do.call(rgrass::execGRASS, args = args)
	.makeGVector(src, fail = fail)

	} # EOF
)
