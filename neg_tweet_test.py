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

cur_dir = os.path.dirname(__file__)
db_dir=os.path.join(cur_dir, 'neg_tweet_updated.csv')
with open('C:\\Users\\user\Desktop\\cyber hackathon\\news_data\\neg_tweet_updated.csv', 'rb') as f:
     result = chardet.detect(f.read()) 
     db = pd.read_csv(db_dir, skiprows=1,
                     names=[ 'text', 'urls'],encoding=result['encoding'])

    # predict the topic classs for each tweet in tweets data
tweet_counts = topic_model.method.transform(db.text)
predictions = topic_model.classifier.predict(tweet_counts)
db['topic']=predictions
