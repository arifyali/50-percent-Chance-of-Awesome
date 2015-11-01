discovering the real value of a politician
====================================================
ANLY-501 & COSC-587, Project Assignment 1
October 16, 2015

**Group Members:**
	Tim Ahn
	Arif Ali
	John Hotchkiss
	Joshua Kaplan
	Hongkai Wu


	The power of a U.S. congressman lies in the influence they wield to shape the identity of the country. In many cases, a candidate’s ability to raise funds for a campaign is the deciding factor in getting elected to Congress. This critical fact creates an environment of careful platform planning and strategic alliances, quite often with specific industries. Data representing the contributions every candidate has received and final election figures are publicly available through the Federal Election Commission (FEC). Also available, through various public channels, are daily stock quotes and financial metrics for all publicly traded companies. But what is unknown within these data exists in the wake of the final votes and beyond. The ambiguity of the actual impact of the moneys raised to the contributing industries perpetuates the current process as the status quo. Are these companies’ bottom lines truly benefitting from the financial support they provide to candidates or is the idea of buying influence simply recognizable hope without an actual realized gain? Manufacturing new data from the existing, seemingly unrelated, election and financial resources to provide a measurable outcome of the impact that political contributions have on an industry will finally allow us the opportunity to assess their returns.
 
	The data being collected for this study will begin with a breakdown of political contributions by industry for each general election candidate.  They will include the top industries with the highest amount of contributions for each candidate. This allows us to determine the source of contributions and to whom they are going. Also being collected are recent congressional election results for each Representative district and Senate seat. These data will include candidate names, state and district, party affiliations, votes, and percentage of total votes collected. This information can be used to identify clusters related to geographic location, the effectiveness of political contributions, and industry concentration within the population, among other correlations. Finally, we will collect historical financial data of relevant industries (those that financed politicians, and can therefore be connected to them) within a major stock market index, as well as industry-specific indices to provide a fair representation of an industry’s overall performance. Included are daily prices for open, close, high, low, total volume, and adjusted close.

	The goal of this study is to uncover possible relationships between political contributions by industries to specific parties and candidates and the successive impact to the market as a whole and to itself. The expectation is to see a significant correlation between the industry-wide contributions to a candidate and that particular candidate’s likelihood to win an election. Furthermore, we expect to observe a substantial benefit when an industry supports an elected candidate. It may also be possible to explore the magnitude of correlation between industry spending and actual vote counts within a district and/or state. Another intriguing consideration is industry contributions compared to the market value of the entire industry and comparisons of this measurement between industries.





	The following provides an overview of each data source in use for our study and any related data issues that have been encountered.

Political Contributions
-----------------------
**Description**
	We will collect data on contributions to congressional candidates from the 2004-2014 general elections, separated by industry. Data for 2012 and 2014, for election winners, will be obtained using Opensecrets’ get Legislators and candIndustry APIs.  Data for 2004-2014 election winners and losers will be obtained by scraping Opensecrets.org. Opensecrets gets this data from the FEC.  Both the API and scraping will be used since the API provides more attributes per candidate-year combination data than can be scraped.

**Issues**
*	Missing data on some candidates from 2012-2014 (6 total) in the API data due to a glitch in Opensecrets’ data collection – Opensecrets has been notified of the glitch but fixes have not yet been made.
*	Some of the names in the scraped data did not extract cleanly – names with accents present an encoding problem when brought into Python. This may cause issues when we merge our data.
*	The scraped data includes all industries from which a candidate received at least $200 in a single contribution, while the data from the API only includes the top 10 industries that donated to the candidate, measured by aggregate contributions (ties at 10th contributor retained). 
*	The data from the API provides a breakdown of industry contributions into PAC and individual contributions while the scraped data does not.

**Attributes for FundingCongress.csv**
*	BLANK - first column, observation number created by Pandas
*	State - State abbreviation where the candidate ran.
*	District - District or Seat the candidate ran for. 
*	Year - Year in which the candidate ran.
*	Candidate - Name (First Last) of the running candidate.
*	Industry - Industry that contributed to the Candidate
*	Amount - Amount of money donated by industry in the record.
*	candtotal* - total contributions to the running candidate 
*	industrypercent* - the contribution of the industry to the candidate as a percentage of total contributions to the candidate.

Election Results
-----------------------
**Description**
	Election outcomes (vote counts and percentages) for every House of Representatives and Senate race from 2004-2014. Data for 2004-2012 will be downloaded from FEC.gov as csv files, and 2014 data will be scraped from NYtimes.com.

