--SELECT * FROM dbo.CovidDeaths$ 
--ORDER BY 3, 4

----SELECT * FROM dbo.CovidVaccinations$ 
----ORDER BY 3, 4

---- Select data that we are going to be using

--SELECT LOCATION, DATE, TOTAL_CASES, NEW_CASES, TOTAL_DEATHS, POPULATION
--FROM dbo.CovidDeaths$
--WHERE continent is not null
--ORDER BY 1, 2

--- Looking at Total Cases vs Total Deaths
--- Shows likelihood of dying if you contract covid in your country

--SELECT LOCATION, DATE, TOTAL_CASES, TOTAL_DEATHS, (TOTAL_DEATHS/TOTAL_CASES)*100 AS DEATH_PERCENTAGE
--FROM dbo.CovidDeaths$
--WHERE location = 'Brazil' and continent is not null
--ORDER BY 1, 2

--- Looking at Total Cases vs Population
--- Shows what percentage of population got Covid

--SELECT LOCATION, DATE, POPULATION, TOTAL_CASES, (total_cases/population)*100 AS CASES_PERCENTAGE
--FROM dbo.CovidDeaths$
--WHERE location = 'Brazil' and continent is not null
--ORDER BY 1, 2

--- Looking at Countries with highest infection rate compared to population

--SELECT LOCATION, POPULATION, MAX(TOTAL_CASES) AS HIGHEST_INFECTION_COUNT, MAX((TOTAL_CASES/POPULATION)*100) AS CASES_PERCENTAGE
--FROM dbo.CovidDeaths$
--WHERE continent is not null
--GROUP BY location, population
--ORDER BY CASES_PERCENTAGE DESC

--- Showing countries with the highest death count per population

--SELECT LOCATION, MAX(TOTAL_DEATHS) AS TOTAL_DEATH_COUNT FROM dbo.CovidDeaths$
--WHERE continent is not null
--GROUP BY location
--ORDER BY TOTAL_DEATH_COUNT DESC

--- let's take things down by continent

--- Showing continents with the highest death count per population

--SELECT continent, MAX(TOTAL_DEATHS) AS TOTAL_DEATH_COUNT FROM dbo.CovidDeaths$
--WHERE continent is not null
--GROUP BY continent
--ORDER BY TOTAL_DEATH_COUNT DESC

--- GLOBAL NUMBERS

--SELECT DATE, SUM(CAST(new_cases as decimal)) AS TOTAL_CASES, SUM(CAST(new_deaths as decimal)) AS TOTAL_DEATHS, SUM(CAST(new_deaths as decimal))/SUM(CAST(new_cases as decimal)) AS DEATH_PERCENTAGE
--FROM dbo.CovidDeaths$
----WHERE location = 'Brazil' and 
--where continent is not null
--group by date
--ORDER BY 1, 2


--- Looking at Total Population vs Vaccinations

--- USE CTE

--WITH PopvsVac (Continent, Location, Date, Population, new_vaccinations, ROLLING_PEOPLE_VACCINATED) as (
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
--SUM(CONVERT(decimal, vac.new_vaccinations)) OVER (PARTITION BY dea.Location Order by dea.location, dea.date) as ROLLING_PEOPLE_VACCINATED
--FROM dbo.CovidVaccinations$ vac
--JOIN dbo.CovidDeaths$ dea
--ON vac.location = dea.location
--and vac.date = dea.date
--where dea.continent is not null
----order by 2, 3
--)
--SELECT *, (ROLLING_PEOPLE_VACCINATED/Population)*100 FROM PopvsVac

--- USE TEMP TABLE

--DROP TABLE IF EXISTS #PercentPopulationVaccinated
--CREATE TABLE #PercentPopulationVaccinated (
--Continent nvarchar(255),
--Location nvarchar(255),
--Date datetime,
--Population numeric,
--New_vaccinations numeric,
--ROLLING_PEOPLE_VACCINATED numeric
--)

--Insert into #PercentPopulationVaccinated
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
--SUM(CONVERT(decimal, vac.new_vaccinations)) OVER (PARTITION BY dea.Location Order by dea.location, dea.date) as ROLLING_PEOPLE_VACCINATED
--FROM dbo.CovidVaccinations$ vac
--JOIN dbo.CovidDeaths$ dea
--ON vac.location = dea.location
--and vac.date = dea.date
--where dea.continent is not null
----order by 2, 3

--SELECT *, (ROLLING_PEOPLE_VACCINATED/Population)*100 FROM #PercentPopulationVaccinated


-- Creating view to store data for later visualizations

--Create view PercentPopulationVaccinated as
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
--SUM(CONVERT(decimal, vac.new_vaccinations)) OVER (PARTITION BY dea.Location Order by dea.location, dea.date) as ROLLING_PEOPLE_VACCINATED
--FROM dbo.CovidVaccinations$ vac
--JOIN dbo.CovidDeaths$ dea
--ON vac.location = dea.location
--and vac.date = dea.date
--where dea.continent is not null
--order by 2, 3

SELECT * FROM PercentPopulationVaccinated 

--EXEC sp_help 'dbo.CovidDeaths$'

--UPDATE dbo.CovidDeaths$ SET total_cases = TRY_CAST(total_cases AS decimal(10, 1))

--UPDATE dbo.CovidDeaths$ SET total_deaths = TRY_CAST(total_deaths AS decimal(10, 1))

--ALTER TABLE dbo.CovidDeaths$ ALTER COLUMN total_cases decimal(10, 1)

--ALTER TABLE dbo.CovidDeaths$ ALTER COLUMN total_deaths decimal(10, 1)

--ALTER TABLE dbo.CovidDeaths$ ALTER COLUMN population decimal



