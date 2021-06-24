use project

select * from covid_death

select location,date,total_cases,new_cases,total_deaths,population
from covid_death
order by 1,2;

-- total cases vs total deaths
-- Shows likelihood of dying if you get infected by covid in india.
select location,date,total_cases,total_deaths,(100*total_deaths/total_cases) as death_percent
from covid_death
where location = 'India'
order by 1,2;

-- Total Cases vs Population
-- shows what percentage of populatiuon got covid
select location,date,population,total_cases,(100*total_cases/population) as infection_percent
from covid_death
where location = 'India'
order by 1,2;

-- Countries with highest infecftion rate compared to population.
select location,population,max(total_cases) highest_infection_count,
max((total_cases/population))*100 as infection_percent_by_population
from covid_death
group by 1,2
order by infection_percent_by_population desc;


-- Showing countries with highest death count per population
select location,max(cast(Total_deaths as unsigned)) as total_death_count
from covid_death
group by 1
order by total_death_count desc;

# This shows that as of 22 june 2021, India has the highest death count in the world.



-- showing the continents with highest death count per population

select continent,max(cast(Total_deaths as signed)) as total_death_count
from covid_death
group by 1
order by total_death_count desc;

# above analysis shows that most number of deaths as on 22 june 2021 is in asia which is almost equal or just less than
# total deaths in north america,south america and africa.


-- Global Numbers

select * from covid_death;

select date, sum(new_cases)
from covid_death
group by date
order by 1,2;

# Above query shows how the new cases across the world varied each day and can be deduced that april 2020, the number of new cases
# were comparitively on lowerd side but gradually increased from there afterwards.

desc covid_death
-- how the death rate varied as per dates
select date, sum(new_cases) total_cases,sum(cast(new_deaths as signed)) total_deaths, 
100*sum(cast(new_deaths as signed))/sum(new_cases) as death_percent
from covid_death
group by date
order by 1,2,3;

-- death rate overall till now.

select sum(new_cases) total_cases,sum(cast(new_deaths as signed)) total_deaths, 
100*sum(cast(new_deaths as signed))/sum(new_cases) as death_percent
from covid_death;




-- total population vs vaccination

select d.continent,D.LOCATION,D.DATE,D.POPULATION,v.new_vaccinations,
sum(cast(v.new_vaccinations as signed)) over (Partition by d.location order by d.location) as rolling_people_vaccinated
from covid_death d
join covid_vaccination v
on d.location = v.location
and d.date = v.date;


-- percent of population vaccinated till 22 june 2021 in each country
with popu_vac as
( continent,location,date,population,new_vaccinations,rolling_people_vaccinated)
as
(
select d.continent,D.LOCATION,D.DATE,D.POPULATION,v.new_vaccinations,
sum(cast(v.new_vaccinations as signed)) over (Partition by d.location order by d.location) as rolling_people_vaccinated
from covid_death d
join covid_vaccination v
on d.location = v.location
and d.date = v.date;

)
select * , (rolling_people_vaccinated/population)*100
from popu_vac;





-- create view for future visualizations

create view  percentpopulationvaccinated as

select d.continent,D.LOCATION,D.DATE,D.POPULATION,v.new_vaccinations,
sum(cast(v.new_vaccinations as signed)) over (Partition by d.location order by d.location) as rolling_people_vaccinated
from covid_death d
join covid_vaccination v
on d.location = v.location
and d.date = v.date;

select * from percentpopulationvaccinated;

