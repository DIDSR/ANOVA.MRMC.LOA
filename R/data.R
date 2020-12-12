#' @title{
#' Result of simulation study to verify the simulation is consistent with the derived theoretical values
#' }
#' @details
#' There are two parameter sets for this simulation:
#' \describe{
#'   \item{result.validSimulation.alphaR}{
#'     In this study, we fixed the case-related parameter but change the reader related fixed the case related
#'     parameters \eqn{\sigma_C^2=\sigma_{\tau C}^2=1} and allowed the reader related parameter \eqn{\alpha_R
#'     (=\alpha_{\tau R})} to range from 2 to 20.
#'   }
#'   \item{result.validSimulation.sigmaC}{
#'     In this study, we fixed the reader related parameters \eqn{\alpha_R=\alpha_{\tau R}=10} and allowed the
#'     case related parameter \eqn{\sigma_C^2 (=\sigma_{\tau C}^2)} to range from 0.1 to 2, incrementing by 0.1.
#'   }
#' }
#' In both parameter sets, \eqn{\beta_R=\beta_{\tau R}=1}, so that the reader variability is only affected by
#' \eqn{\alpha_R}. We simulated 100,000 trials with each trial having 4 measurements from 2 readers for a single
#' case under 2 modalities. The Monte Carlo estimates of the variances are the sample variances of the 100,000
#' independent WRBM and BRBM differences.
#'
#' @format A dataframe with the following column:
#' \describe{
#'   \item{sigma_C}{Case related parameter}
#'   \item{alpha_R}{Reader related parameter}
#'   \item{WR_mean}{Monte Carlo mean of the WRBM difference score}
#'   \item{WR_var}{Monte Carlo variance of the WRBM difference score}
#'   \item{BR_mean}{Monte Carlo mean of the BRBM difference score}
#'   \item{BR_var}{Monte Carlo variance of the BRBM difference score}
#'   \item{True_WR_var}{Theoretical value for WRBM variance derived from the simulation model}
#'   \item{True_BR_var}{Theoretical value for BRBM variance derived from the simulation model}
#'   \item{WR_var_relative_bias}{relative bias for WRBM variance}
#'   \item{BR_var_relative_bias}{relative bias for BRBM variance}
#' }
#' @references
"result.validSimulation.alphaR"

#' @rdname result.validSimulation.alphaR
"result.validSimulation.sigmaC"
#'
#'
#' @title{
#' Result of simulation study to validate and characterize the MRMC limits of agreement estimates
#' }
#' @details
#' There are three parameter sets for this simulation:
#' \describe{
#'   \item{result.validMRMCVarEstimate.nReader}{
#'     Different number of readers \eqn{J=3,4,...,10,K=100, \alpha_R=10, \sigma_C^2=1}
#'   }
#'   \item{result.validMRMCVarEstimate.nCase}{
#'     Different number of cases  \eqn{K=50,60,...,150, J=5, \alpha_R=10, \sigma_C^2=1}
#'   }
#'   \item{result.validMRMCVarEstimate.parameter}{
#'      Different reader and case variabilities \eqn{(\alpha_R,\sigma_C^2)\in\{3,4,6,11,21\}\times\{0.1,0.2,0.4,
#'      \frac{2}{3},1\}, J=5, K=100}
#'   }
#' }
#' In all the parameter sets, \eqn{\beta_R=\beta_{\tau R}=1, \alpha_R=\alpha_{\tau R}, \sigma_C^2=\sigma_{\tau C}^2}.
#' For each parameter setting, we simulate 1000 trials.
#'
#' @format A dataframe with the following columns:
#' \describe{
#'   \item{nReader}{Number of Readers}
#'   \item{nCase}{Number of Cases}
#'   \item{alpha_R}{Reader related parameter}
#'   \item{sigma_C}{Case related parameter}
#'   \item{WR_var_MCmean}{Monte Carlo mean of variance estimation for the WRBM difference score}
#'   \item{WR_var_MCvar}{Monte Carlo variance of variance estimation for the WRBM difference score}
#'   \item{True_WR_var}{Theoretical value for WRBM variance derived from the simulation model}
#'   \item{WR_var_relative_bias}{relative bias for WRBM variance}
#'   \item{WR_CV}{coefficient of variation for WRBM variance}
#'   \item{BR_var_MCmean}{Monte Carlo mean of variance estimation for the BRBM difference score}
#'   \item{BR_var_MCvar}{Monte Carlo variance of variance estimation for the BRBM difference score}
#'   \item{True_BR_var}{Theoretical value for BRBM variance derived from the simulation model}
#'   \item{BR_var_relative_bias}{relative bias for BRBM variance}
#'   \item{BR_CV}{coefficient of variation for BRBM variance}
#'   }
#' @references
"result.validMRMCVarEstimate.nReader"

#' @rdname result.validMRMCVarEstimate.nReader
"result.validMRMCVarEstimate.nCase"
#' @rdname result.validMRMCVarEstimate.nReader
"result.validMRMCVarEstimate.parameter"
