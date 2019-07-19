shiny::shinyUI(shinydashboard::dashboardPage(skin = "black",

                                             # Application title
                                             shinydashboard::dashboardHeader(title = "A shiny baseApp"),

                                             shinydashboard::dashboardSidebar(

                                                 # Include shinyjs in the UI Sidebar
                                                 shinyjs::useShinyjs(),

                                                 #Sidebar Panel
                                                 shinydashboard::sidebarMenu(id = "tabs",
                                                                             shinydashboard::menuItem("Settings", tabName = "settings", icon = icon("file")),
                                                                             shiny::tags$hr(),
                                                                             shiny::actionButton("reset", "Reset")
                                                 )),

                                             shinydashboard::dashboardBody(

                                                 # Include shinyjs in the UI Body
                                                 shinyjs::useShinyjs(),

                                                 # js reset function
                                                 # https://stackoverflow.com/questions/25062422/restart-shiny-session
                                                 shinyjs::extendShinyjs(script = "reset.js", functions = "reset"), # Add the js code to the page

                                                 shinydashboard::tabItems(
                                                     shinydashboard::tabItem(tabName = "settings",
                                                                             moduleSettingsUI("moduleSettings")
                                                     )
                                                 )
                                             )
))
