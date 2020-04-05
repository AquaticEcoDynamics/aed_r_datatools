make_met_hourly <- function(micro = micro, simfolder = simfolder, 
  ystart = ystart, yfinish = yfinish, nyears = nyears){
  
  metout <- as.data.frame(micro$metout)
  rainfall <- micro$RAINFALL
  
  nyears <- yfinish - ystart + 1
  tzone=paste("Etc/GMT-",10,sep="") # doing it this way ignores daylight savings!
  dates=seq(ISOdate(ystart,1,1,tz=tzone)-3600*12, ISOdate((ystart+nyears),1,1,tz=tzone)-3600*13, by="hours")
  dates<-dates[1:nrow(metout)]
  
  rainfall2 <- as.data.frame(dates)
  rainfall2$rain <- 0
  rainfall2[seq(1,length(dates), 24),2] <- rainfall
  rainfall2<-rainfall2[1:nrow(metout),2] / 24 / 1000
  metout$rainfall <- rainfall2
  metout$longwave <- 5.67e-8 * ((metout$TSKYC+273.15)^4)
  metout$VREF <- metout$VREF# * 5
  metout <- cbind(dates, metout)
  met_hourly_NMR <- metout[,c(1,14,21,5,7,9,20,19)]
  colnames(met_hourly_NMR) <- c("time","ShortWave","LongWave","AirTemp","RelHum","WindSpeed","Rain","Snow")
  write.csv(met_hourly_NMR, file = paste0(simfolder, "/met_hourly.csv"), row.names = FALSE, quote = FALSE)
  return(met_hourly_NMR)
}