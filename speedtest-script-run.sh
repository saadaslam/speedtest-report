#!/bin/zsh

cd ~/r_stuff/speedtest-report/

/Users/saad/r_stuff/speedtest-report/speedtest-script.R
export RSTUDIO_PANDOC='/Applications/RStudio.app/Contents/MacOS/pandoc'
/usr/local/bin/Rscript -e 'rmarkdown::render(here::here("dashboard.Rmd"))'

