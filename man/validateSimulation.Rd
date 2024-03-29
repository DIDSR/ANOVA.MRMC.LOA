% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/validateSimulation.R
\name{validateSimulation}
\alias{validateSimulation}
\title{Verify the simulation is consistent with the derived theoretical values}
\usage{
validateSimulation(alpha_R.list, sigma_C.list, nTrials = 1e+05)
}
\arguments{
\item{alpha_R.list}{A \eqn{a}-dimension array for the reader related parameter}

\item{sigma_C.list}{A \eqn{b}-dimension array for the case related parameter}

\item{nTrials}{Number of independent trials. Default is 100000}
}
\value{
A dataframe with \eqn{a*b} rows. Each column is as following:
\describe{
  \item{sigma_C}{Case related parameter}
  \item{alpha_R}{Reader related parameter}
  \item{WR_mean}{Monte Carlo mean of the WRBM difference score}
  \item{WR_var}{Monte Carlo variance of the WRBM difference score}
  \item{BR_mean}{Monte Carlo mean of the BRBM difference score}
  \item{BR_var}{Monte Carlo variance of the BRBM difference score}
  \item{True_WR_var}{Theoretical value for WRBM variance derived from the simulation model}
  \item{True_BR_var}{Theoretical value for BRBM variance derived from the simulation model}
  \item{WR_var_relative_bias}{relative bias for WRBM variance}
  \item{BR_var_relative_bias}{relative bias for BRBM variance}
}
}
\description{
This function simulates independent WRBM and BRBM difference scores and outputs the Monte Carlo mean and variance
across the trials for each parameter setting. The relative bias of the Monte Carlo variance comparing to the
theoretical value of the variance is also calculated.
}
\details{
Let \eqn{\tilde{V}_{BR}^{12}} denote the Monte Carlo variance of the BRBM difference, then the relative bias is defined
as \eqn{relativeBias~(\tilde{V}_{BR}^{12})=(\tilde{V}_{BR}^{12}-V_{BR}^{12})/V_{BR}^{12}}.
}
\examples{
sigma_C.list <- c(1)
alpha_R.list <- c(10)
result <- validateSimulation(alpha_R.list, sigma_C.list, nTrials = 10)

}
