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
# Collect data on a YouTube video
#######################################################################################

# Get statistics of a video with ID a0_lo_GDcFw
get_stats(video_id = "a0_lo_GDcFw")

# Get details about the video
get_video_details(video_id = "a0_lo_GDcFw")

# Search videos and save results in data frame called search_result
search_result <- yt_search("Artificial Intelligence")
# Views the first three columns and the first few rows in results
View(search_result)

# Get comments on video and saves them to data frame called comments
comments <- get_all_comments(c(video_id = "a0_lo_GDcFw"))
# View first few rows of comments
View(comments)

# Save comments to a csv file in working directory
write.csv(comments, file = "YouTubeVideoComments.csv")

#######################################################################################
# Create word cloud of the comments
#######################################################################################

# Install tm, SnowballC, and wordcloud packages for text preprocessing and word clouds
install.packages('tm')
library(tm)
install.packages('SnowballC')
library(SnowballC)
install.packages('wordcloud')
library(wordcloud)

# Create comments corpus
comments_corp = Corpus(VectorSource(comments$textOriginal))

# Text preprocessing and create document-term matrix
comments_DTM = DocumentTermMatrix(comments_corp,
                                  control=list(removePunctuation = T, removeNumbers = T, stopwords = T))

# Displays first five terms in DTM
as.matrix(comments_DTM[,1:5])

# Create matrix of terms and frequency
comments_terms = colSums(as.matrix(comments_DTM))
comments_terms_matrix = as.matrix(comments_terms)
comments_terms_matrix

# Create word cloud
wordcloud(words = names(comments_terms), freq = comments_terms, vfont = c('serif', 'bold italic'), colors = 1: nrow(comments_terms_matrix))

#######################################################################################
# Use get_nrc_sentiment function to obtain the sentiment of video comments
#######################################################################################
install.packages('syuzhet') # install syuzhet package for sentiment analysis
library(syuzhet)

# Get raw sentiment scores for each comment
video_sentiment = get_nrc_sentiment(as.character(comments$textOriginal))
View(video_sentiment)

# Obtain transpose of data frame
video_sentimentDF = t(data.frame(video_sentiment))
View(video_sentimentDF)

# Calculate number of comments with each emotion > 0
videocommentsEmotionsDFCount = data.frame(rownames(video_sentimentDF), rowSums(video_sentimentDF > 0))
View(videocommentsEmotionsDFCount)
rownames(videocommentsEmotionsDFCount)=NULL # Set row names to NULL
colnames(videocommentsEmotionsDFCount)=c('Emotion', 'Frequency') # Set column names to 'Emotion' and 'Frequency'
View(videocommentsEmotionsDFCount)

# Barplot of YouTube video comment sentiment
barplot(videocommentsEmotionsDFCount$Frequency, names.arg = videocommentsEmotionsDFCount$Emotion, main = "YouTube video comments sentiment", xlab = "Emotions", ylab = "Frequency")

# Obtain a single sentiment score for each comment
# Positive values indicate positive sentiment and negative values indicate negative sentiment
videocommentpolarity = data.frame(as.character(comments$textOriginal), get_sentiment(as.character(comments$textOriginal)))
colnames(videocommentpolarity) = c('Comments', 'Polarity') # Set column name to "Polarity"
View(videocommentpolarity)
