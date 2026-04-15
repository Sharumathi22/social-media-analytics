#-----------------------------------------------------------------------------
# Question 2
#----------------------------------------------------------------------------

#Part 1: YouTube User Analysis

# Load packages required for this session into library

library(vosonSML)
library(igraph)

#YouTube authentication

my_api_key <- "AIzaSyDWsMCLRj9gEk-xrziDj-UiSEu9-Iye64A"

# Authenticate to YouTube and collect data

yt_auth <- Authenticate("youtube", apiKey = my_api_key)

video_url <- c(
  "https://www.youtube.com/watch?v=EtJFYVVA3iQ",
  "https://www.youtube.com/watch?v=P5JLMp08GC0",
  "https://www.youtube.com/watch?v=l2ojUrbq8EM",
  "https://youtu.be/DYIOaifhjQU?si=DpHeIwHO_ARMpYh5",
  "https://www.youtube.com/watch?v=Y6kaz3HZt8o")

yt_data1 <- yt_auth |> Collect(videoIDs = video_url,
                              maxComments = 500,
                              writeToFile = TRUE,
                              verbose = TRUE) # use 'verbose' to show download progress


# Save & export the collected data

saveRDS(yt_data1, file = "yt_data1.rds") # save as an R object
write.csv(yt_data1, file = "yt_data1.csv") # export as a CSV


# View YouTube data

View(yt_data1)

# Load packages 

library(vosonSML)
library(dplyr)
library(tidyr)
library(tidytext)
library(textclean)
library(tm)
library(ggplot2)
library(igraph)


# Part 2: Reddit Analysis

thread_urls <- c(
  "https://www.reddit.com/r/TaylorSwift/comments/1fjf7ub/",
  "https://www.reddit.com/r/TaylorSwift/comments/1h9jo3u/",
  "https://www.reddit.com/r/TaylorSwift/comments/1g9i3m5/",
  "https://www.reddit.com/r/TaylorSwift/comments/1ccegul/",
  "https://www.reddit.com/r/TaylorSwift/comments/16ciubu/")


# Collect threads along with their comments, sorted by top-rated (best) first

rd_data <- Authenticate("reddit") |>  
  Collect(threadUrls = thread_urls,
          sort = "best", 
          waitTime = c(6, 8),
          writeToFile = TRUE, 
          verbose = TRUE) 

# Save & export the collected data

saveRDS(rd_data, file = "rd_data.rds") 
write.csv(rd_data, file = "rd_data.csv") 


# View the collected Reddit data

View(rd_data)

# Remove rows that have 'NA'

rd_data <- rd_data[complete.cases(rd_data), ]
View(rd_data)

#combine Youtube and Reddit

library(dplyr)
library(knitr)

#cleaned datasets:
# yt_data1 (YouTube comments)
# rd_data (Reddit posts/comments)

# Count rows for each platform
yt_n <- nrow(yt_data1)
rd_n <- nrow(rd_data)
total_n <- yt_n + rd_n

# Create table
data_summary <- tibble::tibble(
  Platform = c("YouTube", "Reddit", "Total"),
  `Queries / Sources (examples)` = c(
    "YouTube videos: Anti-Hero (2022), All Too Well 10 min version (2021), Love Story (2009), Eras Tour live performance, interview clips",
    "Subreddits: r/TaylorSwift, r/popheads; Threads: Eras Tour reactions, new album discussions, interview quotes",
    "---"
  ),
  `Rows Collected` = c(yt_n, rd_n, total_n)
)

# Print table
knitr::kable(
  data_summary,
  align = c("l", "c", "l"),
  caption = "Summary of platforms, sources, and collected row counts"
)
#------------------------------------------------------------------------------
# Question 3: Actor Network and Top 5 Influential Actors
#-------------------------------------------------------------------------------

# Create actor network from your YouTube data

yt_actor_network <- yt_data1 |> Create("actor")
yt_actor_graph <- yt_actor_network |> Graph()

#  Visualise the graph
plot(
  yt_actor_graph,
  vertex.label = NA,          
  vertex.size = 5,            
  vertex.color = "skyblue",
  edge.arrow.size = 0.4,
  main = "YouTube Actor Network for Taylor Swift"
)

#  visualisation
write_graph(yt_actor_graph, file = "YouTubeActor.graphml", format = "graphml")