**Issues**
	FEC 2004-2012 Election data (retrieved from http://www.fec.gov/pubrec/electionresults.shtml): 
*	FEC does not have 2014 election data available on their website, so we will use a separate source (NY Times 2014 election data). 
*	No vote count is available for unopposed elections. 
*	Data will have to be heavily manipulated in order to stack with the NY Times dataset and subsequently merged onto the main data set.

**Attributes for all FEC Tables**
*	STATE, STATE ABBREVIATION, DISTRICT, FEC ID, INCUMBENT INDICATOR, FIRST NAME, LAST NAME, LAST NAME, FIRST, TOTAL VOTES, PARTY, PRIMARY, PRIMARY %, RUNOFF, RUNOFF %, GENERAL, GENERAL %, GE RUNOFF, GE RUNOFF %
	Note: some changes based on year, but these were constant.


**NY Times 2014 election data (retrieved from http://elections.nytimes.com/2014/):**
*	No data are available for uncontested elections – while the candidate may have received nearly 100% of the vote, it would be useful to know the exact percentage as well as the number of votes they received. 
*	Some of the names in the scraped data did not extract cleanly – names with accents present an encoding problem when brought into Python. 
*	Data will have to be reshaped prior to incorporation with the primary dataset.  Rows in this dataset contain information by state-year-district-race (multiple candidates per row) rather than state-year-district-candidate.

**Attributes for NYTimes2014elections.csv**
*	State - State in which candidate ran for election.
*	CongressionalMembership - All candidates were running for election to this position.
*	candidate# - Where # is 1:11, Name of running Candidate#
*	PartyAffiliation# - Where # is 1:11, Party affiliation of candidate# 
*	Votes# - Where # is 1:11, Number of votes in the general election received by candidate# 
*	VotePercent# - Where # is 1:11, Percentage of votes in the general election received by candidate#

Financial Market Data
-----------------------
**Description**
	We will collect daily stock market data for the S&P 500 and Dow Jones Industrial Average from 2004 to 2014 from Quandl.com. In addition, we will collect data on 5 sector-specific indices: the Nasdaq Banking Index, Nasdaq Industrial Index, Nasdaq Biotechnology Index, NYSE Amex Oil Index, and the PHLX Gold/Silver Index. S&P and DJIA data will be obtained using the API, while data for the sector-specific indices will be downloaded as csv files.

**Issues**
*	S&P 500: Missing data for Navient Corporation (ticker NAVI); the API does not work for this ticker, as the page for Navient apparently does not exist on Quandl.com. The rest of the data are available, and does not contain any noise.
*	Dow Jones: Same source as S&P 500, no noise or missing data

Sector Specific Indices
--------------------------
**Nasdaq Banking Index:** 
	No issues; download csv from 
	https://www.quandl.com/data/NASDAQOMX/BANK-NASDAQ-Bank-BANK
	The NASDAQ Bank Index contains securities of NASDAQ-listed companies classified according to the Industry Classification Benchmark as Banks. They include banks providing a broad range of financial services, including retail banking, loans and money transmissions. On February 5, 1971, the NASDAQ Bank Index began with a base of 100.00. (from Quandl)


**Nasdaq Industrial Index:** 
	No issues; download csv from 
	https://www.quandl.com/data/NASDAQOMX/INDS-NASDAQ-Industrial-INDS
	The NASDAQ Industrial Index contains securities of NASDAQ-listed companies not classified in one of the NASDAQ sector indexes. These include firms that are involved in oil and gas productions, oil equipment, services & distribution, chemicals, forestry and paper, industrial metals, mining, construction and materials, aerospace and defense, general industrials, electronic and electrical equipment, industrial engineering, support services, automobiles and parts, beverages, food producers, household goods, leisure goods, personal goods, tobacco, food and drug retailers, general retailers, media, gambling, hotels, recreational services, restaurants and bars, travel & tourism, electricity, gas distribution, water, and multi-utilities. On February 5, 1971, the NASDAQ Industrial Index began with a base of 100.00. (from Quandl)

**Nasdaq Biotechnology Index:** 
	No issues; download csv from
	https://www.quandl.com/data/NASDAQOMX/NBI-NASDAQ-Biotechnology-NBI
	The NASDAQ Biotechnology Index contains securities of NASDAQ-listed companies classified according to the Industry Classification Benchmark as either Biotechnology or Pharmaceuticals which also meet other eligibility criteria. The NASDAQ Biotechnology Index is calculated under a modified capitalization-weighted methodology. The Index began on November 1, 1993 at a base value of 200.00. (from Quandl)

**NYSE Amex Oil Index:**
	No issues; download csv from
	https://www.quandl.com/data/YAHOO/INDEX_XOI-NYSE-AMEX-Oil-Index
	The NYSE Arca Oil Index, previously AMEX Oil Index, ticker symbol XOI, is a price-weighted index of the leading companies involved in the exploration, production, and development of petroleum. It measures the performance of the oil industry through changes in the sum of the prices of component stocks. The index was developed with a base level of 125 as of August 27, 1984. (from Wikipedia)

**PHLX Gold/Silver Sector Index:**
	No issues; download csv from 
	https://www.quandl.com/data/YAHOO/INDEX_XAU-PHLX-Gold-Silver-Sector-Index
	The PHLX Gold/Silver Sector Index (XAU) is a capitalization-weighted index composed of companies involved in the gold or silver mining industry. The Index began on January 19, 1979 at a base value of 100.00; options commenced trading on December 19, 1983. (from https://indexes.nasdaqomx.com/Index/Overview/XAU)


Data Cleaning 
------------------
	In order to properly score the cleanliness of the data, we evaluate two categories of data issues. The first issue is potential outliers in the quantitative attributes within our data. The second is a verification of completeness and formatting.

	A confidence interval of 99% is used to determine outliers. This involves looking for any quantitative values that are greater than three standard deviations, in either direction, away from the mean of the attribute. The percentage of values outside this confidence interval is recorded for each attribute. Finally, the outlier percentages are averaged together across the data set to generate a final outlier score.

	The second component is slightly more involved and requires two subcomponents. The first subcomponent requires checking the percentage of missing values for a given attribute. Thus, the total number of blank values in the attributes are added up and then added to the second subcomponent. This subcomponent is designed specifically for the string attributes. The string attributes are important for merging; thus, basic formatting needs to be standard. For the Names in particular, we evaluate whether or not they have a proper case. To do this, we split up the strings by word and count the number of words, then compare the number of words to the number of upper case letters in the string. For all strings in an attribute that did not follow this rule, matches are summed up to make up the second subcomponent of the second component. 

	After creating the two sub-scores above, they are weighted equally and subtracted from 1, yielding one final percentage. After running through each of the data sets, we are able to make general conclusions about the data. For data originating from an API, the percentage is significantly higher than that of data originating from scraping or csv downloads. The worse scoring data set was scraped from the New York Times. This indicates a flaw in the scoring algorithm since in this file missing-ness might be totally fine on an attribute by attribute basis.  Also, due to the way it is scraped, some numeric attributes remained as strings. In order to compensate for the string form of those attributes, the data cleaning script performs light editing to convert them to a numeric format. There are two unexpected results of the cleaning algorithm. Since the FEC data is obtained in Excel Format and theoretically preprocessed-edit, it is expected to score significantly better than the scraped New York Times Data Set, however it surprisingly does much worse than the API obtained Data sets. This is likely due to the FEC focusing more on what appears to be a human-readable processing than a machine-readable processing.  The second surprise is that, although the NY Times and some of the Open Secrets data are both scraped, the open secrets data has a much higher score.  This is probably due to the difference in formatting, where the NY Times file is considered a “wide” file and the Open Secrets data a “long” file.

	As briefly discussed above, a possible drawback to the cleaning method we employed is that the program is that it is blind to whether or not missing values are errors for a particular attribute. It could be in place of a zero, meaning there was no actual information gained. The proper case-base component could also be fooled by the data.  Some common words, such as ‘for’, generally are not required to follow proper case, but will still be flagged by the program as errors.   Luckily, this is not a problem with the names we will use to merge, which is our primary concern.  However, that is not to say that the names do not trip up proper case.  The name Bill O’Reilly would be flagged as unclean data because the name is two words, yet there are three upper case letters. Fortunately, the percentage of names impacted by this issue is low, therefore we will be able to verify merges for these cases with relative ease.


Added Features
----------------
Four additional attributes are created using the S&P 500 and Dow Jones Industrial Average historical financial data:

*	Daily Open/Close Price Change – The difference between the closing price and the opening price of a stock from the same day.
*	Daily Open/Close Percent Change – The Daily Open/Close Price Change divided by the opening stock price.
*	Opening Market Capitalization – The total market value of the outstanding shares at market opening, calculated by multiplying the volume by the opening stock price.
*	Closing Market Capitalization – The total market value of the outstanding shares at close of market, calculated by multiplying the volume by the closing stock price.

Two additional attributes are created using the Opensecrets.org data:

*	Total Contributions (variable name: candtotal) – The total contributions a candidate received in each election cycle, from all industries. This was created by summing the contributions from every industry in each election cycle.
*	Contributions by industry percentage (variable name: industrypercent) – The percentage of a candidate’s total contributions in each election cycle that came from each industry. This was created by dividing contributions from each industry in each election cycle by total contributions for that election cycle.
