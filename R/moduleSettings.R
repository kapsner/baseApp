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

#' @title moduleSettingsServer
#'
#' @param input Shiny server input object
#' @param output Shiny server output object
#' @param session Shiny session object
#' @param rv The global 'reactiveValues()' object, defined in server.R
#' @param input_re The Shiny server input object, wrapped into a reactive expression: input_re = reactive({input})
#'
#' @export
#'
# moduleSettingsServer
moduleSettingsServer <- function(input, output, session, rv, input_re){

  # populate server-directory browser
  roots = c(home="/home/")
  shinyFiles::shinyDirChoose(input, "settings_sourcedir_in", updateFreq = 0, session = session, defaultPath = "", roots = roots, defaultRoot = "home")


  # observe server directory-search
  observeEvent(input_re()[["moduleSettings-settings_sourcedir_in"]], {
    cat("\nGot source dir\n")
    print(shinyFiles::parseDirPath(roots, input_re()[["moduleSettings-settings_sourcedir_in"]]))
    rv$sourcefiledir <- shinyFiles::parseDirPath(roots, input_re()[["moduleSettings-settings_sourcedir_in"]])
    print(rv$sourcefiledir)
  })

  output$settings_sourcedir_out <- reactive({
    cat("\nSource file dir:", rv$sourcefiledir, "\n")
    paste(rv$sourcefiledir)
  })


  # file input for client files
  observe({
    # wait for inputfile
    req(input_re()[["moduleSettings-settings_inputfile"]])
    ending <- strsplit(input_re()[["moduleSettings-settings_inputfile"]]$name, ".", fixed = T)[[1]]

    # check ending: if csv, go here
    if (ending[2] %in% c("csv", "CSV")){
      file <- reactiveFileReader(1000, session,
                                 input_re()[["moduleSettings-settings_inputfile"]]$datapath,
                                 data.table::fread)
      rv$file <- file()
      # if excel go here
    } else if (ending[2] %in% c("xls", "xlsx")){
      file <- reactiveFileReader(1000, session,
                                 input_re()[["moduleSettings-settings_inputfile"]]$datapath,
                                 openxlsx::read.xlsx)
      rv$file <- file()
    }
  })

  # build column selection
  observe({
    req(rv$file)

    # do some data preprocessing here and save results in rv$data
    rv$data <- rv$file

    # workaround to tell ui, that db_connection is there
    output$fileUploaded <- reactive({
      return(TRUE)
    })
    outputOptions(output, 'fileUploaded', suspendWhenHidden=FALSE)


    output$settings_colnames_out <- renderUI({
      # get colnames
      my_colnames <- colnames(rv$file)

      # create drop-down-menu
      s1 <- selectInput("moduleSettings-select1",
                        label = NULL,
                        choices = my_colnames,
                        selectize = F,
                        multiple = F)

      s2 <- selectInput("moduleSettings-select2",
                        label = NULL,
                        choices = my_colnames,
                        selectize = F,
                        multiple = F)

      s3 <- selectInput("moduleSettings-select3",
                        label = NULL,
                        choices = my_colnames,
                        selectize = F,
                        multiple = F)

      s4 <- selectInput("moduleSettings-select4",
                        label = NULL,
                        choices = my_colnames,
                        selectize = F,
                        multiple = F)

      # alignment of checkboxes with description and dropdown menu
      d1 <- div(class="row",
                div(class="col-sm-3", style="text-align: left", checkboxInput("moduleSettings-c_s1", "ID:", FALSE)),
                div(class="col-sm-6", style="text-align: right", s1))

      d2 <- div(class="row",
                div(class="col-sm-3", style="text-align: left", checkboxInput("moduleSettings-c_s2", "Value:", FALSE)),
                div(class="col-sm-6", style="text-align: right", s2))

      d3 <- div(class="row",
                div(class="col-sm-3", style="text-align: left", checkboxInput("moduleSettings-c_s3", "Age:", FALSE)),
                div(class="col-sm-6", style="text-align: right", s3))

      d4 <- div(class="row",
                div(class="col-sm-3", style="text-align: left", checkboxInput("moduleSettings-c_s4", "Gender:", FALSE)),
                div(class="col-sm-6", style="text-align: right", s4))

      # concatenate everything to list
      select_output_list <- list(d1, d2, d3, d4, tags$hr(),
                                 div(class="row", style="text-align: center",
                                     actionButton("confirm_selection", "Confirm selection")
                                 ))
      # output everything
      do.call(tagList, select_output_list)
    })
  })


  observeEvent(input_re()$confirm_selection, {
    # create table to store column-selections
    rv$choices_list <- data.table::data.table("variable" = character(), "colname" = character())
    # create description of column selections
    selections <- c("ID", "value", "age", "colname")
    # get active checkboxes
    checkbox_list <- c(input$c_s1, input$c_s2, input$c_s3, input$c_s4)
    check_out <- which(checkbox_list==TRUE)

    # require at least two selections: lower and upper limit must be selected
    if (2 %in% check_out){
      lapply(check_out, function(g) {
        selectname <- paste0("select", g)
        rv$choices_list <- rbind(rv$choices_list, cbind("variable" = selections[g], "colname" = eval(parse(text=paste0("input_re()[['moduleSettings-", selectname, "']]")))))
      })
      # if one column is selected multiple times
      if (sum(rv$choices_list[,duplicated(get("colname"))])>0){
        showModal(modalDialog(
          title = "Invalid column selection",
          "Every column may be selected only once."
        ))
      } else {
        print(rv$choices_list)
      }
    } else {
      showModal(modalDialog(
        title = "Invalid column selection",
        "Please select at least one value column."
      ))
    }
  })

  # print radiobutton values
  observeEvent(input_re()[["moduleSettings-settings_targetdb_rad"]], {
    print(input_re()[["moduleSettings-settings_targetdb_rad"]])
  })

  # savesettings
  observeEvent(input_re()[["moduleSettings-settings_targetdb_save_btn"]], {
    print(input_re()[["moduleSettings-settings_targetdb_save_btn"]])
  })

  # testsettings
  observeEvent(input_re()[["moduleSettings-settings_targetdb_test_btn"]], {
    print(input_re()[["moduleSettings-settings_targetdb_test_btn"]])
  })

  # age slider
  observeEvent(input_re()[["moduleSettings-ageSlider"]], {

    if (!is.null(input_re()[["moduleSettings-ageSlider"]])){
      cat("\nValue ageSlider: ", input_re()[["moduleSettings-ageSlider"]], "\n")
      # always check, that slider values are not equal
      if (input_re()[["moduleSettings-ageSlider"]][1] >= input_re()[["moduleSettings-ageSlider"]][2]){
        updateSliderInput(session, "moduleSettings-ageSlider", value = c(input_re()[["moduleSettings-ageSlider"]][1], input_re()[["moduleSettings-ageSlider"]][2]+1))
      }
    }
  })

  # gender selection
  observeEvent(input_re()[["moduleSettings-select4"]], {
    if (!is.null(input_re()[["moduleSettings-select4"]])){
      print(input_re()[["moduleSettings-select4"]])
      output$gender_selection <- renderUI({
        # get colnames
        gender_values <- rv$data[,levels(factor(get(input_re()[["moduleSettings-select4"]])))]

        # create drop-down-menu
        s1 <- selectInput("moduleSettings-g_select_male",
                          label = NULL,
                          choices = gender_values,
                          selectize = F,
                          multiple = F)

        s2 <- selectInput("moduleSettings-g_select_female",
                          label = NULL,
                          choices = gender_values,
                          selectize = F,
                          multiple = F)

        d1 <- div(class="row",
                  div(class="col-sm-6", style="text-align: left", "Male:"),
                  div(class="col-sm-6", style="text-align: right", s1))

        d2 <- div(class="row",
                  div(class="col-sm-6", style="text-align: left", "Female:"),
                  div(class="col-sm-6", style="text-align: right", s2))

        b <- radioButtons(inputId = "moduleSettings-gender",
                          label = "Select gender subset:",
                          choices = list("Female" = "F",
                                         "Male" = "M"),
                          selected = NULL,
                          inline = TRUE)

        # concatenate everything to list
        select_output_list <- list(d1, d2, div(class="row", style="text-align: center", b))
        # output everything
        do.call(tagList, select_output_list)
      })
    }
  })

  # Get age selection, populate slider
  observeEvent(input[["moduleSettings-select3"]],{
    getAge(rv$data, rv, input, session)
  })
}


