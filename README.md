<h1>Advanced Analytics for Organisational Impact</h1>
  <h3> Topics Covered</h3>
  <p>
    Data Wrangling, Data Visualisation with Python and R, Python for Advanced Analytics (scipy, statsmodels, and scikit-learn), R (tidyverse, dplyr, ggplot2), Linear Regression, Multiple Linear Regression, Logistic Regression, K-means Clustering.
 </p>

Grade: __82% (Distinction)__
<h2>Assignment Overview</h2> 
  <p>
The goal of this project was to explore the customer demographic and sales data of Turtle Games, an online games manufacturer and retailer with a global customer base, operating in North America and Europe. We were tasked to determine what could be done to improve the overall sales performance of Turtle Games, primarily through utilising customer trends. The initial set of business questions was devised below: 

- How customers accumulate loyalty points
- How groups within the customer base can be used to target specific market segments 
- How customer reviews can be used to inform marketing campaigns about the impact that each product has on sales
- How reliable the data is (normal distribution, skewness, or kurtosis)
- What is the relationship (if any) between North American, European, and global sales? 
  
Two datasets were used in this analysis and can be found in the repository (including the metadata file titled "metadata_metadata_turtle_games.txt"). 
1. turtle_reviews.csv – Details on customer gender, age, remuneration, spending score, loyalty points, education, language, platform, review and summary across products.
2. turtle_sales.csv – Details of video games sold globally, such as the rank, product, platform, genre, publisher, and their sales across North America, Europe, and worldwide.
  </p>

<h2>Analytical Approach</h2>
  <p>
The first half of the analysis on the turtle_reviews.csv data set was conducted in Python using Jupyter Notebook, while the second half was done on the turtle_sales.csv conducted in R and R Studio. The datasets imported in this analysis were all cleaned, sense checked for data types, missing values and duplicates. The metadata descriptive statistics were also explored, see the Jupyter Notebook and R files for more details. The various libraries used are seen at the beginning of each document such as in Python numpy, pandas, matplotlib, seaborn, scipy, statsmodels, and scikit-learn, and in R packages, such as tidyverse, dplyr, ggplot2, which are essential for data analysis, visualisation, and modelling.
  <p/>
    
<h4>Marketing Data</h4>
  <p>
Python was used to analyse the marketing dataset (turtle_reviews.csv) which contained quantitative and qualitative data gathered from 2000 customers, with the qualitative data comprising of individual game reviews and summaries. Three primary analyses were performed in Python: 

- __Simple and Multiple Linear Regression:__ To investigate how loyalty points are impacted by salary, age, and spending score.  
- __K-Means clustering:__ To devise how TG's customer base can be segmented for targetted marketing strategies.
- __Natural Language Processing:__ Sentiment Analysis (VADER & TextBlob) was used to analyse customer reviews to help identify product weaknesses and potential areas for improvement.
  </p>

<h4>Sales Data</h4>
  <p>
The sales data (turtle_sales.csv) on 352 different games sold across North America (NA), Europe (EU) and Global Sales was analysed using R in R Studio.  which contained quantitative and qualitative data gathered from 2000 customers, with the qualitative data comprising of individual game reviews and summaries. Three primary analyses were performed in R:

- __Exploratory Data Analysis:__ To investigate the distribution of sales data across different regions, which platforms sell the most games, and the impact that each product has on sales.   
- __Normality Testing:__ Assess the reliability and suitability of the data for Machine Learning Analysis. 
- __Regression Analysis:__ Determine relationship between NA, EU and Global Sales.
  </p>

<h2>Insights</h2> 
<h3>What Impact Loyalty Points?</h3> 



- A moderately strong positive correlation (0.67)is present between customer spending scores and loyalty points, indicating more loyal or frequent customers have higher spending scores. A similar relationship is present between salary and loyalty points, implying that higher-paid individuals tend to be more loyal customers. 
- 



## The working order of how this project was approached is shown below and corresponds to chapters seen in the Jupyter Notebook and R file.
### Jupyter Notebook:
1. Setting Up the GitHub Repository & Importing and Exploring Data. Apply linear regression techniques to determine how customers accumulate loyalty points
2. Make predictions with clustering. apply k-means clustering to determine how useful remuneration and spending scores are in providing data for analysis.
3. Analyse customer sentiments with reviews using natural language processing (NLP) to determine how social data (e.g. customer reviews) can be used to inform marketing campaigns.
### R
4. Visualise data to gather insights. Explore and prepare the data set for analysis on the impact of sales per product.
5. Clean, manipulate  and visualise the data. Perform exploratory data analysis (EDA) techniques to clean and manipulate the data so that you determine how reliable the data is (e.g. normal distribution, skewness, or kurtosis).
6. Making recommendations to the business. Apply regression techniques to determine any possible relationship(s) in sales between North America, Europe, and global sales


