# 📱 Social Media Analytics – Taylor Swift Case Study

## 📊 Project Overview

This project performs large-scale social media analytics to study audience engagement, sentiment, and network behaviour surrounding Taylor Swift. Data was collected from multiple platforms including YouTube, Reddit, and Spotify to analyse fan interactions, discussion trends, and artist influence.

The project demonstrates advanced data analytics techniques including social network analysis, text mining, sentiment analysis, and machine learning using R.

## 🎯 Objectives

- Analyse social media engagement and fan behaviour  
- Identify influential users and interaction networks  
- Perform sentiment analysis on user-generated content  
- Discover key discussion topics using topic modelling  
- Visualise insights through dashboards and charts  

## 🔍 Data Collection

- Collected data from:
  - YouTube (video comments and interactions)
  - Reddit (discussion threads and comments)
  - Spotify (artist and track data)

- Dataset includes **3,444 data points** across platforms  
- Focused on Taylor Swift content across multiple time periods :contentReference[oaicite:1]{index=1}  

## 🧹 Data Processing

- Cleaned and structured text data  
- Removed noise, stopwords, and irrelevant content  
- Converted text into analyzable formats (Term-Document Matrix)  

## 🧠 Analysis Techniques

### 🔗 Social Network Analysis
- Built actor networks from YouTube data  
- Applied **PageRank** to identify influential users  
- Analysed centrality measures (degree, betweenness, closeness)

### 👥 Community Detection
- Applied:
  - Louvain method (16 communities, modularity 0.76)
  - Girvan–Newman method (18 communities)
- Identified strong fan clusters and interaction groups :contentReference[oaicite:2]{index=2}  

### 📊 Text Mining & NLP
- Created **Term-Document Matrix (TDM)**  
- Identified top frequent words (e.g., *taylor, love, tour, song*)  
- Built **semantic bigram networks** and applied PageRank  

### 💬 Sentiment Analysis
- Used Bing lexicon for classification  
- Results:
  - **70.8% positive sentiment**
  - **29.2% negative sentiment** 

👉 Indicates strong positive fan engagement

### 🤖 Machine Learning
- Built a **Decision Tree model**
- Predicted whether comments are related to Taylor Swift  
- Used features:
  - Text length
  - Word count
  - Comment score  

### 🧠 Topic Modelling (LDA)
Identified 3 key topics:

1. **Music & Career** – albums, songs, tours  
2. **Opinions & Reactions** – fan thoughts and feedback  
3. **Love & Emotion** – emotional connection with music  

## 📈 Data Visualisation

### 📊 Power BI Dashboards

#### Dashboard 1 – YouTube Engagement
- Compared likes, replies, and engagement across videos  
- Found highest engagement for “Anti-Hero”  

#### Dashboard 2 – Reddit Analysis
- Word cloud showing common discussion themes  
- Average comment score analysis by subreddit   

## 🛠️ Tools & Technologies

- R  
- vosonSML, igraph  
- Text mining (tm, tidytext)  
- APIs (YouTube, Reddit, Spotify)  
- Power BI  

## 📌 Key Outcomes

- Identified influential users using network analysis  
- Discovered strong fan communities and engagement clusters  
- Analysed sentiment showing highly positive audience response  
- Extracted key discussion topics using NLP techniques  
- Demonstrated end-to-end social media analytics workflow  

## 🚀 Key Learning

This project enhanced my skills in:
- Social Network Analysis  
- Natural Language Processing (NLP)  
- Machine Learning  
- Data Visualisation  
- API-based data collection  

## 📁 Files Included

- R script for analysis  
- Assignment report (PDF)  
- Visualisations and outputs  