#' @title moduleSettingsUI
#'
#' @param id A character. The identifier of the shiny object
#'
#' @export
#'
# moduleSettingsUI
moduleSettingsUI <- function(id){
  ns <- NS(id)

  tagList(
    # first row
    fluidRow(
      column(6,
             # Fileupload box
             box(
               title = "Fileupload",
               fileInput(ns("settings_inputfile"), "File upload", multiple = FALSE),
               width = 12
             ),
             # ageslider box
             conditionalPanel(
               condition =  "input['moduleSettings-c_s3']",

               box(
                 title = "Specify age range",
                 uiOutput(ns("age_slider")),
                 width = 12
               )
             ),
             conditionalPanel(
               condition =  "input['moduleSettings-c_s4']",

               box(
                 title = "Specify gender",
                 uiOutput(ns("gender_selection"))
               )
             )
      ),
      column(6,
             conditionalPanel(
               condition =  "output['moduleSettings-fileUploaded']",

               box(
                 title = "Select Columns",
                 uiOutput(ns("settings_colnames_out")),
                 width = 12
               )
             )
      )
    ),

    fluidRow(
      box(title = "Source File Directory",
          div(class = "row",
              div(class="col-sm-4", shinyFiles::shinyDirButton(ns("settings_sourcedir_in"),
                                                   "Source Dir",
                                                   "Please select the source file directory",
                                                   buttonType = "default",
                                                   class = NULL,
                                                   icon = NULL,
                                                   style = NULL)),
              div(class = "col-sm-8", verbatimTextOutput(ns("settings_sourcedir_out")))
          ),
          width = 6
      ),
      box(
        title = "Target Database Configuration",
        radioButtons(inputId = ns("settings_targetdb_rad"),
                     label = "Please select the target database",
                     choices = list("SQL" = "1",
                                    "Postgres" = "2"),
                     selected = NULL,
                     inline = TRUE),
        textInput(ns("settings_targetdb_dbname"), label = "Database name"),
        textInput(ns("settings_targetdb_host"), label = "Host name"),
        textInput(ns("settings_targetdb_port"), label = "Port"),
        textInput(ns("settings_targetdb_user"), label = "Username"),
        passwordInput(ns("settings_targetdb_password"), label = "Password"),
        div(class = "row", style = "text-align: center;",
            actionButton(ns("settings_targetdb_save_btn"), "Save settings"),
            actionButton(ns("settings_targetdb_test_btn"), "Test connection")),
        width = 6
      )
    )
  )
}
