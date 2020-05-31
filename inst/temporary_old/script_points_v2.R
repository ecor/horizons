

rm(list=ls())

library(geotopbricks)
library(horizons)

wpath <- "/home/ecor/attivita/2014/simulazioni_new/rendena100m_20141028_history" ####		"/media/ecor/GONGOLO/simulazione_distribuita_history/rendena100m_20141028_history" ###"/home/ecor/attivita/2014/simulazioni_new/rendena100m_20141028_history"    ##/home/ecor/attivita/2014/simulazioni_new/rendena100m_20140930"
wpath_dtm <-  "/home/ecor/GEODATI/DTM/" ###"/media/ecor/MAFTINA/EMANUELE/DTM"

#demfile <- paste(wpath_dtm,"dtm10mUTM32.img",sep="/")
#demfile100 <- paste(wpath_dtm,"dtm100mUTM32.img",sep="/")
dem <- raster(system.file("dem/dem_rendena.tif",package="horizons"))

dem <- stack(demfile)[[1]]
dem100 <- aggregate(dem,fact=10,filename=demfile100,overwrite=TRUE)
dem <-  dem100 #dem100 #get.geotop.inpts.keyword.value("DemFile",raster=TRUE,wpath=wpath) 
###

pointfile <- get.geotop.inpts.keyword.value("PointFile",wpath=wpath,add_wpath=TRUE)
pointfile_new <- paste(pointfile,"_v2.txt",sep="_")
pointfile <- paste(pointfile,"txt",sep=".")

checkpoints_all <- read.table(pointfile,sep=",",header=TRUE)
checkpoints_all$hor <- checkpoints_all$ID

checkpoints <- checkpoints_all[,c("X","Y")]

names(checkpoints) <- c("x","y")
checkpoints_code <- checkpoints_all$ID

horizonfiles <- get.geotop.inpts.keyword.value("HorizonPointFile",wpath=wpath,add_wpath=TRUE) 
horizonfiles <- paste(horizonfiles,"%04d.txt",sep="")

horizonfiles <- sprintf(horizonfiles,checkpoints_code)



write.table(checkpoints_all,file=pointfile_new,row.names=FALSE,sep=",",quote=FALSE)
#stop()
#nmeteo <- get.geotop.inpts.keyword.value("NumberOfMeteoStations",numeric=TRUE,wpath=wpath)



### TO DO 



#checkpoints <- as.data.frame(array(NA,c(nmeteo,2)))
#names(checkpoints) <- c("x","y")
#
#checkpoints$x <- get.geotop.inpts.keyword.value("MeteoStationCoordinateX",numeric=TRUE,wpath=wpath)
#checkpoints$y <- get.geotop.inpts.keyword.value("MeteoStationCoordinateY",numeric=TRUE,wpath=wpath)
#checkpoints_code <- get.geotop.inpts.keyword.value("MeteoStationCode",vector_sep=",",wpath=wpath)
#####
names(horizonfiles) <- checkpoints_code
levelc <- 1:length(checkpoints_code)

horizons <- horizon(r=dem,points=checkpoints[levelc,],n=8,names=checkpoints_code[levelc])

#####
LINE <- 4

for (i in names(horizons)[levelc]) {
	
	sr <- readLines(horizonfiles[1])
	
	lines <- paste(horizons[[i]][,1],horizons[[i]][,2],sep=",")
	sr_new <- c(sr[1:LINE],lines)
	writeLines(text=sr_new,con=horizonfiles[i])
	
	
}
#


#
#



