# tiny helper function
matchtimes <- function(t1, t2) {
  # t1, t2 are numeric
  findInterval(t1, c(-Inf, head(t2, -1)) + c(0, diff(t2)/2))
}

# constants
NM_PER_KM <- 0.539957



source("readGPX.r")
source("distance.r")
gps <- readGPX("SW25018R_ABRS-CAS-20250918_20250921.gpx")

tr <- rbind(
  gps$tracks[[1]][[1]],
  gps$tracks[[2]][[1]],
  gps$tracks[[3]][[1]]
)

tr$datetime_POSIX <- as.POSIXct(tr$time, format = "%Y-%m-%dT%H:%M:%OSZ", tz = "UTC")
tr$datenum <- as.numeric(tr$datetime_POSIX)

# convert time for whole trip
targettime <- as.numeric(as.POSIXct("20250831015200", format = "%Y%m%d%H%M%S", tz = "UTC"))
dis <- matchtimes(targettime, tr$datenum)
tr[dis, ]

# subset
trsub <- tr[1:dis, ]

# get distances (in km)
dists <- latlond(
  trsub$lat[1:(nrow(trsub)-1)],
  trsub$lon[1:(nrow(trsub)-1)],
  trsub$lat[2:nrow(trsub)],
  trsub$lon[2:nrow(trsub)]
)

# sum and convert to NM
totaldist_km <- sum(dists)
totaldist_nm <- totaldist_km * NM_PER_KM
totaldist_nm
