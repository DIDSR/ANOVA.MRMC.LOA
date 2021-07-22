#' Verify the simulation is consistent with the derived theoretical values
#'
#' @description
#' This function simulates independent WRBM and BRBM difference scores and outputs the Monte Carlo mean and variance
#' across the trials for each parameter setting. The relative bias of the Monte Carlo variance comparing to the
#' theoretical value of the variance is also calculated.
#'
#' @details
#' Let \eqn{\tilde{V}_{BR}^{12}} denote the Monte Carlo variance of the BRBM difference, then the relative bias is defined
#' as \eqn{relativeBias~(\tilde{V}_{BR}^{12})=(\tilde{V}_{BR}^{12}-V_{BR}^{12})/V_{BR}^{12}}.
#'
#' @param alpha_R.list
#' A \eqn{a}-dimension array for the reader related parameter
#' @param sigma_C.list
#' A \eqn{b}-dimension array for the case related parameter
#' @param nTrials
#' Number of independent trials. Default is 100000
#'
#' @return
#' A dataframe with \eqn{a*b} rows. Each column is as following:
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
#' @export
#' @importFrom stats var
#'
#' @examples
#' sigma_C.list <- c(1)
#' alpha_R.list <- c(10)
#' #result <- validateSimulation(alpha_R.list, sigma_C.list)
#'
validateSimulation <- function(alpha_R.list, sigma_C.list, nTrials = 100000){
  # For the independent simulation, we simulate 2 readers and 1 case
  nR = 2
  nC = 1

  result = NULL
  # RNG ----
  RNGkind("L'Ecuyer-CMRG")
  set.seed(1)

  for(sigma_C in sigma_C.list){
    for(alpha_R in alpha_R.list){

      # Config ----
      config = iMRMC::sim.NormalIG.Hierarchical.config(nR=nR, nC=nC, sigma_C = sigma_C,
                                           alpha_R = alpha_R, C_dist = 'normal',
                                           modalityID = c("testA","testB"))

      configs.Task = rep(list(config),nTrials)

      # Simulation ----

      dFrames = lapply(configs.Task, FUN = iMRMC::sim.NormalIG.Hierarchical)

      # Calculate independent WRBR and BRBR independence ----
      Results.WR = lapply(dFrames, FUN = function(x){
        WR_diff <- x[x$readerID == 'reader1' & x$caseID == 'Case1' & x$modalityID == 'testA','score']-
          x[x$readerID == 'reader1' & x$caseID == 'Case1' & x$modalityID == 'testB','score']
        return(WR_diff)
      })
      Results.BR = lapply(dFrames, FUN = function(x){
        BR_diff <- x[x$readerID == 'reader1' & x$caseID == 'Case1' & x$modalityID == 'testA','score']-
          x[x$readerID == 'reader2' & x$caseID == 'Case1' & x$modalityID == 'testB','score']
        return(BR_diff)
      })

      # Aggregate ----

      WR_mean <- mean(array(unlist(Results.WR)))
      WR_var <- var(array(unlist(Results.WR)))

      BR_mean <- mean(array(unlist(Results.BR)))
      BR_var <- var(array(unlist(Results.BR)))

      # Theoretical value ----

      True_WR_var <- 2*sigma_C^2 + 2/(alpha_R-1)
      True_BR_var <- 2*sigma_C^2 + 4/(alpha_R-1)

      # Relative bias ----

      WR_var_relative_bias <- (WR_var - True_WR_var)/True_WR_var
      BR_var_relative_bias <- (BR_var - True_BR_var)/True_BR_var

      result <- rbind(result, data.frame(sigma_C=sigma_C, alpha_R=alpha_R, WR_mean = WR_mean, WR_var = WR_var,
                                         BR_mean = BR_mean, BR_var = BR_var, True_WR_var = True_WR_var,
                                         True_BR_var=True_BR_var, WR_var_relative_bias=WR_var_relative_bias,
                                         BR_var_relative_bias = BR_var_relative_bias))
    }
  }
  return(result)
}
