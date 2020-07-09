library(shiny)
library(leaflet)
library(dplyr)
library(readr)
library(tidyr)
recycling_bins <- read_csv("data/Public_Recycling_Bins.csv")
recycling_bins <- recycling_bins %>%
    select(borough = Borough,
           site_type = `Site type`,
           site_name = `Park/Site Name`,
           address = Address,
           lat = Latitude,
           long = Longitude) 

r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

ui <- fluidPage(
    leafletOutput("mymap", width = 700, height = 700),
)

server <- function(input, output, session) {
    
   # points <- cbind(recycling_bins$Longitude,recycling_bins$Latitude) # get markers of bins via lat and long here
    
    output$mymap <- renderLeaflet({
        
        binIcon <- makeIcon(
            iconUrl = "http://cliparts.co/cliparts/pTo/5Gk/pTo5GkkTE.png",
            iconWidth = 20, iconHeight = 25
           
        )
        leaflet(recycling_bins) %>%
            addProviderTiles(providers$Stamen.TonerLite,
                             options = providerTileOptions(noWrap = TRUE)
            ) %>%
            addMarkers(~long, ~lat,  popup = ~address, icon = binIcon) #popup = c(~site_name, ~address))
    })
}

shinyApp(ui, server)