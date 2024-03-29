% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data-filter_module.R
\name{filter_ui}
\alias{filter_ui}
\alias{filter_server}
\title{Observation filtering}
\usage{
filter_ui(
  id,
  level = "Niveau",
  direction = "Balanszijde",
  dynamic = "Rechtsvorm/sector",
  examples = "Voorbeelden"
)

filter_server(
  id,
  RGS,
  external,
  iexternal = c(code = "referentiecode"),
  ivars = c(direction = "d_c", level = "nivo")
)
}
\arguments{
\item{id}{Namespace id.}

\item{level}{Name on controller ui for level in hierarchical data.}

\item{direction}{Name on controller ui for ledger side (debit or credit).}

\item{dynamic}{Name on controller ui for user supplied filters.}

\item{examples}{Name on controller ui for example ledger cases.}

\item{RGS}{Reactive value for the reference system.}

\item{external}{Reactive value for children of parent RGS.}

\item{iexternal}{Name of variable for reference codes.}

\item{ivars}{Named vector of length two for the variables associated with
\code{level} (see parameter ui above) and \code{direction} (see parameter ui above) to
filter data in the server module.}
}
\value{
Shiny GUI or server.
}
\description{
GUI and server modules for filtering RGS datasets.
}