# Calculate PageRank
pr <- page_rank(yt_actor_graph, directed = TRUE)$vector

# Top 5 users by PageRank
top5 <- sort(pr, decreasing = TRUE)[1:5]

# Create table
top5_df <- tibble::tibble(
  User = names(top5),
  PageRank = round(top5, 4)
)
# Print table
kable(top5_df, caption = "Top 5 Influential Users by PageRank")

#------------------------------------------------------------------------------
# Question 4: Unique Actors
#-------------------------------------------------------------------------------

# YouTube unique users
colnames(yt_data1)
colnames(rd_data)

# YouTube unique actors 
yt_unique <- length(unique(yt_data1$AuthorChannelID))

# Reddit unique actors 
rd_unique <- length(unique(rd_data$author))

# Combined total unique actors across both platforms
total_unique <- length(unique(c(yt_data1$AuthorChannelID, rd_data$author)))

# Print results
yt_unique; rd_unique; total_unique

#-------------------------------------------------------------------------------
# Question 5 Spotify API 
#-------------------------------------------------------------------------------

library(spotifyr)
library(dplyr)
library(purrr)
library(tidyr)
library(lubridate)
library(knitr)

# Set up authentication variables

app_id <- "7bd8cc4e88c14725bef22e81205a97de"
app_secret <- "c691da82cb6645f49a7b65f9c14b4fc0"
token <- "1"

# Authentication for spotifyr package:

Sys.setenv(SPOTIFY_CLIENT_ID = app_id)
Sys.setenv(SPOTIFY_CLIENT_SECRET = app_secret)
access_token <- get_spotify_access_token()

## 2) Get artist id for Taylor Swift
tswift <- search_spotify("Taylor Swift", type = "artist") %>% slice(1)
artist_id <- "06HL4z0CvFAxyc27GXpf02"

# Get all albums
albums <- get_artist_albums(artist_id, include_groups = "album,single,compilation,appears_on", limit = 50)
print(paste("Total albums/singles/compilations/appears_on:", nrow(albums)))

# Look at release years for years active
years <- substr(albums$release_date, 1, 4)
years <- years[!is.na(years)]
print(paste("First release year:", min(years)))
print(paste("Latest release year:", max(years)))
print(paste("Years active:", as.numeric(max(years)) - as.numeric(min(years)) + 1))

# Count total albums
print(paste("Total albums/singles/compilations:", nrow(albums)))

# Count all songs across all albums
all_tracks <- lapply(albums$id, get_album_tracks)   # fetch tracks for each album
total_songs <- sum(sapply(all_tracks, nrow))       # count rows (tracks) in each
print(paste("Total songs across all albums:", total_songs))


# Get top tracks to see collaborators
top_tracks <- get_artist_top_tracks(artist_id, market = "US")
print("Top tracks:")
print(top_tracks$name)

# Collaborators from those top tracks
collaborators <- unique(unlist(lapply(top_tracks$artists, function(x) x$name)))
collaborators <- collaborators[collaborators != "Taylor Swift"]
print("Frequent collaborators (from top tracks):")
print(collaborators)

#-------------------------------------------------------------------------------
# Q6 – Term-Document Matrix and Top 10 Frequent Terms
#-------------------------------------------------------------------------------

library(tm)
library(tidytext)
library(dplyr)

# Combine YouTube + Reddit text
all_text <- c(yt_data1$Comment, rd_data$comment)

# Create a text corpus
corpus <- VCorpus(VectorSource(all_text))

# Pre-processing: lower case, remove punctuation, stopwords, whitespace
corpus <- corpus %>%
  tm_map(content_transformer(tolower)) %>%
  tm_map(removePunctuation) %>%
  tm_map(removeNumbers) %>%
  tm_map(removeWords, stopwords("en")) %>%
  tm_map(stripWhitespace)

# Create Term-Document Matrix (TDM)
tdm <- TermDocumentMatrix(corpus)
tdm_matrix <- as.matrix(tdm)

# Term frequencies
term_freq <- rowSums(tdm_matrix)
top_terms <- sort(term_freq, decreasing = TRUE)[1:10]

print(top_terms)

#-------------------------------------------------------------------------------
# Q7 – Semantic (Bigram) Network and PageRank Analysis
#-------------------------------------------------------------------------------

