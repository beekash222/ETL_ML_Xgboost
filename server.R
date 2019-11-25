
server <- function(input, output,session) {

  ########
  observeEvent(input$rpart, {###############
    library(tidyverse)
    library(reticulate)
    library(rtweet)
    library(tidytext)
    library(stringr)
    library(tm)
    library(dplyr)
    require(RColorBrewer) 
    library(wordcloud)
    require(plyr)
    require(stringi)
    #######################
    config_file <- read.csv("C:\\Users\\user\\Desktop\\cyber hackathon\\config_file.txt",header = FALSE,stringsAsFactors =FALSE)
    
    twitter_token <- create_token(
      
      app = config_file[1,1],
      
      consumer_key = config_file[2,1],
      
      consumer_secret = config_file[3,1],
      access_token=config_file[4,1],
      access_secret=config_file[5,1])
    
    tweets = search_tweets(input$search, n=input$integer, lang='en')
    
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
    
    Final_Dataset$score <- NULL
    
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
    
      output$plot <- renderPlotly({
        library(plotly)
        p <- plot_ly(data=dftemp, labels = ~topic, values = ~number, type = 'pie') %>%
          layout(title = 'Sentiments',
                 xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                 yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
        
    
        })

   
      write.csv(Final_Dataset,"C:\\Users\\user\\Desktop\\cyber hackathon - Copy\\neg_tweet_updated.csv", row.names = FALSE)
      
      py_run_file("C:\\Users\\user\\Desktop\\cyber hackathon - Copy\\neg_tweet.py")
      
      
      x <- py$db$topic
      
      x <- as.data.frame(x)
      
      Final_Dataset1 = cbind(Final_Dataset,x)
      
      names(Final_Dataset1)[3]<-paste("Categories") 
      
      output$result<-renderTable({
        Final_Dataset1
      })

      output$Hist <- renderPlot({
        library(ggplot2)
        # counts
        ggplot(data.frame(Final_Dataset1$Categories), aes(x=Final_Dataset1$Categories)) +
          geom_bar()
      }) 
      
      library(mailR)
      library(htmlTable)
      
      
      # Convert the data frame into an HTML Table
      y <- htmlTable(Final_Dataset1, rnames = FALSE)
      
      html_body <- paste0("<p> This is a Social_Monitoring_Result result based on search keyword </p>", y)
      
      # Configure details to send email using mailR
      sender <- "bikumohanty91@gmail.com"
      recipients <- c(config_file[8,1],config_file[9,1],config_file[10,1],config_file[11,1])
      
      send.mail(from = sender,
                to = recipients,
                subject = "Social_Monitoring_Result",
                body = html_body,
                smtp = list(host.name = "smtp.gmail.com",
                            port = 465, 
                            user.name = "bikumohanty91@gmail.com",            
                            passwd = config_file[7,1],
                            ssl = TRUE),
                authenticate = TRUE,
                html = TRUE,
                send = TRUE)
      
      require(RColorBrewer)
      
      negativeTweets = subset(sentiment.scores, score < 0)$text
      
      corpus = Corpus(VectorSource(negativeTweets))
      # corpus = Corpus(VectorSource(cmail))
      # create term-document matrix
      tdm = TermDocumentMatrix(
        corpus,
        control = list(
          wordLengths=c(3,20),
          removePunctuation = TRUE,
          stopwords = c("the", "a", stopwords("english")),
          removeNumbers = TRUE, tolower = TRUE) )
      # convert as matrix
      tdm = as.matrix(tdm)
      
      # get word counts in decreasing order
      word_freqs = sort(rowSums(tdm), decreasing=TRUE) 
      word_freqs = word_freqs[-(1:12)]
      # create a data frame with words and their frequencies
      dm = data.frame(word=names(word_freqs), freq=word_freqs)
      
      #Plot corpus in a clored graph; need RColorBrewer package
      
      output$plot1 <- renderPlot({
        wordcloud(
          words = dm$word, 
                  freq =dm$freq,
                  random.order=FALSE, rot.per=0.3,   
                  scale=c(4,.5),max.words=15, 
                  colors=brewer.pal(8,"Dark2"))
      })
 
      
      # Final_Dataset1 = cbind(Final_Dataset,x)
    
  })
  
  
}

