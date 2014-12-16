# TODO: Add comment
# 
# Author: ecor
###############################################################################
NULL
#' Extraction of  values of a line 
#' 
#' This function extract the values or the xy coordinate of a line passing through two points.
#' 
#' @param x a Raster*  object
#' @param points data frame containing x and y coordinaates from start and end point
#' @param radius length of the segment from the start point (optional)
#' @param angle  angle direction  of the segment from the start point (optional). It is counterclockwise from East.
#' @param step step used for  the extraction of the segment points
#' @param fun optional aggregation function. Default is \code{NULL}. If it not \code{NULL} the functions return a vector containing an atomic aggregate value for each raster layer.
#' @param ... further arguments for \code{fun} 
#' 
#' 
#' @export 
#' 
#' @examples
#' xy_A <- xyFrom2PointLine(points=data.frame(x=c(0,1),y=c(0,1)),step=0.1)
#' 
#' 
#' dem <- raster(system.file("dem/dem_rendena.asc",package="horizons"))
#' 
#' xP <- (xmax(dem)*0.4+xmin(dem)*0.6)
#' yP <- (ymax(dem)*0.4+ymin(dem)*0.6)
#' 
#' xy_B <- xyFrom2PointLine(r=dem,points,points=data.frame(x=xP,y=yP),radius=10000,angle=35,units_angle="deg")
#' 
#' max_xy_B <- xyFrom2PointLine(r=dem,points,points=data.frame(x=xP,y=yP),radius=10000,angle=35,units_angle="deg",fun=max,na.rm=TRUE)
#' min_xy_B <- xyFrom2PointLine(r=dem,points,points=data.frame(x=xP,y=yP),radius=10000,angle=35,units_angle="deg",fun=min,na.rm=TRUE)
#' 
#' 
#' median_xy_B <- xyFrom2PointLine(r=dem,points,points=data.frame(x=xP,y=yP),radius=10000,angle=35,units_angle="deg",fun=median,na.rm=TRUE)
#' median_xy_BA <-  xyFrom2PointLine(r=brick(dem,dem+1),points,points=data.frame(x=xP,y=yP),radius=10000,angle=35,units_angle="deg",fun=median,na.rm=TRUE)
#' 
#' 
xyFrom2PointLine <- function(r=NULL,points=data.frame(x=c(0,1),y=c(0,1)),step=NULL,radius=NA,angle=NA,units_angle=c("deg","rad"),fun=NULL,...) {
			
			
			units_angle <- 	units_angle[1]
			if (units_angle=="deg") {
				
				angle <- angle/180*pi
				units_angle <- "rad"
				
			}
			
	       if (!is.na(radius) & radius>0) {
				 if (!is.na(angle) & (units_angle=="rad")) {
					
					points[2,] <- NA  
					points$x[2] <- points$x[1]+radius*cos(angle)
					points$y[2] <- points$y[1]+radius*sin(angle) 
					 
				
					 
				 }
				 
				 
			 } else {
				 
				 radius <- ((points$x[2]-points$x[1])^2+(points$y[2]-points$y[1])^2)^0.5
			 }
			 
			 if (is.null(step)) step <- NA
			 if (!is.null(r) & (is.na(step))) step <- xres(r)
			
			
			 xlen <- trunc(radius/step) 
			
			 x_out <- seq(from=points$x[1],to=points$x[2],length.out=xlen)
			 y_out <- seq(from=points$y[1],to=points$y[2],length.out=xlen)
			
				
			 out <- as.data.frame(array(NA,c(length(x_out),2)))
			 names(out) <- c("x","y")
			
			 out$x <- x_out
			 out$y <- y_out
			 
			 if (!is.null(r)) {
				  
				 out$icell <- cellFromXY(r,out[c("x","y")])
				 out <- out[!is.na(out$icell),]
				
				 value <- sprintf("value%03d",1:nlayers(r))
				
				
				
				 for (i in 1:nlayers(r)) {
					  
				  out[,value[i]] <- r[[i]][out$icell]
					  
				 }
				 
				
				 if (!is.null(fun)) {
					 
					 outn <- array(NA,length(value))
					 names(outn) <- value
					
					
					
					
					 for (it in value) {
						
						 outn[it] <- fun(as.vector(out[,it]),...)
						
						 
					 }
					 
					 out <- outn
				 } 
				  
				  
			 }
			 return(out)
	}
