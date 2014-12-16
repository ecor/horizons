#require(raster)
#require(rgdal)
rm(list=ls())
library(geotopbricks)

wpath <- "/home/ecor/attivita/2014/simulazioni_new/rendena100m_20140930"

dem <- get.geotop.inpts.keyword.value("DemFile",raster=TRUE,wpath=wpath)

demdir <- '/home/ecor/Dropbox/R-activity-2/horizon_angle/inst/dem'
demasc <- paste(demdir,"dem_rendena.asc",sep="/")
demprj <- paste(demdir,"dem_rendena.prj",sep="/")





#
#
#


writeRaster(x=dem,filename=demasc, overwrite=TRUE)
showWKT(proj4string(dem), file=demprj) 

####r <- raster(list(x = 1:nrow(volcano), y = 1:ncol(volcano), z =
#						volcano), crs = "+proj=laea +lat_0=-50 +datum=WGS84")
#writeRaster(r, "file.asc")
#showWKT(proj4string(r), file="file.prj") 
# which also shows the WKT version on the console
