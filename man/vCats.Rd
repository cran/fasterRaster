% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vCats.r
\name{.vCats}
\alias{.vCats}
\title{Category column values of a GRASS vector}
\usage{
.vCats(x, layer = 1, db = FALSE, integer = TRUE)
}
\arguments{
\item{x}{A \code{GVector} or the name of a vector in \strong{GRASS}.}

\item{layer}{Integer, numeric integer, or character: Layer from which to obtain category values.}

\item{db}{Logical: If \code{TRUE}, return category numbers from the database table associated with the vector. If \code{FALSE} (default), return category numbers from the actual vector.}

\item{integer}{Logical: If \code{TRUE} (default), return category values as integers. In some cases, a geometry can have multiple categories, in which case \code{NA} is returned. If \code{FALSE}, return category values as strings (and thus, if a geometry has more than one category, does not convert to \code{NA}).}
}
\value{
A vector.
}
\description{
Returns values in the \code{cat} column of a vector in \strong{GRASS}.
}
\keyword{internal}
