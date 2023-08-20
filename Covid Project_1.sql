Select *
from CovidDeaths
where continent is not null
Order by 3,4

--Select *
--From Covidvaccinations 
--order by 3,4

Select location,date ,total_cases, new_cases , total_deaths,population
from CovidDeaths
order by 1,2

--Looking at total cases vs total deaths

Select location,date ,total_cases, total_deaths,  (Total_deaths/total_cases)*100 as deathpercen
from CovidDeaths
where location like '%pakistan%'
order by 1,2

--Total cases vs Population
Select location,date ,Population,total_cases,(Total_cases/population)*100 as populationperc
from CovidDeaths
where location = 'Pakistan' 
order by 1,2

--Looking at countries with highest infection rates  compared to population
Select location, Population, Max(Total_cases) as highestinfectioncount, Max((total_cases / Population)) *100 as Popinfec
From coviddeaths
--where location = 'Pakistan'
group by location , Population
order by highestinfectioncount desc

--Countries with highest death counts
Select Location, Date, total_cases, total_deaths, population
From CovidDeaths
Order by 1,2

Select Location, Max(Cast (Total_deaths as int)) as totaldeaths
from CovidDeaths
where continent is not null
Group by location
Order by totaldeaths desc

--Lets break things by continent
Select continent, Max(Cast (Total_deaths as int)) as totaldeaths
from CovidDeaths
where continent is not null
Group by continent
Order by totaldeaths desc

--Showing continents with highest death count per population
Select continent, max(population) as Maxabadi, Max(cast(Total_deaths as int) ) as totaldeaths 
from CovidDeaths
where continent is not null
Group by continent
Order by totaldeaths desc

--Global numnbers
Select SUM (new_cases) as totalcases, Sum (cast(New_deaths as int)) totaldeaths, Sum (cast(New_deaths as int))/ Sum(new_cases) *100 as deathpercentage
--, total_deaths,  (Total_deaths/total_cases)*100 as deathpercen
from CovidDeaths
--where location like '%states%' 
where continent is not null 
--group by date
order by 1,2


--Looking Total Population vs Vaccination
with popvsvac (continent , location, date, population,new_vaccinations,rollingpplvac)
As 
(Select dea.continent,dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM (cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as rollingpplvac
From CovidDeaths as dea
Join CovidVaccinations as vac
	on dea.location= vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order by 2,3
)

Select *, (rollingpplvac/population) *100 
From Popvsvac


--temp tables
DROP Table if exists #PPV
Create table #PPV

(
Continent nvarchar (255), 
location nvarchar (255) ,
date datetime ,
population numeric, 
new_vaccinations numeric,
rollingpplvac numeric)
insert into #PPV
Select dea.continent,dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM (cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as rollingpplvac
From CovidDeaths as dea
Join CovidVaccinations as vac
	on dea.location= vac.location 
	and dea.date = vac.date
--where dea.continent is not null
--Order by 2,3 
Select *, (rollingpplvac/population) *100 
From #PPV

--Creating view data for later view

Create view PPV as 
Select dea.continent,dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM (cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as rollingpplvac
From CovidDeaths as dea
Join CovidVaccinations as vac
	on dea.location= vac.location 
	and dea.date = vac.date
where dea.continent is not null
--Order by 2,3 


Select *
From PPV