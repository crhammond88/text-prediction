#### Build Models for Text Prediction
# Dataset: https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip

library(stringi)
library(tm)
library(tokenizers)
library(plyr)
library(dplyr)
library(tidyr)
library(stringr)


#Load data
blogs <- readLines("final/en_US/en_US.blogs.txt", encoding = "UTF-8", skipNul = TRUE)
twitter <- readLines("final/en_US/en_US.twitter.txt", encoding = "UTF-8", skipNul = TRUE)

bin.news <- file("final/en_US/en_US.news.txt", open="rb") #read as binary to avoid data loss
news <- readLines(bin.news, encoding="UTF-8")
close(bin.news)
rm(bin.news)

trainingData <- c(blogs, twitter, news)

# Clean data
cleanSourceText <- function(dirtyData) {
  cleanData <- Corpus(VectorSource(dirtyData)) %>% #convert to SimpleCorpus for text mining
    tm_map(str_replace_all, "[^[:alnum:]'.:;&+-]", " ") %>% #remove unwanted characters and punctuation
    tm_map(removeNumbers) %>%
    tm_map(stripWhitespace)
} 

trainingData <- cleanSourceText(trainingData)


# Tokenize and sort data
splitGrams <- function(textData, size, columnNames) {
  gramData <- tm_map(textData, tokenize_ngrams, n=size) #split into n-grams (removes most punctuation & sets to lower)
  gramData <- data.frame(unlist(sapply(gramData, identity)), stringsAsFactors=FALSE) #convert to data frame
  gramData <- data.frame(table(gramData)) #use table conversion to group terms
  gramData <- gramData[order(gramData$Freq, decreasing=TRUE),] #sort with most frequent terms first
  gramData <- separate(gramData, gramData, into=columnNames, sep=" ") #split n-grams into seperate words
  return(gramData)
}

oneGrams <- splitGrams(trainingData, 1, "word")
twoGrams <- splitGrams(trainingData, 2, c("word1", "word2"))
threeGrams <- splitGrams(trainingData, 3, c("word1", "word2", "word3"))
fourGrams <- splitGrams(trainingData, 4, c("word1", "word2", "word3", "word4"))
fiveGrams <- splitGrams(trainingData, 5, c("word1", "word2", "word3", "word4", "word5"))

# Filter out noise in the models, occurences of less than 10
oneGrams <- filter(oneGrams, Freq > 9)
twoGrams <- filter(twoGrams, Freq > 9)
threeGrams <- filter(threeGrams, Freq > 9)
fourGrams <- filter(fourGrams, Freq > 9)
fiveGrams <- filter(fiveGrams, Freq > 9)

# Filter out single letter words that aren't really words
wrongLetters <- letters[!letters %in% c("a","i")]
oneGrams <- filter(oneGrams, !(word %in% wrongLetters))
twoGrams <- filter(twoGrams, !(word1 %in% wrongLetters | word2 %in% wrongLetters))
threeGrams <- filter(threeGrams, !(word1 %in% wrongLetters | word2 %in% wrongLetters | word3 %in% wrongLetters))
fourGrams <- filter(fourGrams, !(word1 %in% wrongLetters | word2 %in% wrongLetters | 
                                   word3 %in% wrongLetters | word4 %in% wrongLetters))
fiveGrams <- filter(fiveGrams, !(word1 %in% wrongLetters | word2 %in% wrongLetters | 
                                   word3 %in% wrongLetters | word4 %in% wrongLetters | word5 %in% wrongLetters))

# Store Models
# saveRDS(oneGrams, file = 'oneGramsCombo.rds')
# saveRDS(twoGrams, file = 'twoGramsCombo.rds')
# saveRDS(threeGrams, file = 'threeGramsCombo.rds')
# saveRDS(fourGrams, file = 'fourGramsCombo.rds')
# saveRDS(fiveGrams, file = 'fiveGramsCombo.rds')