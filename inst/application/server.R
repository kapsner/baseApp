# baseApp - A package containing a basic shiny app. A good starting point for shiny app development.
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

shiny::shinyServer(function(input, output, session) {

    # define reactive values here
    rv <- shiny::reactiveValues(
        file = NULL,
        data = NULL,
        choices_list = NULL,
        sourcefiledir = NULL
    )

    # handle reset
    shiny::observeEvent(input$reset, {
        shinyjs::js$reset()
    })

    ######################
    ## Settings Tab
    ######################
    shiny::callModule(moduleSettingsServer, "moduleSettings", rv=rv, input_re=reactive({input}))

    # it is safer to keep shinyjs::stuff (e.g. disable) in the server file
    # observe if checkbox is activated
    # IDs
    shiny::observeEvent(input[["moduleSettings-c_s1"]], {
        if(isFALSE(input[["moduleSettings-c_s1"]])){
            shinyjs::disable("moduleSettings-select1")
        } else {
            shinyjs::enable("moduleSettings-select1")
        }
    })
    # Value
    shiny::observeEvent(input[["moduleSettings-c_s2"]], {
        if(isFALSE(input[["moduleSettings-c_s2"]])){
            shinyjs::disable("moduleSettings-select2")
        } else {
            shinyjs::enable("moduleSettings-select2")
        }
    })
    # Age
    shiny::observeEvent(input[["moduleSettings-c_s3"]], {
        if(isFALSE(input[["moduleSettings-c_s3"]])){
            shinyjs::disable("moduleSettings-select3")
        } else {
            shinyjs::enable("moduleSettings-select3")
            output[["moduleSettings-age_slider"]] <- shiny::renderUI({
                shinyjs::disabled(shiny::sliderInput("moduleSettings-ageSlider", label = h3("Age"), min = 0, max = 1, value = c(0, 1), dragRange = FALSE))
            })
        }
    })
    # Gender
    shiny::observeEvent(input[["moduleSettings-c_s4"]], {
        if(isFALSE(input[["moduleSettings-c_s4"]])){
            shinyjs::disable("moduleSettings-select4")
        } else {
            shinyjs::enable("moduleSettings-select4")
        }
    })
})
