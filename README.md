# City of Los Angeles 311 Call Center Data Analysis Project

---

> Introduction

DSO 545 Final Project - Fall 2016  
Group members: Yu Dong, Sheng Ming, Xiaowen Zhang, Chun Yang, Xi Jiang  
MS Busienss Analytics, Marshall School of Business  
University of Southern California  

The City of Los Angeles asked our team to develop a report that would reveal the underlying patterns of the 311 Call Center data and requesting data and make improvement suggestions to City of Los Angeles using our insights. 

The goal of our project is to provide insightful geographic, demographic and time indicators for the City of L.A.. This analysis is also intended to identify potential challenges and provide important context for policy and resources allocation decisions that will help shape the future of the City. 

---

> Data Sources

1. 311 Call Center Tracking data  
[LA 311 Call Center Tracking Dataset](https://data.lacity.org/dataset/311-Call-Center-Tracking-Data/ukiu-8trj/data)  
Data from 2011/1/1 - 2015/5/31  
Contains information about different types of service requests from calls  

2. 311 Service Request data  
[LA 311 Service Request Dataset](https://data.lacity.org/A-Well-Run-City/MyLA311-Service-Request-Data-2016/ndkd-k878/data)  
Data from 2015/5/8-2016/11/17  
Contains information about different types of service requests made from different channels  

3. 2014 Census data  
[2014 Census Data](https://censusreporter.org)  
Contains US population, unemployment rate, median age and median household income information according to zip code in LA  

4. Council District Summary Statistics  
[2015 LA Council District Report](http://www.lachamber.com/clientuploads/policy_issues/15_BeaconReport_Web.pdf)  
Contains demographic information of residents living in all 15 council Districts in L.A.  

5. Zip Code and Location data  
L.A. area zip codes and their coordinates (longitude and latitude) accordingly  

---

> Project on Github

1. Basic Data Processing Codes
2. Analysis on the dataset
  * Geographical Analysis
  * Time-based Analysis
  * Efficiency Analysis
  * Social Analysis
3. Interactive Web Application based on R Shiny

---

> Instructions on using the Shiny App

1. Create a Shiny project and keep all the files in the **Shiny_Final** folder in the project directory
2. Make sure all the R packages in the **all_library_data_function.R** file are downloaded
3. Load all the required packages, datasets and functions by `source('all_library_data_function.R')`
4. Run the Shiny App using **ui.R** and **server.R**
