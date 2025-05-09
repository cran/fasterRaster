#' Convert a GRaster, or lines or polygons GVector to a points vector
#'
#' @description `as.points()` converts a `GRaster`, or a lines or polygons `GVector` to a points `GVector`.
#'
#' For `GRasters`, the points have the coordinates of cell centers and are assigned the cells' values. Only non-`NA` cells will be converted to points.
#'
#' For `GVectors`, each point will have the attributes of the line or polygon to which it belonged. Points are extracted from each vertex.
#' 
#' @param x A `GRaster`, `GVector`.
#' 
#' @param values Logical: If `TRUE` (default), create an attribute table with raster cell values, with one row per point.
#' 
#' @returns A `points` `GVector`.
#' 
#' @seealso [crds()], [as.lines()], [as.polygons()], [terra::as.points()], and modules `v.to.points` and `r.to.vect` in **GRASS**
#' 
#' @example man/examples/ex_asPoints.r
#' 
#' @aliases as.points
#' @rdname as.points
#' @exportMethod as.points
methods::setMethod(
    f = "as.points",
    signature = c(x = "GRaster"),
    function(x, values = TRUE) {
        
        if (nlyr(x) > 1L) warning("Only the first layer of `x` will be converted to points.")

        .locationRestore(x)
        .region(x)

        src <- .makeSourceName("as_points_r_to_vect", "vector")

        rgrass::execGRASS(
            cmd = "r.to.vect",
            input = sources(x)[1L],
            output = src,
            type = "point",
            column = names(x)[1L],
            flags = c(.quiet(), "overwrite")
        )

        if (values) {
            table <- .vAsDataTable(src)
            table$cat <- NULL
            table$label <- NULL
        } else {
            table <- NULL
        }

        # nLayers <- nlyr(x)

        # if (nLayers > 1L & values) {
        
        #     for (i in 2L:nLayers) {

        #         thisSrc <- .makeSourceName("as_points_r_to_vect", "vector")

        #         rgrass::execGRASS(
        #             cmd = "r.to.vect",
        #             input = sources(x)[i],
        #             output = thisSrc,
        #             type = "point",
        #             column = names(x)[i],
        #             flags = c(.quiet(), "overwrite")
        #         )

        #         thisTable <- .vAsDataTable(thisSrc)
        #         cols <- names(x)[i]
        #         thisTable <- thisTable[ , ..cols]

        #         table <- cbind(table, thisTable)

        #     }
        
        # } # next layer

        .makeGVector(src, table = table)

    } # EOF
)

#' @aliases as.points
#' @rdname as.points
#' @exportMethod as.points
methods::setMethod(
    f = "as.points",
    signature = c(x = "GVector"),
    function(x) {

    gtype <- geomtype(x, grass = TRUE)
    if (gtype == "point") {
        warning("Vector object is already a points object.")
        return(x)
    }

    .locationRestore(x)

    src <- .makeSourceName("as_points_v_to_points", "vector")
    args <- list(
        cmd = "v.to.points",
        input = sources(x),
        output = src,
        use = "vertex",
        type = gtype,
        flags = c(.quiet(), "overwrite")
    )
    do.call(rgrass::execGRASS, args = args)
    .makeGVector(src, table = NULL)

    } # E#OF
)

