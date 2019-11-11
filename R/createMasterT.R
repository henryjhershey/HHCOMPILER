
#' createMasterT
#'
#' This function allows you to compile data from batches containing triangulated position text files.
#' @param drive The single-letter name of the drive where the database is located. Usually "G" or "E" depending on which computer you are working from.
#' @param batch The name or names of the batch folders where the position text files are stored. Must be an "array" batch.
#' @keywords telemetry
#' @export
#' @examples
#' createMasterT(drive="G",batch=c("UC ARRAY","LC ARRAY))


createMasterT  <-  function(drive,batch){ 
  library(readr,quietly=T)
  library(plyr,quietly=T)
  library(lubridate,quietly=T)
  path1 = paste(drive,":/USACEFISHPASS/DATA/TELEMETRY/BATCHES/",batch,"/POSITIONS",sep="")
  print(path1)
  
  for(i in 1:length(path1)){
    filenames   <- list.files(path1[i])
    read_csv_filename <- function(filename){
      ret       <- read.csv(paste(path1[i],filename,sep="/"),stringsAsFactors = F)
      ret$tagID <- unlist(strsplit(filename, split = "_", fixed = T))[1] #EDIT
      ret
    }
    #apply read.csv to all filenames in working directory then row bind csvs together
    temp_mast <- ldply(filenames, read_csv_filename)
    if (i == 1) mast = temp_mast else mast = rbind(mast,temp_mast)
  }
  colnames(mast)[3:4] <- c("x","y")
  return(mast)
  
}
