
library(data.table)
root <- here::here()

Available <- file.exists(file.path(root, "mapper/byEvent/epicenters.csv"))
if (Available) {

  EVENTS <- data.table::fread(file.path(root, "mapper/byEvent/epicenters.csv"))
  EVENTS <- EVENTS[Repi <= 1000, .(
    Location = place,
    Mw = mag,
    Date = as.Date(time),
    Lat = latitude,
    Lon = longitude,
    Rhyp = round(sqrt(Repi^2 + depth^2), 0)
  )]
  EVENTS <- EVENTS[!is.na(Date) & nchar(Location) > 0]

  MCE.Mw <- EVENTS[order(-Mw, Date)][1]
  MCE.Rhyp <- EVENTS[Mw >= 4.5][order(Rhyp, Date)][1]

  key.Mw <- paste(MCE.Mw$Date, MCE.Mw$Lat, MCE.Mw$Lon, MCE.Mw$Mw)
  key.Rhyp <- paste(MCE.Rhyp$Date, MCE.Rhyp$Lat, MCE.Rhyp$Lon, MCE.Rhyp$Mw)

}
