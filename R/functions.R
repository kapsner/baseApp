getAge <- function(data, rv, input, session){
  tryCatch({
    if (is.numeric(data[,get(input[["moduleSettings-select3"]])])){
      
      rv$min <- data[,min(get(input[["moduleSettings-select3"]]), na.rm = T)]
      rv$max <- data[,max(get(input[["moduleSettings-select3"]]), na.rm = T)]
      
      updateSliderInput(session, "moduleSettings-ageSlider", value = c(rv$min, rv$max), min = rv$min, max = rv$max)
      
      shinyjs::enable("moduleSettings-ageSlider")
      
    } else {
      shinyjs::disable("moduleSettings-ageSlider")
    }
    
  }, error = function(e){
    print(e)
  })
}