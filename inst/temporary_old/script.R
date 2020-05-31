

rm(list=ls())

library(geotopbricks)
library(horizons)

wpath <- "/home/ecor/attivita/2014/simulazioni_new/rendena100m_20141028_history/" ####		"/media/ecor/GONGOLO/simulazione_distribuita_history/rendena100m_20141028_history" ###"/home/ecor/attivita/2014/simulazioni_new/rendena100m_20141028_history"    ##/home/ecor/attivita/2014/simulazioni_new/rendena100m_20140930"
wpath <- "/home/ecor/local2/geotop/tests/3D/rendena"
wpath_dtm <-  "/home/ecor/GEODATI/DTM/" ###"/media/ecor/MAFTINA/EMANUELE/DTM"

demfile <- paste(wpath_dtm,"dtm10mUTM32.img",sep="/")
demfile100 <- paste(wpath_dtm,"dtm100mUTM32.img",sep="/")
###/home/ecor/local2/geotop/tests/3D/rendena

dem <- stack(demfile)[[1]]
dem100 <- aggregate(dem,fact=10,filename=demfile100,overwrite=TRUE)
dem <-  dem100 #dem100 #get.geotop.inpts.keyword.value("DemFile",raster=TRUE,wpath=wpath) 

nmeteo <- get.geotop.inpts.keyword.value("NumberOfMeteoStations",numeric=TRUE,wpath=wpath)

horizonfiles <- get.geotop.inpts.keyword.value("HorizonMeteoStationFile",wpath=wpath,add_wpath=TRUE) 
horizonfiles <- paste(horizonfiles,"%04d.txt",sep="")

horizonfiles <- sprintf(horizonfiles,1:nmeteo)

###

meteopoints <- as.data.frame(array(NA,c(nmeteo,2)))
names(meteopoints) <- c("x","y")

meteopoints$x <- get.geotop.inpts.keyword.value("MeteoStationCoordinateX",numeric=TRUE,wpath=wpath)
meteopoints$y <- get.geotop.inpts.keyword.value("MeteoStationCoordinateY",numeric=TRUE,wpath=wpath)
meteopoints_code <- get.geotop.inpts.keyword.value("MeteoStationCode",vector_sep=",",wpath=wpath)

names(horizonfiles) <- meteopoints_code

horizons <- horizon(r=dem,points=meteopoints,n=8,names=meteopoints_code)


LINE <- 4

for (i in names(horizons)) {
	
	sr <- readLines(horizonfiles[i])
	
	lines <- paste(horizons[[i]][,1],horizons[[i]][,2],sep=",")
	sr_new <- c(sr[1:LINE],lines)
	writeLines(text=sr_new,con=horizonfiles[i])
	
	
}
#


#
#



