#' Validate and characterize the MRMC limits of agreement estimates
#'
#' @description
#' This function simulates MRMC study with \code{nReader} readers and \code{nCase} cases. From the output of \code{laWRBM.anova}
#' and \code{laBRBM.anova}, we exact the variance estimations for WRBM and BRBM differences. It outputs the Monte Carlo
#' mean of the variance estimation across all the simulation trials. The relative bias of the Monte Carlo mean comparing
#' to the theoretical value of the variance and the coefficient of variation is also calculated.
#'
#' @details
#' Let \eqn{\hat{V}_{BR}^{12}} denote the estimation of the variance for the BRBM difference for each simulated MRMC study, then
#' the relative bias is defined as \eqn{relativeBias~(\hat{V}_{BR}^{12})=(\sum{\hat{V}_{BR}^{12}}/{nTrials}-V_{BR}^{12})/V_{BR}^{12}},
#' and the coefficient of variantion is defined as \eqn{CV~(\hat{V}_{BR}^{12})=sd(\hat{V}_{BR}^{12})/{V_{BR}^{12}}}, where \eqn{sd()}
#' denote sample standard deviation.
#'
#' @param nR.list
#' A \eqn{r}-dimension array for the number of readers in each MRMC study
#' @param nC.list
#' A \eqn{c}-dimension array for the number of cases in each MRMC study
#' @param alpha_R.list
#' A \eqn{a}-dimension array for the reader related parameter
#' @param sigma_C.list
#' A \eqn{b}-dimension array for the case related parameter
#' @param nTrials
#' Number of MRMC simulations. Default is 1000
#'
#' @return
#' A dataframe with \eqn{r*c*a*b} rows. Each column is as following:
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
#' @export
#' @importFrom stats var
#'
#' @examples
#' nR.list <- c(5)
#' nC.list <- c(100)
#' sigma_C.list <- c(1)
#' alpha_R.list <- c(10)
#' result <- validateMRMCVarEstimation(nR.list, nC.list, alpha_R.list, sigma_C.list, nTrials = 10)
#'
validateMRMCVarEstimation <- function(nR.list, nC.list, alpha_R.list, sigma_C.list, nTrials = 1000){

  agg_result <- NULL
  # RNG ----
  RNGkind("L'Ecuyer-CMRG")
  set.seed(1)

  for (nR in nR.list){
    for (nC in nC.list){
      for(alpha_R in alpha_R.list){
        for(sigma_C in sigma_C.list){
          # Config ----

          config = sim.NormalIG.Hierarchical.config(nR=nR, nC=nC, sigma_C = sigma_C,
                                               alpha_R = alpha_R, C_dist = 'normal',
                                               modalityID = c("testA","testB"))

          configs.Task = rep(list(config),nTrials)

          # Simulation & LOA ----

          dFrames = lapply(configs.Task, FUN = sim.NormalIG.Hierarchical)
          Results.WR = lapply(dFrames, FUN = laWRBM.anova)
          Results.BR = lapply(dFrames, FUN = laBRBM.anova)

          # Aggregate ----

          WR_result <- do.call("rbind", Results.WR)
          BR_result <- do.call("rbind", Results.BR)

          WR_var_MCmean <- mean(WR_result$var.1obs)
          WR_var_MCvar <- var(WR_result$var.1obs)

          BR_var_MCmean <- mean(BR_result$var.1obs)
          BR_var_MCvar <- var(BR_result$var.1obs)

          # Theoretical value ----

          True_WR_var <- 2*sigma_C^2 + 2/(alpha_R-1)
          True_BR_var <- 2*sigma_C^2 + 4/(alpha_R-1)


          result<-data.frame(nReader = nR, nCase = nC, alpha_R = alpha_R, sigma_C = sigma_C,
                             WR_var_MCmean = WR_var_MCmean,WR_var_MCvar = WR_var_MCvar,
                             True_WR_var = True_WR_var,
                             WR_var_relative_bias = (WR_var_MCmean - True_WR_var)/True_WR_var,
                             WR_CV = sqrt(WR_var_MCvar)/True_WR_var,
                             BR_var_MCmean = BR_var_MCmean,BR_var_MCvar = BR_var_MCvar,
                             True_BR_var = True_BR_var,
                             BR_var_relative_bias = (BR_var_MCmean - True_BR_var)/True_BR_var,
                             BR_CV = sqrt(BR_var_MCvar)/True_BR_var)
          agg_result <- rbind(agg_result, result)
        }
      }
    }
  }

  return(agg_result)

}
