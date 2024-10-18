# Install tuber package
install.packages('tuber')
# Load tuber package
library(tuber)

# Set working directory.
setwd("C:/Users/User/OneDrive - The University of Texas-Rio Grande Valley/Documents/UTRGV/GRAD MSBA/INFS 6353")

# Authenticate using your YouTube client ID and client secret key
## Then authenticate in browser
client_id = "389163633461-k88isjre0mskelape5ucfs1sko3q3eu7.apps.googleusercontent.com"
client_secret = "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"
yt_oauth(client_id, client_secret, token = '')


#######################################################################################
# Collect stats and video list on playlist of a youtube channel 
# If you keep getting error message "Error: HTTP failure: 401", delete your httr = oauth in the folder where R script is located
#######################################################################################

# Package for drawing the plots
install.packages('ggplot2')
library(ggplot2)

# Package for arranging the plots in grids
install.packages('gridExtra')
library(gridExtra)

# dplyr package for converting character to number
install.packages('dplyr')
library('dplyr')

# Get channel statistics
chstat = get_channel_stats("UCX6b17PVsYBQ0ip5gyeme-Q")

# Obtain playlists of channel
playlists_ids <- get_playlists(filter = c(channel_id = "UCX6b17PVsYBQ0ip5gyeme-Q"))

# Get ID of one playlist
playlist_id <- playlists_ids$items[[7]]$id
playlist_videos <- get_playlist_items(filter = c(playlist_id = playlist_id))

# Video ids
video_ids <- as.vector(playlist_videos$contentDetails.videoId)

# Function to scrape stats for all videos
get_all_stats <- function(id){
  get_stats(id)
}

# Get stats and convert results to data frame
video_stats <- lapply(video_ids, get_all_stats)
video_stats_df <- do.call(rbind, lapply(video_stats, data.frame))

# Convert list to data frame
video_stats_df = data.frame(video_stats_df)

# Convert text in the count colums to number
videos_stats_df <- video_stats_df %>% mutate_at(c('viewCount','likeCount','favoriteCount','commentCount'), as.numeric)

# View first few rows of results
View(video_stats_df)

# Save video stats to a csv file in working directory
write.csv(video_stats_df, file = 'YouTubePlaylistvideoStats.csv')

# Create video stats plot displaying various counts (like, comments) against view count
# "[,-1]" removes first column "()""id" from the data frame
# geom_point creates a scatterplot
p1 = ggplot(data = video_stats_df[,-1]) + geom_point(aes(x = viewCount, y = likeCount))
p2 = ggplot(data = video_stats_df[,-1]) + geom_point(aes(x = viewCount, y = commentCount))
grid.arrange(p1, p2, ncol = 1)


########################################################################################
# Collect comments on videos in playlist and plot word clouds of comments
########################################################################################

# Install tm, Snowballc, and wordcloud packages for text preprocessing and word clouds
install.packages('tm')
library(tm)
install.packages('SnowballC')
library(SnowballC)
install.packages('wordcloud')
library(wordcloud)

# Create function get_video_comments that retrieves the comments based on an id
get_video_comments <- function(id){
  get_all_comments(c(video_id = id), max_results = 1000)
}

# Call function get_video_comments on all ids in video_ids to collect their comments
comments = lapply(as.character(video_ids), get_video_comments)

# View info on comments on first video as a data frame 
View(data.frame(comments[1]))

# View info on comments on second video as adata frame 
View(data.frame(comments[2]))

# Get comments text from comments data list
comments_text = lapply(comments, function(x){
  as.character(x$textOriginal)
})

# View comments text on first video as a data frame 
View(data.frame(comments_text[1]))

# Use reduce function to merge all data lists on comments on different videos into one variable
text = Reduce(c, comments_text) # text is now a data frame that has comments on all videos
View(text)

# Create text corpus using comment text
comments_corp=Corpus(VectorSource(text))

# Text processing and create document-term matrix
comments_DTM=DocumentTermMatrix(comments_corp,control=list(removePunctuation=T,removeNumbers=T,stopwords=T))

# Displays first five terms in DTM
as.matrix(comments_DTM[,1:5])

# Create matrix of terms and frequency
comments_terms=colSums(as.matrix(comments_DTM))
comments_terms_matrix=as.matrix(comments_terms)
comments_terms_matrix

# Create word cloud
wordcloud(words=names(comments_terms),freq=comments_terms, vfont=c('serif', 'bold italic'), colors=brewer.pal(8, 'Dark2'))
