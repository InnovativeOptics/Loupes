library(tidyverse)
library(bslib)
library(shiny)
library(readxl)

laser_data <- read_excel("Master_0.1.xlsx",
                         sheet = "Laser_types") %>% 
  filter(Class == "Dent")
loupe_data <- read_excel("Master_0.1.xlsx",
                         sheet = "Loupe_types")


# Define server logic required to draw a histogram
function(input, output, session) {

    observeEvent(input$lmfg,{
      mfg_filt <- loupe_data %>% 
        filter(Mfg == input$lmfg) 
      updateSelectInput(inputId = "lmod",
                        choices = sort(mfg_filt$Mod))
      updateSelectInput(inputId = "size",
                        choices = mfg_filt$Size)
    })
  observeEvent(input$lmod,{
    mod_filt <- loupe_data %>% 
      filter(Mod == input$lmod)
    updateSelectInput(inputId = "size",
                      choices = mod_filt$Size)
    
  })
  observeEvent(input$mfg,{
    laser_filt <- laser_data %>% 
      filter(Mfg == input$mfg)
    updateSelectInput(inputId = "mod",
                      choices = laser_filt$Mod)
  })
  filt_data_loupe <- eventReactive(input$run,{
    req(input$lmfg)
    req(input$lmod)
    req(input$size)
    loupe_data %>% 
      filter(Mfg == input$lmfg &
             Mod == input$lmod &
             Size == input$size)%>% 
      mutate("Compatible Insert" = `Insert Part Number`) %>% 
      select(1:3,5)
  })
  filt_data_laser <- eventReactive(input$run,{
    req(input$mfg)
    req(input$mod)
    laser_data %>% 
      filter(Mfg == input$mfg &
               `Mod` == input$mod) %>% 
      mutate("Compatible Filter" = `Compatible Lens 1`) %>%
      select(1:2,4, `Compatible Filter`)
  })
  output$size_selector <- renderText({
    req(input$mfg)
    req(input$mod)
    c('<a href="',
      lens_location1()$Website[[1]],
      '"> Browse ',lens_location1()$Lens[[1]],' eyewear</a>')
  })
  output$table_loupe <- renderTable({filt_data_loupe()})
  
  output$table_laser <- renderTable({filt_data_laser()})
}
