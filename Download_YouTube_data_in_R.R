install.packages("tuber")
install.packages("conflicted")

# Load libraries
library(tuber)        # YouTube API
library(magrittr)     # Pipes %>%, %T>% and equals(), extract().
library(tidyverse)    # All tidyverse packages
library(purrr)        # Package for iterating/extracting data
library(conflicted)   # Handling conflicts between packages

client_id <- "389163633461-rp8ai2tm5am51n275t8lfgs50t2vtr6m.apps.googleusercontent.com"
client_secret <- "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"

# Use YouTube OAuth
yt_oauth(app_id = client_id, app_secret = client_secret, token = '')

dave_chappelle_playlist_id <- stringr::str_split(
  string = "https://www.youtube.com/playlist?list=PLG6HoeSC3raE-EB8r_vVDOs-59kg3Spvd", 
  pattern = "=", 
  n = 2,
  simplify = TRUE)[ , 2]
dave_chappelle_playlist_id

[1] "PLG6HoeSC3raE-EB8r_vVDOs-59kg3Spvd"

DaveChappelleRaw <- tuber::get_playlist_items(filter = 
                                                c(playlist_id = "PLG6HoeSC3raE-EB8r_vVDOs-59kg3Spvd"), 
                                              part = "contentDetails",
                                              # set this to the number of videos
                                              max_results = 200) 

# check the data for Dave Chappelle
DaveChappelleRaw %>% dplyr::glimpse(78)
Observations: 200
Variables: 6
$ .id                              "items1", "items2", "items3", "item…
    $ kind                             youtube#playlistItem, youtube#playl…
    $ etag                             "p4VTdlkQv3HQeTEaXgvLePAydmU/G-gTM9…
$ id                               UExHNkhvZVNDM3JhRS1FQjhyX3ZWRE9zLTU…
$ contentDetails.videoId           oO3wTulizvg, ZX5MHNvjw7o, MvZ-clcMC…
$ contentDetails.videoPublishedAt  2019-04-28T16:00:07.000Z, 2017-12-3…

dave_chap_ids <- base::as.vector(DaveChappelleRaw$contentDetails.videoId)
dplyr::glimpse(dave_chap_ids)
chr [1:200] "oO3wTulizvg" "ZX5MHNvjw7o" "MvZ-clcMCec" "4trBQseIkkc" ...

# Function to scrape stats for all vids
get_all_stats <- function(id) {
  tuber::get_stats(video_id = id)
} 

# Get stats and convert results to data frame 
DaveChappelleAllStatsRaw <- purrr::map_df(.x = dave_chap_ids, 
                                          .f = get_all_stats)

DaveChappelleAllStatsRaw %>% dplyr::glimpse(78)

Observations: 200
Variables: 6
$ id             "oO3wTulizvg", "ZX5MHNvjw7o", "MvZ-clcMCec", "4trBQse…
$ viewCount      "4446789", "19266680", "6233018", "8867404", "7860341…
$ likeCount      "48699", "150691", "65272", "92259", "56584", "144625…
$ dislikeCount   "1396", "6878", "1530", "2189", "1405", "3172", "1779…
$ favoriteCount  "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"…
$ commentCount   "2098", "8345", "5130", "5337", "2878", "9071", "4613…

# export DaveChappelleRaw
readr::write_csv(x = as.data.frame(DaveChappelleRaw), 
                 path = paste0("data/", 
                               base::noquote(lubridate::today()),
                               "-DaveChappelleRaw.csv"))

# export DaveChappelleRaw
readr::write_csv(x = as.data.frame(DaveChappelleAllStatsRaw), 
                 path = paste0("data/", 
                               base::noquote(lubridate::today()),
                               "-DaveChappelleAllStatsRaw.csv"))

# verify
fs::dir_ls("data", regexp = "Dave")

