
#' createMasterA
#'
#' This function allows you to compile data from batches containing acoustic receiver text files.
#' @param drive The single-letter name of the drive where the database is located. Usually "G" or "E" depending on which computer you are working from.
#' @param batch The name or names of the batch folders where the receiver text files are stored.
#' @param tagIDs A single M.Code.ID or a vector of M.Code.IDs with the TagIDs you wish to examine. Best to set this as the M.Code.ID column from your fish data workbook dataframe.
#' @keywords telemetry
#' @export
#' @examples
#' createMasterA(drive="G",batch=c("UC ARRAY","LC ARRAY"),tagIDs=fish$M.Code.ID)

createMasterA  <-  function(drive,batch,tagIDs){ 
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
  # # create list of csvs that are in the path
  
  suppressWarnings(for(i in 1:length(path1)){
    filenames   <- list.files(path1[i])
    read_fwf_filename <- function(filename){
      ret <- suppressMessages(read_fwf(paste(path1[i],filename,sep="/"), fwf_widths(c(9,11,11,13,9,10,8))))
      ret$Receiver <- unlist(strsplit(filename, split = " ", fixed = T))[1] #EDIT
      ret
    }
    temp_mast <- ldply(filenames, read_fwf_filename)
    if (i == 1) mast = temp_mast else mast = rbind(mast,temp_mast)
    
  })
  colnames(mast) <- c("Date","Time","TOA","TagID","Type","Value","Power","Receiver")
  mast <- mast[!(mast$TagID %in% tagIDs ==F),]
  mast$timestamp = mdy_hms(paste(mast$Date,mast$Time))
  return(mast[mast$timestamp > ymd_hms("2017-01-01 00:00:00"),])
}

