#!/usr/local/bin/Rscript
library(speedtest)
library(tidyverse)
library(fs)
library(here)

config <- spd_config()

servers <- spd_servers(config)
best_servers <- spd_best_servers(servers = servers, config = config, max = 3)

best_servers_ul <- best_servers %>% 
  group_split(id = row_number()) %>% 
  map_dfr(
    ~ spd_upload_test(.x, config = config, summarise = FALSE, .progress = FALSE)
  ) %>% 
  mutate(
    test_datetime = Sys.time(),
    test_type = "upload",
    id = as.character(id)
  )

cat("upload finished at", as.character(Sys.time()), "\n")

best_servers_dl <- best_servers %>% 
  rowwise() %>% 
  group_split() %>% 
  map_dfr(
    ~ spd_download_test(.x, config = config, summarise = FALSE, .progress = FALSE)
  ) %>% 
  mutate(
    test_datetime = Sys.time(),
    test_type = "download"
  )

cat("download finished at", as.character(Sys.time()), "\n")

if(! dir_exists(here("output-files"))) {
  dir_create(here("output-files"))
}

bind_rows(
  best_servers_ul,
  best_servers_dl
) %>% 
  write_csv(here("output-files", "test-results.csv"), na = "", append = TRUE, ) %>%
  head()


