
(WD <- getwd())
if (!is.null(WD)) setwd(WD)

require(shiny)
folder_address = WD
runApp(folder_address, launch.browser=TRUE)
