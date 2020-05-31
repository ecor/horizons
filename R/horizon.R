NULL
#' Horizon Angle Computation
#' 
#' This function calculates the horizon angle of given points using  an elevation raster map
#' 
#' @param r Raster* object contianing the Digital Elevation Map
#' @param points data frame containing x and y coordinaates
#' @param adjust.zero logical value. It it is \code{TRUE}, negative horizon angle are not considered.
#' @param n number of directions used. Default is 8. 
#' @param radius see \code{\link{xyFrom2PointLine}}
#' @param names names of the points
#' 
#' @return  It returns a list of data frames. A list element represents a examined point and contains \code{n} horizon angles for all \code{n} direction. 
#' The vertical horizon angle are conterclockwise referred to the horizontal axis and are expressed in degree units. 
#'
#' @export
#' 
#' @seealso \code{\link{xyFrom2PointLine}}
#' 
#' @examples 
#' 
#' library(horizons)
#' library(raster)
#' 
#' # First Example: Spare Hull
#' side <- 5010
#' n <- 501
#' 
#' values <- array(NA,c(n,n))
#' coord <- (1:n)/n*side-side/2
#' values <- outer(X=coord,Y=coord,FUN=function(x,y) {(x^2+y^2)^0.5})
#' 
#' r <- raster(values, crs=NA,xmn=-side/2,xmx=side/2,ymn=-side/2,ymx=side/2)
#' 
#' 
#' xpp <- c(-side/3,0,0,0,side/3)
#' ypp <- c(0,-side/3,0,side/3,0)
#' idp <- c("A","B","O","C","D")
#' points <- data.frame(x=xpp,y=ypp,id=idp)
#' 
#' hor <- horizon(r,points=points)
#' names(hor) 
#' points$id
#' 
#' 
#' 
#' 
#' 
#' # Second Example 
#' 
#' dem <- raster(system.file("dem/dem_rendena.asc",package="horizons"))
#' 
#' horizons <- horizon(dem)
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 


horizon <- function(r,points=data.frame(x=c(0,(xmin(r)+xmax(r))/2),y=c(0,(ymin(r)+ymax(r))/2)),adjust.zero=TRUE,n=8,radius=50000,names=NULL) {
	
	
	
	points$icell <- cellFromXY(r,as.matrix(points[,c("x","y")]))
    
	
	angles <- 360/n*((1:n)-1)
	
	
	if (!is.null(names)) names <- names[!is.na(points$icell)]
	points <- points[!is.na(points$icell),]
	out <- list() 

	for (i in 1:nrow(points)) {
		
	    ip <- points$icell[i]
		r0 <- r*NA 
		r0[ip] <- 0
		
		dist <- distance(r0)
		horizon <- r0
		horizon <- (r-r[ip])/dist
		
		if (adjust.zero==TRUE) horizon[(horizon<0)] <- 0
		horizon[ip] <- NA
		
		### median_xy_B <- xyFrom2PointLine(r=dem,points,points=data.frame(x=xP,y=yP),radius=10000,angle=35,units_angle="deg",fun=median,na.rm=TRUE)
		horizons <- data.frame(AngleFromNorthClockwise=angles,HorizonHeight=-9999)
	
		for (rh in 1:nrow(horizons)) {
			
			
			angle <- 90-horizons$AngleFromNorthClockwise[rh]
			val <- xyFrom2PointLine(r=horizon,points=points[i,],radius=radius,angle=angle,units_angle="deg",fun=max,na.rm=TRUE)
			if (adjust.zero==TRUE & val<0) val <- 0
			horizons$HorizonHeight[rh]  <- atan(val)/pi*180
			
		}
		
		out[[i]] <- horizons
		
	}
	
	names(out) <- names
	
	return(out)
	
	
}