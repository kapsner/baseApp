FROM rocker/shiny-verse:3.6.1

# install necessary system dependencies for r packages (e.g. devtools, RPostgres)
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    pandoc \
    pandoc-citeproc \
    git

# install tinytex
RUN echo "options('repos' = 'https://ftp.fau.de/cran/')" >> /usr/local/lib/R/etc/Rprofile.site

ENV RSESSION_USER=shiny

# switch user
USER ${RSESSION_USER}
# install required LaTeX-Packages
RUN R -q -e "tinytex::install_tinytex()"
USER root

ENV PATH="/home/${RSESSION_USER}/bin:/home/${RSESSION_USER}/.TinyTeX/bin/x86_64-linux:${PATH}"

ARG tiny="'amsfonts', \
    'amsmath', \
    'atveryend', \
    'babel', \
    'babel-german', \
    'caption', \
    'colortbl', \
    'dehyph-exptl', \
    'ec', \
    'environ', \
    'epstopdf-pkg', \
    'float', \
    'geometry', \
    'graphics', \
    'graphics-def', \
    'hycolor', \
    'hyperref', \
    'hyphen-german', \
    'iftex', \
    'koma-script', \
    'latex-graphics-dev', \
    'latexconfig', \
    'lm', \
    'makecell', \
    'multirow', \
    'oberdiek', \
    'pdflscape', \
    'tabu', \
    'tex-gyre-math', \
    'texlive-scripts', \
    'threeparttable', \
    'threeparttablex', \
    'titling', \
    'tools', \
    'trimspaces', \
    'ulem', \
    'varwidth', \
    'wrapfig', \
    'ulem', \
    'url', \
    'xcolor'"

RUN R -q -e "tinytex::tlmgr_conf()"
RUN R -q -e "tinytex::tlmgr_install(pkgs = c(${tiny}))"
RUN R -q -e "tinytex::tlmgr_update()"

RUN chown -R ${RSESSION_USER}:${RSESSION_USER} /home/${RSESSION_USER}/.TinyTeX && \
    chmod -R g+w /home/${RSESSION_USER}/.TinyTeX && \
    chmod -R g+wx /home/${RSESSION_USER}/bin

# add cloned repo
COPY ./addfolder /home/${RSESSION_USER}/

# repository name
ARG REPO_NAME=baseApp

# install our R-Package
RUN cd /home/${RSESSION_USER}/${REPO_NAME}/ && \
    R -q -e "devtools::install('.', upgrade = 'always')"

# add shiny app
COPY ./app.R /srv/shiny-server/
# add custom server conf (running shiny as user 'shiny' is more secure than running as 'root')
COPY ./shiny-server.conf /etc/shiny-server/
# add log-script
COPY ./show-log.sh /

# fix permissions
RUN chown -R ${RSESSION_USER}:${RSESSION_USER} /srv/shiny-server/
RUN chmod +x show-log.sh

# create log dir
RUN mkdir /home/${RSESSION_USER}/logs && \
    chown -R shiny:shiny /home/${RSESSION_USER}/logs

# https://stackoverflow.com/questions/51080857/preserve-environment-variables-when-spawning-shiny-processes-within-a-container?rq=1
ENTRYPOINT env >> /home/${RSESSION_USER}/.Renviron && \
    chown ${RSESSION_USER}.${RSESSION_USER} /home/${RSESSION_USER}/.Renviron && \
    /usr/bin/shiny-server.sh
