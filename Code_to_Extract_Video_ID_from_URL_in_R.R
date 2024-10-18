# Load required package
library(stringr)

# Example video URLs
video_urls <- c("https://www.youtube.com/watch?v=eDUtBY7tOOc",
                "https://youtu.be/eDUtBY7tOOc",
                "https://www.youtube.com/embed/eDUtBY7tOOc")

# Function to extract video ID
extract_video_id <- function(url) {
  str_extract(url, "(?<=v=|/)([a-zA-Z0-9_-]{11})")  # For standard and embed formats
}

# Apply the function to the vector of URLs
video_ids <- sapply(video_urls, extract_video_id)
video_ids


# Example video URLs
video_urls <- c("https://www.youtube.com/@samandcolby",
                "https://youtu.be/@samandcolby",
                "https://www.youtube.com/embed/@samandcolby")

# Function to extract video ID
extract_video_id <- function(url) {
  str_extract(url, "(?<=v=|/)([a-zA-Z0-9_-]{11})")  # For standard and embed formats
}

# Apply the function to the vector of URLs
video_ids <- sapply(video_urls, extract_video_id)
video_ids
