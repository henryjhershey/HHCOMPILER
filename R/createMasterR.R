#' createMasterR
#'
#' This function allows you to compile data from batches containing radio receiver text files.
#' @param drive The single-letter name of the drive where the database is located. Usually "G" or "E" depending on which computer you are working from.
#' @param batch The name or names of the batch folders where the receiver text files are stored.
#' @param EMG Defaults to FALSE, if TRUE, the data will be formatted for EMG files, not CART files.
#' @param tagIDs Unless you specified EMG = TRUE, a single C.Code.ID or a vector of C.Code.IDs with the TagIDs you wish to examine. Best to set this as the C.Code.ID column from your fish data workbook dataframe. If you set EMG=T, then use the EMG.ID column, not the C.Code.ID.
#' @keywords telemetry
#' @export
#' @examples
#' createMasterR(drive="G",batch="CLRADIO",EMG=F,tagIDs=fish$C.Code.ID)





createMasterR  <-  function(drive,batch,EMG=FALSE,tagIDs){ 
  if (!requireNamespace("plyr", quietly = TRUE)) {
    stop("Package \"plyr\" needed for this function to work. Please install it.",
      call. = FALSE)
  } 
    if (!requireNamespace("lubridate", quietly = TRUE)) {
       stop("Package \"lubridate\" needed for this function to work. Please install it.",
      call. = FALSE)
      } 
    if (!requireNamespace("readr", quietly = TRUE)) {
       stop("Package \"readr\" needed for this function to work. Please install it.",
      call. = FALSE)
      }
  path1 = paste(drive,":/USACEFISHPASS/DATA/TELEMETRY/BATCHES/",batch,"/TEXTFILES",sep="")
  print(path1)
  
  suppressWarnings(for(i in 1:length(path1)){
    filenames   <- list.files(path1[i])
    read_fwf_filenameEMG <- function(filename){
      if(EMG==T){ret = suppressMessages(read_fwf(paste(path1[i],filename,sep="/"), 
                                                 fwf_widths(c(10,10,10,10,11,8,7,10),col_names=c("Date","Time","Channel","EMGID","Antenna","Power","Data","SensorType"))
      ))} else { ret = suppressMessages(read_fwf(paste(path1[i],filename,sep="/"),
                                                 fwf_widths(c(8,11,10,10,13,7),col_names=c("Date","Time","Channel","TagID","Antenna","Power"))))
      }
      as.data.frame(ret)
    } 
    temp_mast <- ldply(filenames, read_fwf_filenameEMG)
    if (i == 1) mast = temp_mast else mast = rbind(mast,temp_mast)
    
  })
  # create list of csvs that are in the working directory
  
  if(EMG==T) mast=na.omit(mast[mast$SensorType == "CEMG2",]) else mast=mast[!(mast$TagID %in% tagIDs==F),]
  mast$timestamp <- mdy_hms(paste(mast$Date, mast$Time, sep=" "))
  if(EMG==T) mast= mast[order(mast$EMGID,mast$timestamp),] else mast = mast[order(mast$TagID,mast$timestamp),]
  
  return(mast)
}