install.packages("ggraph")
library(tidytext)
library(dplyr)
library(igraph)
library(ggraph)


# Combine YouTube + Reddit text
all_text <- c(yt_data1$Comment, rd_data$comment)

# Turn into tibble
text_df <- tibble(text = all_text)

# Tokenize into bigrams
bigrams <- text_df %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2)

# Split into two words
bigrams_sep <- bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ") %>%
  filter(!word1 %in% stop_words$word,
         !word2 %in% stop_words$word,
         !is.na(word1),
         !is.na(word2))

bigrams_sep <- bigrams_sep %>%
  filter(!grepl("[^a-z]", word1),   # keep only a–z words
         !grepl("[^a-z]", word2))

# Count bigram frequency
bigram_counts <- bigrams_sep %>%
  count(word1, word2, sort = TRUE)

# Build graph
bigram_graph <- graph_from_data_frame(bigram_counts)

# PageRank
pr <- page_rank(bigram_graph, directed = TRUE)$vector
top10_pr <- sort(pr, decreasing = TRUE)[1:10]

print(top10_pr)

#-------------------------------------------------------------------------------
# Question 8 - centrality analysis
#-------------------------------------------------------------------------------

library(igraph)

# Calculate centrality measures
deg_cent <- degree(yt_actor_graph, mode = "all", normalized = TRUE)
bet_cent <- betweenness(yt_actor_graph, normalized = TRUE)
close_cent <- closeness(yt_actor_graph, normalized = TRUE)

# Store in a dataframe
centrality_df <- data.frame(
  User = names(deg_cent),
  Degree = round(deg_cent, 4),
  Betweenness = round(bet_cent, 4),
  Closeness = round(close_cent, 4)
)

#  Taylor Swift official channel node 
ts_centrality <- centrality_df[centrality_df$User == "AuthorChannelID", ]

print(ts_centrality)

# Top 5 users by each centrality
head(centrality_df[order(-centrality_df$Degree), ], 5)
head(centrality_df[order(-centrality_df$Betweenness), ], 5)
head(centrality_df[order(-centrality_df$Closeness), ], 5)


# Taylor Swift’s official channel
ts_id <- "UCqECaJ8Gagnn7YCbPEzWH6g"

# Example: Ed Sheeran, Post Malone
edsheeran_id <- "UC0C-w0YjGpqDXGB8IHb662A"
postmalone_id <- "UCeLHszkByNZtPKcaVXOCOQQ"

# Get their scores from the centrality dataframe
centrality_df[centrality_df$User %in% c(ts_id, edsheeran_id, postmalone_id), ]

#--------------------------------------------------------------------------------
# Question 9 - community analysis with the Girvan-Newman and Louvain methods
#-------------------------------------------------------------------------------
library(igraph)

g <- yt_actor_graph                          
g_u <- as.undirected(g, mode = "collapse")  
g_u <- simplify(g_u, remove.multiple = TRUE, remove.loops = TRUE)

# Louvain
lv  <- cluster_louvain(g_u)
cat("Louvain -> communities:", length(lv), 
    " | modularity:", round(modularity(lv), 3), "\n")

# Girvan–Newman (edge betweenness)
gn  <- cluster_edge_betweenness(g_u)
cat("Girvan–Newman -> communities:", length(gn), 
    " | modularity:", round(modularity(gn), 3), "\n")

#  quick sizes of biggest groups
head(sort(table(membership(lv)), decreasing = TRUE), 5)
head(sort(table(membership(gn)), decreasing = TRUE), 5)

# simple plot to screenshot
plot(lv, g_u, vertex.label = NA, vertex.size = 4,
     main = "Louvain communities (YouTube actor network)")

#  graph object exists
g <- yt_actor_graph 

saveRDS(g, file = "YouTube_Actor_Network.rds")

# Save as GraphML 
write_graph(g, file = "YouTube_Actor_Network.graphml", format = "graphml")

# Save as GML 
write_graph(g, file = "YouTube_Actor_Network.gml", format = "gml")

cat("Graph saved as .rds, .graphml, and .gml files in your working directory.\n")

#-------------------------------------------------------------------------------
# Question 10 - Machine Learning Models  - sentiment analysis 
#-------------------------------------------------------------------------------

library(tidytext)
library(dplyr)
library(ggplot2)

