library(stringi)
library(tm)
library(tokenizers)
library(plyr)
library(wordcloud)
library(ggplot2)

#Load Data
blogs <- readLines("final/en_US/en_US.blogs.txt", encoding = "UTF-8", skipNul = TRUE)
twitter <- readLines("final/en_US/en_US.twitter.txt", encoding = "UTF-8", skipNul = TRUE)

bin.news <- file("final/en_US/en_US.news.txt", open="rb") #read as binary to avoid data loss
news <- readLines(bin.news, encoding="UTF-8")
close(bin.news)
rm(bin.news)


# Summarize Data
blogs.wordCount <- stri_count_words(blogs)
news.wordCount <- stri_count_words(news)
twitter.wordCount <- stri_count_words(twitter)

data.frame(t(sapply(list(blogs,news,twitter),stri_stats_general)),
           WordCount = c(sum(blogs.wordCount), sum(news.wordCount), sum(twitter.wordCount)),
           WordAverage = c(mean(blogs.wordCount), mean(news.wordCount), mean(twitter.wordCount)),
           row.names = c("blogs", "news", "twitter"))


# Sample Data
set.seed(1337)
sampleTwitter <- twitter[sample(1:length(twitter),10000)]
sampleBlogs <- blogs[sample(1:length(blogs),10000)]
sampleNews <- news[sample(1:length(news),10000)]
sampleData <- c(sampleTwitter,sampleBlogs,sampleNews)


# Clean Data
cleanData <- Corpus(VectorSource(sampleData))

toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
cleanData <- tm_map(cleanData, toSpace, "[^[:graph:]]") #remove non-visible characters
cleanData <- tm_map(cleanData, toSpace, "\"|\/|\\|@") #remove symbols (",/,\,@)
cleanData <- tm_map(cleanData, removeNumbers)
cleanData <- tm_map(cleanData, removePunctuation)
cleanData <- tm_map(cleanData, stripWhitespace)
cleanData <- tm_map(cleanData, tolower)
#cleanData <- tm_map(cleanData, stemDocument) #reduce words to stem form
cleanData <- tm_map(cleanData, removeWords, stopwords("en"))


# Tokenize Data
splitGrams <- function(size) {
  gramData <- tm_map(cleanData, tokenize_ngrams, n=size, n_min=size) #split into n-grams 
  gramData <- data.frame(text=unlist(sapply(gramData, identity)), stringsAsFactors=FALSE) #convert to dataframe
  gramData <- data.frame(table(gramData)) #convert to table to group terms
  gramData <- gramData[order(gramData$Freq, decreasing=TRUE),] #sort with most frequent n-grams first
  return(gramData)
}

twoGrams <- splitGrams(2)
threeGrams <- splitGrams(3)
fourGrams <- splitGrams(4)
fiveGrams <- splitGrams(5)


# Visualize Data
wordcloud(cleanData, scale=c(3,.5), max.words=100, random.order=FALSE,
          rot.per=0, colors=brewer.pal(8, "Dark2"))

plotGrams <- function(data, maxNum, color, xlabel) {
  ggplot(data[1:maxNum,], aes(reorder(first, Freq), Freq)) + 
    geom_bar(stat="identity", fill=color) +
    labs(x=xlabel, y="Frequency") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 70, size = 10, hjust = 1))
}

plotGrams(twoGrams, 50, "blue", "2-Grams")
plotGrams(threeGrams, 50, "red", "3-Grams")
plotGrams(fourGrams, 25, "green", "4-Grams")
plotGrams(fiveGrams, 10, "purple", "5-Grams")

