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

get_age <- function(data,
                    rv,
                    input,
                    session) {

  tryCatch({
    if (is.numeric(data[, get(input[["moduleSettings-select3"]])])) {
      rv$min <-
        data[, min(get(input[["moduleSettings-select3"]]), na.rm = T)]
      rv$max <-
        data[, max(get(input[["moduleSettings-select3"]]), na.rm = T)]

      updateSliderInput(
        session,
        "moduleSettings-ageSlider",
        value = c(rv$min, rv$max),
        min = rv$min,
        max = rv$max
      )

      shinyjs::enable("moduleSettings-ageSlider")

    } else {
      shinyjs::disable("moduleSettings-ageSlider")
    }

  }, error = function(e) {
    print(e)
  })
}
