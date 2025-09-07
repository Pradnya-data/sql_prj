CREATE DATABASE MARKETING;

USE MARKETING;

select * from marketing;



/*
Key Questions to Answer
1.	Which campaign channels and types perform best in terms of conversion?
2.	Do higher AdSpend or TimeOnSite correlate with better conversion rates?
3.	Which demographics (age, gender, income) respond better to campaigns?
4.	Can we segment users into groups based on engagement and spending?
5.	What are the key predictors of conversion?
*/


-- get distinct campaign channels

select distinct(CampaignChannel) from marketing; -- ppc pay per click

select distinct(AdvertisingPlatform) from marketing;


-- Inspect Table Structure

select top 10 * from marketing;

-- drop columns like advertising platform, tool

ALTER TABLE Marketing
DROP COLUMN AdvertisingPlatform, AdvertisingTool;

-- Check for NULLs

select * from marketing
where age is null;

-- check all numerical columns for null value

SELECT
  SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Null_Age,
  SUM(CASE WHEN Income IS NULL THEN 1 ELSE 0 END) AS Null_Income,
  SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Null_Gender,
  SUM(CASE WHEN AdSpend IS NULL THEN 1 ELSE 0 END) AS Null_AdSpend
FROM Marketing;

--  Create Age Groups

ALTER TABLE Marketing
ADD AgeGroup VARCHAR(20);

UPDATE Marketing
SET AgeGroup = CASE 
    WHEN Age < 25 THEN '18-24'
    WHEN Age BETWEEN 25 AND 34 THEN '25-34'
    WHEN Age BETWEEN 35 AND 44 THEN '35-44'
    WHEN Age BETWEEN 45 AND 54 THEN '45-54'
    WHEN Age BETWEEN 55 AND 64 THEN '55-64'
    ELSE '65+'
END;

-- Which campaign channels and types perform best in terms of conversion?

-- total converted

select sum( CAST(Conversion AS INT)) from marketing; 

-- conversion rate

select sum( CAST(Conversion AS INT)) *100 / count(*) from marketing; 


-- best campaignchannel

select CampaignChannel,
sum( CAST(Conversion AS INT)) *100 / count(*)  as coversionrate
from marketing
group by CampaignChannel;

-- best campaigntype

select CampaignChannel,
cast((sum( CAST(Conversion AS INT)) * 100.0) / count(*) as decimal (5,2))  as conversionrate
from marketing
group by CampaignChannel
order by ConversionRate desc;




-- campaign types

select CampaignType,
count(*) as total,
sum( CAST(Conversion AS INT)) as totalconverted,
cast((sum( CAST(Conversion AS INT)) * 100.0) / count(*) as decimal (5,2))  as conversionrate
from marketing
group by CampaignType
order by ConversionRate desc;

/* Best campaign channel is referral with conversion rate of 88.31% and 
best campaign type is conversion with conversionrate */

-- Conversion rate on the basis of demographics age group and gender

select AgeGroup,gender,
count(*) as total,
sum( CAST(Conversion AS INT)) as totalconverted,
cast((sum( CAST(Conversion AS INT)) * 100.0) / count(*) as decimal (5,2))  as conversionrate
from marketing
group by agegroup,gender
order by ConversionRate desc;


-- Effect of AdSpend on Conversion

select avg(adspend) as averageadspend, min(adspend) as minspend, max(adspend) as maxspend
from marketing;

-- create spend category

alter table marketing
add SpendGroup varchar(100);


select
case
when adspend <2000 then 'LowSpend'
when adspend >=2000 and adspend<6000 then 'Mediumspend'
else 'Highspend'
end as spendgroup
from marketing;


-- update this result in adspend group

update marketing
set spendGroup =
case
when adspend <2000 then 'LowSpend'
when adspend >=2000 and adspend<6000 then 'Mediumspend'
else 'Highspend'
end;

select top 10 * from marketing;

-- effect of adspend on conversion rate

select spendgroup,
count(*) as total,
sum( CAST(Conversion AS INT)) as totalconverted,
cast((sum( CAST(Conversion AS INT)) * 100.0) / count(*) as decimal (5,2))  as conversionrate
from marketing
group by spendgroup
order by ConversionRate desc;


-- check engagement metrics and conversion
SELECT 
  AVG(PagesPerVisit) AS AvgPages,
  AVG(TimeOnSite) AS AvgTime,
  AVG(CAST(Conversion AS INT) * 100.0) / (count(*) ) as avgconversionrate
FROM Marketing;