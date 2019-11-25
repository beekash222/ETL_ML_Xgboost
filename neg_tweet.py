import os
import glob
import pickle
import pandas as pd
import chardet
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.naive_bayes import MultinomialNB
from sklearn.multiclass import OneVsRestClassifier
from sklearn.naive_bayes import GaussianNB
import numpy as np
from sklearn.neural_network import MLPClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.ensemble import RandomForestClassifier
from sklearn.gaussian_process import GaussianProcessClassifier
from sklearn.gaussian_process.kernels import RBF
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier
from sklearn.discriminant_analysis import QuadraticDiscriminantAnalysis
from sklearn.neighbors import NearestNeighbors
from sklearn.neighbors.nearest_centroid import NearestCentroid

class topic_classifier():
    """
    ***parameter***
    - file_dir: File path of BBC training data
    - topics: tweet topic from one of these topics: 'business','entertainment','politics','sport' and 'tech'
    - classifier: Machine learning multi-class classifier from one of the following classifiers
         +'mulNB': Naive Bayes 
         +'svc': SVC
         +'dec_tree': Decision Tree
         +'rand_forest': Random Forest
         +'random_sample': Random Sample
         +'nearest_cent': Nearest centroid
         +'mlp': Multi-layer Perceptron
    """
    def __init__(self,file_dir,topics,classifier):
        self.file_dir=file_dir
        self.topics=topics
        self.classifier=None
        self.algorithm=classifier
        self.method=None



    #extracting training texts from different folders and dumping them into a dataframe
    def train_topics_gen(self):
        content=[]
        classes=[]
        for topic in self.topics:
            user_set_path = os.path.join(self.file_dir,topic)
            os.chdir(user_set_path)
            files=glob.glob("*.txt")
            for file in files:
                with open(file) as f:
                    content.append(f.read())
                    classes.append(topic)
        DF = pd.DataFrame({'class': classes,'content': content})
        return DF


    # training the classifier using the BBC training data
    def training(self):
        if self.algorithm=='mulNB':
            self.classifier = MultinomialNB()
        elif self.algorithm=='svc':
            self.classifier=OneVsRestClassifier(SVC())
        elif self.algorithm=='dec_tree':
            self.classifier=DecisionTreeClassifier()
        elif self.algorithm=='rand_forest':
            self.classifier=RandomForestClassifier()
        elif self.algorithm=='random_sample':
            self.classifier=RandomForestClassifier()
        elif self.algorithm=='nearest_cent':
            self.classifier=NearestCentroid()
        elif self.algorithm=='mlp':
            self.classifier=MLPClassifier()

        # BBC training dataset
        df=self.train_topics_gen()
        # vectorizing the contents of the data
        self.method = CountVectorizer()
        counts = self.method.fit_transform(df['content'].values)
        targets = df['class'].values
        self.classifier.fit(counts, targets)
        return self


if __name__ == "__main__":
    #read the training data
    __file__ = 'C:\\Users\\user\Desktop\\cyber hackathon - Copy\\news_data'
    cur_dir = os.path.dirname(__file__)
    cur_dir=os.path.join(cur_dir,'news_data')
    topics=['business','entertainment','politics','sport','tech']
    topic_model=topic_classifier(cur_dir,topics,'mulNB')
    topic_model.training()
    filename = 'finalized_model.sav'
    pickle.dump(topic_model, open(filename, 'wb'))
    #tweets data
  
    with open('C:\\Users\\user\Desktop\\cyber hackathon - Copy\\neg_tweet_updated.csv', 'rb') as f:
      result = chardet.detect(f.read()) 
      db = pd.read_csv('C:\\Users\\user\Desktop\\cyber hackathon - Copy\\neg_tweet_updated.csv', skiprows=1,
                     names=[ 'text', 'urls'],encoding=result['encoding'])

    # predict the topic classs for each tweet in tweets data
    loaded_model = pickle.load(open(filename, 'rb'))
    tweet_counts = loaded_model.method.transform(db.text)
    predictions = loaded_model.classifier.predict(tweet_counts)
    db['topic']=predictions
