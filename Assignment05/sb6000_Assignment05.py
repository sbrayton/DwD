# -- Generated: 2017-06-20 
# --  Project: DwD Assignment 05 Post Module Part Python
# -- Author: Shameka Brayton


import requests
import json
from watson_developer_cloud import NaturalLanguageUnderstandingV1
import watson_developer_cloud.natural_language_understanding.features.v1 \
  as Features


# Part 1: Use a Web API to get URLs for news articles
# Go to https://newsapi.org and create an account and get a key
# Write a function getNews(source) that accepts the name of a sourse, queries the NewsAPI, and returns back a list of URLs with the news stories that appear in that source. For example, the outcome of the command 

def getNews(source):

    import requests
    
    myID='e063887285d742c1ad493c0a583a7888'
    url1='https://newsapi.org/v1/articles?source='
    url2='&sortBy=latest&apiKey='
    
    url = url1 + source + url2 + myID
    
    resp = requests.get(url)
    data= resp.json()
    
    newsArtticles = data['articles']
    articleUrl = [article['url']for article in newsArtticles]
    
    return articleUrl
    
getNews ('ars-technica')   

# Part 2 ################   Gx5d9fhaBW_zPj7-WRjqcJyGO4u1Gyf4c1zx61lH6lpu   ##################################################

#   {
#   "url": "https://gateway.watsonplatform.net/natural-language-understanding/api",
#   "username": "6bf093e3-0311-4f4c-aac1-d089110afabb",
#   "password": "fYisqCfAx8B5"
# }
def extractEntities(url):
    endpoint = "https://gateway.watsonplatform.net/natural-language-understanding/api/v1/analyze"

    natural_language_understanding = NaturalLanguageUnderstandingV1(
      username="6bf093e3-0311-4f4c-aac1-d089110afabb",
      password="fYisqCfAx8B5",
      version="2017-02-27")


    response = natural_language_understanding.analyze(
      text=url,
      features=[
        Features.Entities(
          emotion=True,
          sentiment=True,
          limit=2
        ),
        Features.Keywords(
          emotion=True,
          sentiment=True,
          limit=2
        )
      ]
    )
    return json.dumps(response, indent=2)


url = "IBM is an American multinational technology company headquartered \
    in Armonk, New York, United States, with operations in over 170 \
    countries."
# print(extractEntities(url))




def getSentiment(url):
    endpoint = "https://gateway.watsonplatform.net/natural-language-understanding/api/v1/analyze"

    # You can register and get your own credentials
    # The ones below have a quota of 1000 calls per day 
    # and can run out quickly if multiple people use these
    username="6bf093e3-0311-4f4c-aac1-d089110afabb"
    password="fYisqCfAx8B5"
    version="2017-02-27"

    endpoint_watson = "https://gateway.watsonplatform.net/natural-language-understanding/api/v1/analyze"
    params = {
        'version': '2017-02-27',
    }
    headers = { 
        'Content-Type': 'application/json',
    }
    watson_options = {
      "url": url_to_analyze,
      "features": {
        "entities": {
          "sentiment": True,
          "relevance": True,
          "source":True,
          "limit": 3
        }
      }
    }
    username = "802a033d-ff91-4b02-a6c4-a40703ac1b16"
    password = "TBWFrRx6xwmc"

    resp = requests.post(endpoint_watson, data=json.dumps(watson_options), 
                         headers=headers, params=params, auth=(username, password) )
    return resp.json()


url_to_analyze = 'http://www.politico.com/story/2017/05/23/infrastructure-transportation-trump-budget-238741'

data = getSentiment(url_to_analyze)
print(data)

# f = open('/Users/shamekabrayton/Documents/NYU/01_DwD/PostModule/Assignment05/out.json', 'w')
# f.write("testing")
# f.close()

with open('/Users/shamekabrayton/Documents/NYU/01_DwD/PostModule/Assignment05/out.json', 'w') as fp:
    json.dump(data, fp)

