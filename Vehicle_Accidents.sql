Create database Accidents
use Accidents

select * from [dbo].[accident]

select * from [dbo].[vehicles]

--Question 1: How many accidents have occured in Urban Areas versus Rural Areas?
select [Area], count([AccidentIndex]) as total_accidents from [dbo].[accident]
group by [Area]

--Question 2: Which day of the week has highest number of accidents?
select [Day],count([AccidentIndex]) as no_of_accidents from [dbo].[accident]
group by [Day]
order by 2 desc

--Question 3: What us the average age of the vehicles involed in accients based on their type.
select [VehicleType],count([AccidentIndex]) as Total_accidents, AVG([AgeVehicle]) as avg_year
from [dbo].[vehicles]
where [AgeVehicle] is not null
group by [VehicleType]
order by 2 desc

--Question 4: Can we identify any trend in accidents based on the age of vehicle involved?
select Age_group,count([AccidentIndex]) as total_accidents, 
       avg([AgeVehicle]) as average_year


from(
  select [AccidentIndex],[AgeVehicle], 
  case when [AgeVehicle] between 0 and 5 then 'New'
       when [AgeVehicle] between 6 and 10 then 'Regular'
	   else 'Old'
	   end as Age_group from [dbo].[vehicles]
) as subquery
where [AgeVehicle]  is not null
group by Age_group
order by 2 desc.

-- Question 5:Are there any specific weather conditions that contribute to the severe accidents?

declare @Severity varchar(100)
set @Severity ='Serious'
select count([Severity]) as total_accidents,[WeatherConditions]
from [dbo].[accident]
where [Severity] = @Severity
group by [WeatherConditions]
order by 1  desc

--Question 6: Do accidents often involve impacts on the left hand side of the vehicles?
select count(*) as no_of_accidents,[LeftHand] from [dbo].[vehicles] 
where [LeftHand] != 'Data missing or out of range'
group by [LeftHand]
order by 1 desc

--Question 6: Are there any  relationships between journey purposes and severity of the accidents?

select v.[JourneyPurpose], 
       count(a.[Severity]) as Total_accidents,
       case 
	       when count(a.[Severity]) between 0 and 1000 then 'Low'
		   when count(a.[Severity]) between 1001 and 3000 then 'Moderate'
		   else 'High' end as level

from [dbo].[accident] a
join [dbo].[vehicles] v on a.AccidentIndex=v.AccidentIndex
group by v.[JourneyPurpose]
order by 2 desc

--Question 8: Calculate the average age of vehicles involved in accidents, considering day light and point of impact.

declare @Light varchar(50)
declare @Impact varchar(50)
set @Light = 'Daylight'
set @Impact= 'Nearside'

select avg(v.AgeVehicle) as average_year,a.[LightConditions],v.[PointImpact]
from [dbo].[accident] a
join [dbo].[vehicles] v on a.AccidentIndex=v.AccidentIndex
group by a.[LightConditions],v.[PointImpact]
having  a.[LightConditions] = @Light and v.[PointImpact] = @Impact
order by 1 desc