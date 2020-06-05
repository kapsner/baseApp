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

#' @title Launch the shiny baseApp
#'
#' @param port The port, baseApp is running on (default: 3838)
#' @param dir A character string. The (absolute) path of ...
#'
#' @return baseApp application
#'
#' @import shiny shinydashboard
#' @importFrom magrittr "%>%"
#' @importFrom data.table .N ":="
#'
#' @examples
#' \dontrun{
#' launch_app()
#' }
#' @export
#'
#'
launch_app <- function(
  port = 3838,
  dir = tempdir()
) {

  global_env_hack <- function(key,
                              val,
                              pos) {
    assign(
      key,
      val,
      envir = as.environment(pos)
    )
  }

  global_env_hack("dir",
                  dir,
                  1L)


  options(shiny.port = port)
  shiny::shinyAppDir(
    appDir = system.file("application", package = "baseApp")
  )
}
