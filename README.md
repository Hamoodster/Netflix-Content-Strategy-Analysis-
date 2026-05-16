
Executive Summary: Netflix Content Strategy Analysis

Business Research Question: What types of content should Netflix invest in to maximize audience reach, and how has their content strategy shifted over time?

Project Overview: Trends in content strategy were explored using a data set comprising 8,807 titles available on Netflix. The PostgreSQL database was selected due to its excellent compatibility with star schemas and SQL analytical operations, which enabled the creation of a star schema database model comprising four-dimension tables and one fact table. R Studio software utilized tidyverse data mining techniques to clean the data and extract insights from five main analyses. Tableau software was selected due to its professional business intelligence and data visualization capabilities. 

Data Warehouse Design: Design and implementation of Star Schema in PostgreSQL took place. The Staging table consumed the raw CSV data that was later cleansed and transferred to four Dimension tables (content type, ratings, country, and genre). There was also a single Fact table to which all data was added. To properly handle multi-valued country and genre attributes two bridge tables were added. This eliminated data loss during ETL. A dim_date dimension table was also added to support time hierarchy and enable drill-down analysis in Tableau.


Data Mining & Key Findings
Analysis of the Netflix dataset revealed the following insights:
•	Content Type: 69.6% of Netflix titles are Movies while 30.4% are TV Shows, indicating a strong preference toward film content.
•	Growth Over Time: Netflix experienced explosive content growth between 2016 and 2019, peaking in 2019 with 1,424 movies and 592 TV shows added. A slight decline in 2020-2021 may reflect COVID-19 production disruptions.
•	Top Genres: International Movies and Dramas are the most represented genres, suggesting Netflix targets a global audience with emotionally driven content.
•	Top Countries: The United States dominates content production with 3,690 titles, followed by India (1,046) and the United Kingdom (806).
•	Content Ratings: TV-MA is the most common rating with 3,207 titles, indicating Netflix primarily targets adult audiences.
•	Data Quality Note: A small number of records contained duration values in the rating field, highlighting the importance of data validation in ETL pipelines.
•	YoY Growth: Movies on Netflix increased by 463%, and TV shows grew 236% from 2016 to 2019, with Movies reaching its peak at 1,424 in 2019, and TV Shows at 595 in 2020.
•	Data quality update: The bridge table now includes information for all countries (9,961 entries) and genres (18,791 entries) related to each title, fixing the previous issue due to SPLIT_PART
•	Logistic Regression
o	To move beyond descriptive analysis, a logistic regression model was applied to predict whether a Netflix title is a Movie or TV Show based on three features: release year, content rating maturity, and country of origin (US vs non-US).
o	The model achieved 70.7% accuracy and revealed the following statistically significant findings: 
	Release Year (Odds Ratio: 0.902) — Each additional year slightly decreases the likelihood of a title being a Movie, suggesting Netflix has been proportionally adding more TV Shows over time.
	Mature Rating (Odds Ratio: 1.369) — Mature-rated titles (TV-MA, R, NC-17) are 37% more likely to be a Movie than non-mature content.
	US Origin (Odds Ratio: 1.138) — US-produced titles are 14% more likely to be a Movie than internationally produced content.

Tools & Methods / Tool	Purpose
PostgreSQL / PGAdmin4	- Star schema with bridge tables, dim_date, ETL pipeline
RStudio	Data - cleaning, mining, and statistical analysis
Tableau	- Interactive dashboard and data visualization


Business Recommendations
Based on the analysis, the following recommendations are made for Netflix's content strategy:
1.	Invest in International Content: International Movies & TV Shows are some of the most popular categories, demonstrating high demand internationally. Further collaborations with India, South Korea, and Europe-based production houses might help boost subscribers in these regions.
2.	Balance Movie vs TV Show Production: Although films take center stage at Netflix, television series play an important role in fostering long-term commitment. Higher production of original TV series can enhance user loyalty.
3.	Target Adult Audiences Strategically: Given the high popularity of TV-MA-rated content, Netflix must make sure that mature content continues to be an important consideration, alongside selective growth in family-friendly and kids content.
4.	Sustain Content Volume: Decreasing content additions in the year 2020-2021 indicates that content production is sensitive to disruptions. It would be beneficial for Netflix to accumulate more content reserves.

Conclusion: This study demonstrates how data warehousing and mining methodologies can transform raw data into actionable business intelligence. Through the design of a systematic data flow process and visualization, we were able to uncover important trends in the data regarding Netflix's content acquisition strategy. The schema was revised based on feedback to eliminate data loss through proper bridge table design and to enable time-based drill-down analysis through a dedicated date dimension.

Citations
Shivam Bansal. (2021). Netflix Movies and TV Shows [Dataset]. Kaggle. https://www.kaggle.com/datasets/shivamb/netflix-shows
