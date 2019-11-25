####################
rm(list=ls())
gc()

###############
library(tidyverse)
library(rtweet)
library(tidytext)
library(stringr)
library(tm)
library(dplyr)
require(RColorBrewer) 
library('wordcloud')
require(plyr)
require(stringi)
#######################

packageVersion("rtweet")

sessionInfo()

twitter_token <- create_token(
  
  app = "Beekash Mohanty",
  
  consumer_key = "YZ5ph9NORTEHUZZrNXxQ3ofiW",
  
  consumer_secret = "xQEjXF0SpxlX8HHk8ZCDcvZVReKIHX7pKgVh1UqcIHXdmiRF2z",
  access_token="1198129748708225024-CUIxSAHkO1ELN3CMSCLsJ0VA2BSHCE",
  access_secret="fbPHR1UkBpzzvzs74m5I8w43zk2sRoLKdlbSSCOAB00S5")

tweets = search_tweets("#bitcoin", n=100, lang='en')

View(tweets)

content_url <- tweets$status_url

tweets_text = tweets$text
clean.text = function(x)
{
  x <- gsub("<(.*)>","",x)
  x <- gsub("#*",'',x)
  x <- gsub("http.*",'',x)
  x <- gsub("https.*",'',x)
  x = gsub("http\\w+", "", x)
  x = gsub("[ \t]{2,}", "", x)
  x = gsub("^\\s+|\\s+$", "", x) 
  x = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", x)
  x = gsub("http\\w+", "", x)
  x = gsub("[ \t]{2,}", "", x)
  x = gsub("^\\s+|\\s+$", "", x) 
  x <- gsub("[][!#$%()'*.,:;<=>@^|~`{}]",'',x)
  x <- gsub("[[:punct:]]",'',x)
  x <- gsub('[0-9]+','',x)
  x <- gsub('@','',x)
  x <- gsub(',','',x)
  x <- gsub('\n\n','',x)
  x <- tolower(x)
}


geartweets = clean.text(tweets_text)


pos.words = scan('C:\\Users\\user\\Desktop\\cyber hackathon\\positive-words.txt', what='character', comment.char=';')
neg.words = scan('C:\\Users\\user\\Desktop\\cyber hackathon\\negative-words.txt', what='character', comment.char=';')


neg.words = c(neg.words, 'wtf', 'fail')



score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
{
  
  # we got a vector of sentences. plyr will handle a list
  # or a vector as an "l" for us
  # we want a simple array of scores back, so we use
  # "l" + "a" + "ply" = "laply":
  scores = laply(sentences, function(sentence, pos.words, neg.words) {
    
    # clean up sentences with R's regex-driven global substitute, gsub():
    sentence = gsub('[[:punct:]]', '', sentence)
    sentence = gsub('[[:cntrl:]]', '', sentence)
    sentence = gsub('\\d+', '', sentence)
    # and convert to lower case:
    sentence = tolower(sentence)
    
    # split into words. str_split is in the stringr package
    word.list = str_split(sentence, '\\s+')
    # sometimes a list() is one level of hierarchy too much
    words = unlist(word.list)
    
    # compare our words to the dictionaries of positive & negative terms
    pos.matches = match(words, pos.words)
    neg.matches = match(words, neg.words)
    
    # match() returns the position of the matched term or NA
    # we just want a TRUE/FALSE:
    pos.matches = !is.na(pos.matches)
    neg.matches = !is.na(neg.matches)
    
    # and conveniently enough, TRUE/FALSE will be treated as 1/0 by sum():
    score = sum(pos.matches) - sum(neg.matches)
    
    return(score)
  }, pos.words, neg.words, .progress=.progress )
  
  scores.df = data.frame(score=scores, text=sentences)
  return(scores.df)
}


sentiment.scores= score.sentiment(geartweets, pos.words, neg.words, .progress='none')

score <- sentiment.scores$score

#library(plotly)
#p <- plot_ly(x = ~score, type = "histogram")

#p

Final_Dataset <- data.frame(score=score, Post=geartweets, Content_URL = content_url)

Final_Dataset <- Final_Dataset[score < 0,]


#negativeTweets = subset(sentiment.scores, score < 0)$text


positive.words = scan('C:\\Users\\user\\Desktop\\cyber hackathon\\positive-words.txt', what='character', comment.char=';')
negative.words = scan('C:\\Users\\user\\Desktop\\cyber hackathon\\negative-words.txt', what='character', comment.char=';')
score.topic = function(sentences, pos.words, neg.words, .progress='none')
{
  require(plyr)
  require(stringr)
  require(stringi)
  
  # we got a vector of sentences. plyr will handle a list
  # or a vector as an "l" for us
  # we want a simple array of scores back, so we use
  # "l" + "a" + "ply" = "laply":
  scores = laply(sentences, function(sentence, pos.words, neg.words) {
    
    # clean up sentences with R's regex-driven global substitute, gsub():
    sentence = gsub('[[:punct:]]', '', sentence)
    sentence = gsub('[[:cntrl:]]', '', sentence)
    sentence = gsub('\\d+', '', sentence)
    # and convert to lower case:
    sentence = tolower(sentence)
    
    # split into words. str_split is in the stringr package
    word.list = str_split(sentence, '\\s+')
    # sometimes a list() is one level of hierarchy too much
    words = unlist(word.list)
    
    # compare our words to the dictionaries of positive & negative terms
    pos.matches = match(words, pos.words)
    neg.matches = match(words, neg.words)
    # match() returns the position of the matched term or NA
    # we just want a TRUE/FALSE:
    pos.matches = !is.na(pos.matches)
    neg.matches = !is.na(neg.matches)
    
    # and conveniently enough, TRUE/FALSE will be treated as 1/0 by sum():
    score = sum(pos.matches) - sum(neg.matches)
    
    return(score)
  }, pos.words, neg.words, .progress=.progress )
  
  topicscores.df = data.frame(score=scores, text=sentences)
  return(topicscores.df)
}

topic.scores= score.topic(geartweets, pos.words, neg.words, .progress='none')
topic.pos = subset(topic.scores, score >0)
topic.neg = subset(topic.scores, score <0)
topic.neu = subset(topic.scores, score =0)

postive= nrow(topic.pos)
negitive = nrow(topic.pos)
neutral = nrow(topic.neu)

dftemp=data.frame(topic=c("Postive", "Negitive", "Netural"), 
                  number=c(postive,negitive,neutral))

library(plotly)
p <- plot_ly(data=dftemp, labels = ~topic, values = ~number, type = 'pie') %>%
  layout(title = 'Pie Chart of Tweets Mentioning Decisions',
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

p

print(Final_Dataset)
