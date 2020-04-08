# baseApp - A package containing a basic shiny app. A good starting point for
# shiny app development.
# Copyright (C) 2019 Lorenz Kapsner
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

shiny::shinyUI(
  shiny::tagList(
    shinydashboard::dashboardPage(
      skin = "black",

      # Application title
      shinydashboard::dashboardHeader(title = "A shiny baseApp"),

      shinydashboard::dashboardSidebar(

        # Include shinyjs in the UI Sidebar
        shinyjs::useShinyjs(),

        #Sidebar Panel
        shinydashboard::sidebarMenu(
          id = "tabs",
          shinydashboard::menuItem(
            "Settings",
            tabName = "settings",
            icon = icon("file")
          ),
          shiny::tags$hr(),
          shiny::actionButton("reset", "Reset")
        ),
        shiny::div(
          class = "sidebar-menu",
          style = paste0("position:fixed; bottom:0; ",
                         "left:0; white-space: normal;",
                         "text-align:left;",
                         "padding: 9.5px 9.5px 9.5px 9.5px;",
                         "margin: 6px 10px 6px 10px;",
                         "box-sizing:border-box;",
                         "heigth: auto; width: 230px;"),
          shiny::HTML(
            paste0(
              "Version: ", utils::packageVersion("baseApp"),
              "<br/><br/>\u00A9 Given Family<br/>"
            )
          ))
      ),

      shinydashboard::dashboardBody(

        # Include shinyjs in the UI Body
        shinyjs::useShinyjs(),

        # js reset function
        # https://stackoverflow.com/questions/25062422/restart-shiny-session
        # Add the js code to the page
        shinyjs::extendShinyjs(script = "reset.js",
                               functions = "reset"),

        shinydashboard::tabItems(
          shinydashboard::tabItem(tabName = "settings",
                                  module_settings_ui("moduleSettings")
          )
        )
      )
    )))
