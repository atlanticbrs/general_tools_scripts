# load required libraries
library(XML)

# required helper functions (readGPX was originally in plotKML but removed at
# some point and maybe is back now but I don't trust it)
source("readGPX.r")

fnames <- c(
  "../20210925_Shearwater_CEE_d.gpx",
  "../20240719_202407222_Shearwater_BRS_CEE.gpx",
  "../20260718 barber brs gpx tracker.gpx",
  "../SW25018R_ABRS-CAS_20250919_21.gpx",
  "../SWXXXR_ABRS-CAS_20260716_18.gpx"
)

for(i in 1:length(fnames)) {
  # load gpx
  gps <- readGPX(fnames[i])
  
  # unnest and bind
  tr <- do.call('rbind', lapply(gps$tracks, function(x) x[[1]]))
  
  # get posix time and seconds since the unix epoch 1970-01-01
  tr$datetime_POSIX <- as.POSIXct(tr$time, format = "%Y-%m-%dT%H:%M:%OSZ", tz = "UTC")
  tr$datenum <- as.numeric(tr$datetime_POSIX)
  
  # sort multiple tracks back together
  tr <- tr[order(tr$datenum), ]
  
  # write out (changing file name to have csv suffix -- make sure you don't
  # have other gpx in the file name that will make this go weird)
  outfname <- fnames[i]
  outfname <- gsub("gpx", "csv", outfname)
  write.table(tr, file = outfname, sep = ',', row.names = FALSE)
}
