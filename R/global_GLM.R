library(GLMr)
library(raster)
library(ncdf4)
library(glmtools)
library(NicheMapR)

source('make_met_hourly.R')

#install.packages(c("GLMr", "glmtools", "rLakeAnalyzer"), repos = c("http://owi.usgs.gov/R", getOption("repos")), destdir = 'C:/Users/mrke/R')

nyears <- 2
ystart <- 1997
yfinish <- 1998
loc <- 'Madison, Wisconsin'
micro <- micro_global(loc = loc, nyears = nyears, timeinterval = 365, snowmodel = 1)

simfolder <- 'examples_2.2/warmlake/aed2'
met_hourly_NMR <- make_met_hourly(micro = micro, simfolder = simfolder, ystart = ystart, yfinish = yfinish, nyears = nyears)


run_glm(sim_folder = "examples_2.2/warmlake/aed2/", verbose = TRUE, args = character())
data <- get_var(file = "examples_2.2/warmlake/aed2/output.nc", var_name = 'temp', reference = 'bottom', z_out = NULL, t_out = NULL)

for(i in 1:20){
  if(i==1){
  plot(data[,i+1]~data$DateTime, type = 'l', col = i, ylim = c(min(temp[,2:21], na.rm = TRUE), max(temp[,2:21], na.rm = TRUE)))
  }else{
  points(data[,i+1]~data$DateTime, type = 'l', col = i)
}}