# Combine text from YouTube and Reddit
all_text <- c(yt_data1$Comment, rd_data$comment)
text_df <- tibble(line = 1:length(all_text), text = all_text)

# Use Bing lexicon for sentiment classification
bing_sentiments <- get_sentiments("bing")

sentiment_results <- text_df %>%
  unnest_tokens(word, text) %>%
  inner_join(bing_sentiments, by = "word") %>%
  count(sentiment) %>%
  mutate(percent = n / sum(n) * 100)

print(sentiment_results)

# Optional: visualize
ggplot(sentiment_results, aes(x = sentiment, y = percent, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  labs(title = "Sentiment Distribution in Taylor Swift Discussions",
       x = "Sentiment", y = "Percentage")

#-------------------------------------------------------------------------------
# Question 11 - Decision Tree
#-------------------------------------------------------------------------------

library(rpart)
library(rpart.plot)
library(dplyr)
library(vosonSML)

thread_urls <- c(
  "https://www.reddit.com/r/TaylorSwift/comments/1fjf7ub/",
  "https://www.reddit.com/r/TaylorSwift/comments/1h9jo3u/",
  "https://www.reddit.com/r/TaylorSwift/comments/1g9i3m5/",
  "https://www.reddit.com/r/TaylorSwift/comments/1ccegul/",
  "https://www.reddit.com/r/TaylorSwift/comments/16ciubu/"
)

rd_data <- Authenticate("reddit") |>
  Collect(threadUrls = thread_urls,
          sort = "best",
          waitTime = c(6, 8),
          writeToFile = TRUE,
          verbose = TRUE)


set.seed(123)

rd <- rd_data %>%
  mutate(
    text = as.character(comment),
    text_length = nchar(text),
    word_count = sapply(strsplit(text, "\\s+"), length),
    is_taylor = ifelse(grepl("taylor|swift|eras tour", text, ignore.case = TRUE), "yes", "no")
  ) %>%
  select(text_length, word_count, comment_score, is_taylor) %>%
  filter(!is.na(is_taylor))

# Split data
train_index <- sample(1:nrow(rd), 0.8 * nrow(rd))
train <- rd[train_index, ]
test  <- rd[-train_index, ]

# Build decision tree
tree_model <- rpart(is_taylor ~ text_length + word_count + comment_score,
                    data = train, method = "class")

# Plot the tree
rpart.plot(tree_model,
           main = "Decision Tree: Predicting Taylor Swift Comments")

#-------------------------------------------------------------------------------
# Question 12: LDA Topic Modelling - Taylor Swift 
#-------------------------------------------------------------------------------

library(tidytext)
library(topicmodels)
library(tm)
library(dplyr)
library(ggplot2)

# Use comment text
text_data <- rd_data %>%
  filter(!is.na(comment)) %>%
  select(comment) %>%
  mutate(comment = tolower(comment))

# Create a corpus
corpus <- Corpus(VectorSource(text_data$comment))
corpus <- corpus %>%
  tm_map(content_transformer(tolower)) %>%
  tm_map(removeNumbers) %>%
  tm_map(removePunctuation) %>%
  tm_map(removeWords, stopwords("english")) %>%
  tm_map(stripWhitespace)

# --- 3. Create Document-Term Matrix ---
dtm <- DocumentTermMatrix(corpus)
dtm <- removeSparseTerms(dtm, 0.99)  # remove rarely used words

# Remove empty documents 
rowTotals <- apply(dtm, 1, sum)
dtm <- dtm[rowTotals > 0, ]

lda_terms <- tidy(lda_model, matrix = "beta")

top_terms <- lda_terms %>%
  group_by(topic) %>%
  top_n(10, beta)


# Now run LDA safely
lda_model <- LDA(dtm, k = 3, control = list(seed = 1234))


# Run LDA model with 3 topics
lda_model <- LDA(dtm, k = 3, control = list(seed = 1234))
lda_terms <- tidy(lda_model, matrix = "beta")

#Get top 10 words per topic
top_terms <- lda_terms %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

print(top_terms)

# Visualize
ggplot(top_terms, aes(reorder_within(term, beta, topic), beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free", ncol = 3) +
  coord_flip() +
  scale_x_reordered() +
  labs(title = "Top Terms by Topic (Taylor Swift Discussions)",
       x = "Terms", y = "Beta Value (Relevance)")



