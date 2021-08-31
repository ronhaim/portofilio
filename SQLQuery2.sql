-- how much got covid
select Location, date, total_cases, population, (total_cases/population)*100 as InfectedPrecentage
from PortfolioProjectCovid19.dbo.Deaths
order by 1,2
-- how much died
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPrecentage
from PortfolioProjectCovid19.dbo.Deaths
where location like '%israel%'
order by 1,2
--max infaction rate vs population each country
select Location, population,MAX(total_cases) as MaxInfactionRate ,max((total_cases/population))*100 as MaxIfectionPrecentage
from PortfolioProjectCovid19.dbo.Deaths
group by location, population
order by MaxIfectionPrecentage desc
--higest death count per population each country
select Location, MAX(cast(total_deaths as int)) as TotalDeaths 
from PortfolioProjectCovid19.dbo.Deaths
where continent is not null
group by Location
order by TotalDeaths desc
--higest death count per population each continent
select continent, MAX(cast(total_deaths as int)) as TotalDeaths 
from PortfolioProjectCovid19.dbo.Deaths
where continent is not null
group by continent
order by TotalDeaths desc
-- how much died each day all over the world
select date, SUM(new_cases) as newCases, SUM(cast(new_deaths as int)) as newDeaths,
		(SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPrecentage
from PortfolioProjectCovid19.dbo.Deaths
where continent is not null
group by date
order by 1,2


-- total population vs vaccinations
with popVSvac ( continent, location, date, population, new_vaccinations, RollingTotalVaccinations)
as (
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
		SUM(cast(v.new_vaccinations as int)) over (partition by d.location order by d.date) as RollingTotalVaccinations
from PortfolioProjectCovid19.dbo.Deaths d
join PortfolioProjectCovid19.dbo.Vaccinations v
on d.location = v.location and d.date = v.date
where d.continent is not null
)
select * , (RollingTotalVaccinations/population)*100 as PrecentageOfRollingTotalVaccinations
from popVSvac
order by 2,3