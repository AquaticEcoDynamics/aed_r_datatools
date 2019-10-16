# Download a set of SILO data based on lat lon centroids
#________________________________________________________#
# Make your subcatchments in GIS: 
  # make them editable 
  # calculate the area, delete small catchments and line fragments
  # calculate x centre (longitude) and y centre (latitude)
  # save your edits. Close it.
# Locate the attribute table and load it into R
attributetable<-read.dbf("C: ... /EllenBrook/EllenSubs8.dbf")
# Load the latitude and longitude into R
lats<-format(round(attributetable$Y_CENTRE,3),nsmall=2) # SILO can't handle too many decimal places
lons<-format(round(attributetable$X_CENTRE,3),nsmall=2)
# Set a location for the output files
#
outputfolder<- "C: ... /RawClimate/SILO/Rain/"
# Make a loop the length of the number of subcatchments you have
for(i in 1:length(lats)){
# This is the format that SILO requires. You can just paste it into a browser address bar 
  # and it will print the data to the browser.
  # Do this to check if you are having any problems. SILO might give you helpful error messages
link="https://www.longpaddock.qld.gov.au/cgi-bin/silo/DataDrillDataset.php?" # Standard address
start="start=19600101&" # Start date YYYYMMDD
finish="finish=20190101&" # End date YYYYMMDD
lat= paste0("lat=",lats[i],"&") 
lon= paste0("lon=",lons[i],"&")
format="format=csv&" # Change this format if you want to print it to the browser
comment="comment=ER&" # E is evaporation, R is rainfall. You can add others
username="username=dan.paraska@uwa.edu.au&" # This can be anything, but they like having an email address
password="password=silo" # This can be anything. This is the end of the link

#Use R to paste all the elements together
the.link<-paste0(link,start,finish,lat,lon,format,comment,username,password) 
# 'url' is the R function for reading a url. It is the equivalent of Matlab 'websave'
# The r fucntion 'read.csv' turns the website content into a csv. 
# The variable 'data' will be overwritten at each iteration of the loop
data<-read.csv(url(the.link)) 
# Write the raw data you just downloaded to a csv. 
write.csv(data,file = paste0( outputfolder# Set the output directory
                            ,attributetable$CATCH_NAME[i] # In this case, I need to combine two attribute table elements
                            ,attributetable$OBJECTID[i] # because there are repeated numbers of object ids.
                            ,".csv") ) # Save it as a csv.
}

# Write the Source input file
#_______________________________________________________________________________#
# For eWater Source, reformat the data so that it can be loaded in as Source climate data.
# Firstly, grab any csv to get the dates column
firstcsv<-read.csv(file = paste0(outputfolder # Set the output directory
                               ,attributetable$CATCH_NAME[1] # In this case, I need to combine two attribute table elements
                               ,attributetable$OBJECTID[1] # because there are repeated numbers of object ids.
                               ,".csv") ) # Save it as a csv.
dates.col<-firstcsv$YYYY.MM.DD # Get the dates
# Create the dataframe to write to
raindf<-data.frame(dates.col) ; evapdf<-data.frame(dates.col)
colnames(raindf) <- "Date";colnames(evapdf) <- "Date" # Call the column "Dates"
# Start a loop 
for (i in 1:length(lats)){
# Read the raw file 
  raw<-read.csv(file = paste0(outputfolder
         ,attributetable$CATCH_NAME[i]
         ,attributetable$OBJECTID[i]
         ,".csv"))
# Get the rain and evap columns; these variables get overwritten at every iteration of the loop
 rain<-raw$daily_rain; evap<-raw$evap_pan 
 # Overwrite the old dataframe with a new version of the same dataframe. It gets bigger every time
 raindf<-data.frame(raindf,rain); evapdf<-data.frame(evapdf,evap) 
 # Set the names of the columns to be what you want to read into Source
 colnames(raindf)[i+1]<-paste0(attributetable$CATCH_NAME[i],attributetable$OBJECTID[i]) # i+1 because 
 colnames(evapdf)[i+1]<-paste0(attributetable$CATCH_NAME[i],attributetable$OBJECTID[i]) # column 1 is Date
}
# Write the dataframe to a csv
 write.csv(raindf,file = paste0(outputfolder,"EllenRain.csv"),row.names = F)
 write.csv(evapdf,file = paste0(outputfolder,"EllenEvap.csv"),row.names = F)   
#__________________________________________________________________________#