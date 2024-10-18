# Install necessary packages
install.packages(c("tuber", "conflicted", "tidyverse", "tidytext", "tm", "syuzhet", "RColorBrewer", "wordcloud", "ggplot2", "stringr","dplyr", "purrr"))


# Load libraries
library(tuber)
library(conflicted)
library(tidyverse)
library(tidytext)
library(tm)
library(syuzhet)
library(RColorBrewer)
library(wordcloud)
library(ggplot2)
library(stringr)
library(dplyr)
library(purrr)


# OAuth credentials
client_id <- "389163633461-k88isjre0mskelape5ucfs1sko3q3eu7.apps.googleusercontent.com"
client_secret <- "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"

# Run OAuth flow
yt_oauth(app_id = client_id, app_secret = client_secret, token = '')


# Get details of a specific video (Sam and Colby's "Ghost Hunting at Haunted Insane Asylum")
video_id <- "eDUtBY7tOOc"
video <- get_video_details(video_id = "eDUtBY7tOOc")
print(video)

# Fetch comments for the specified video
comments <- get_comment_threads(filter = list(video_id = video_id), max_results = 100)

# View the result
print(comments)

# Assuming you have a dataframe called 'comments_raw' containing the comments
comments_raw <- data.frame(comment = c("I love this video!", "Ghosts", "Amazing content!", "Colby", "Sam"))

# Extract the text of the comments
comments_text <- comments$snippet.topLevelComment.snippet.textDisplay

# Create a Word Cloud of the Comments:
# Clean the text data
comments_clean <- tolower(comments_text)
comments_clean <- removePunctuation(comments_clean)
comments_clean <- removeNumbers(comments_clean)
comments_clean <- removeWords(comments_clean, stopwords("en"))

# Clean the comments (e.g., convert to lower case, remove punctuation, etc.)
comments_clean <- comments_raw %>%
  mutate(comment = str_to_lower(comment),         # Convert to lower case
         comment = str_replace_all(comment, "[[:punct:]]", ""),  # Remove punctuation
         comment = str_squish(comment))         # Remove extra whitespace

# Assuming comments_clean is your data frame and it contains a column named 'comment'
# Convert the 'comment' column to a character vector
comments_vector <- comments_clean$comment

# Now run the sentiment analysis
emotions <- get_nrc_sentiment(comments_vector)

# View the result
print(emotions)

# Tokenize the comments into individual words
comments_words <- comments_vector %>%
  tibble(comment = .) %>%
  unnest_tokens(word, comment)   # Split comments into individual words

# Remove stop words (common words like "the", "is", etc.)
data("stop_words")
comments_words_clean <- comments_words %>%
  anti_join(stop_words)

# Create a frequency table of words
word_freq <- comments_words_clean %>%
  count(word, sort = TRUE)

# Create the word cloud using the word frequency table
wordcloud(words = word_freq$word, 
          freq = word_freq$n, 
          max.words = 100, 
          random.order = FALSE, 
          colors = brewer.pal(8, "Dark2"))

# Create a Barplot of the Emotions in the Comments:
# Perform emotion analysis using the 'syuzhet' package
comments_vector <- comments_clean$comment

# Sum the emotions across all comments
emotions_summed <- colSums(emotions[, 1:8])

# Create a barplot
barplot(emotions_summed, main = "Emotions in YouTube Comments", col = rainbow(8), las = 2)

# Calculate a Polarity Score for Each Comment:
# Get polarity (sentiment) scores
polarity <- get_sentiment(comments_clean, method = "syuzhet")

# Add polarity scores to the dataset
comments_with_polarity <- data.frame(comments_text = comments_clean$comment, polarity)
head(comments_with_polarity)

# Collect Videos Related to a Keyword:
# Search for videos related to a keyword
related_videos <- yt_search(term = "Haunted Asylum", max_results = 50)

# View the results
head(related_videos)

# Collect Statistics on a YouTube Channel:
# Define the search term
search_term <- "samandcolby"

# Search for channels related to Sam and Colby (without specifying type)
channel_search <- yt_search(term = "samandcolby", max_results = 50)
str(channel_search)

# Filter the results for channels only (if needed)
channel_info <- channel_search %>%
  dplyr::filter(type == "youtube#channel")

# Get channel statistics
channel_stats <- get_channel_stats(channel_id = "UCg3gzldyhCHJjY7AWWTNPPA") #via View Page Source 
print(channel_stats)

# Extract the channel ID from the search results
channel_id <- channel_info$channelId[1]


# Collect Comments on All Videos in a Playlist:
# Get playlist ID for Hell Week
playlist_id <- "PLACTnd0ddAekU2GyoItTQ7BoE0C7PvL3M"

# Get all videos in the playlist
playlist_videos <- get_playlist_items(playlist_id = "PLACTnd0ddAekU2GyoItTQ7BoE0C7PvL3M", max_results = 50)

# Extract video IDs
video_ids <- playlist_videos$contentDetails.videoId

# Collect comments for each video in the playlist
playlist_comments <- purrr::map(video_ids, function(id) {
  get_comment_threads(filter = list(video_id = id), max_results = 100)
})

# Extract and clean comments for word cloud
all_comments <- unlist(lapply(playlist_comments, function(x) x$snippet.topLevelComment.snippet.textOriginal))
all_comments_clean <- tolower(all_comments)
all_comments_clean <- removePunctuation(all_comments_clean)
all_comments_clean <- removeNumbers(all_comments_clean)
all_comments_clean <- removeWords(all_comments_clean, stopwords("en"))

# Create a word cloud of all comments
wordcloud(all_comments_clean, max.words = 100, random.order = FALSE, colors = brewer.pal(8, "Dark2"))

# Save the R script
writeLines(text = your_code, con = "youtube_analysis.R")
