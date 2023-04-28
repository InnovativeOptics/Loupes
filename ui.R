library(tidyverse)
library(bslib)
library(shiny)
library(readxl)

laser_data <- read_excel("Master_0.1.xlsx",
                         sheet = "Laser_types") %>% 
  filter(Class == "Dent")
loupe_data <- read_excel("Master_0.1.xlsx",
                         sheet = "Loupe_types")

loupe_theme <- bs_theme(
  version = 5,
  bg = "white",
  fg = "darkviolet",
  primary = "#02b04a",
  base_font = font_google("Karla"))

page_fluid(
  theme = loupe_theme,
  card_body(
    em("Select Loupe Information"),
    fluidRow(
      column(4, align = 'center',
             selectInput(
               "lmfg", "Manufacturer", choices = sort(loupe_data$Mfg), selected = NULL
             )),
      column(4, align = 'center',
             selectInput("lmod", "Model", choices = NULL)),
      column(4, align = 'center',
             selectInput("size", "Size", choices = NULL))
    ),
  em("Select Laser Information"),
  fluidRow(
    column(4, align = 'center',
           selectInput(
             "mfg", "Manufacturer", choices = sort(laser_data$Mfg)
           )),
    column(4, align = 'center',
           selectInput("mod", "Model", choices = NULL)),
    column(4, align = 'center',br(),
           actionButton("run", "Finished", choices = NULL))
  ),
  tableOutput("table_loupe"),
  tableOutput("table_laser"),
  a("Contact", href = "innovativeoptics.com/contact"))
)