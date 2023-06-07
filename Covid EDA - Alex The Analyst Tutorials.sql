SELECT *
FROM ProjectOneCovid..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4

-- Select Data that we are going to be using
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM ProjectOneCovid..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows the chances of you dying in the United States if you have been infected with Covid
SELECT continent, date, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100,2) AS deaths_percentage
FROM ProjectOneCovid..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population in the United States got Covid
SELECT continent, date, total_cases, population, ROUND((total_cases/population)*100,2) AS infection_percentage
FROM ProjectOneCovid..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Looking at Countries with Highest Infection Rate compared to Population
SELECT continent, population, MAX(total_cases) AS highest_infection_count, ROUND(MAX((total_cases/population)*100),2) AS percent_population_infected
FROM ProjectOneCovid..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent, population
ORDER BY percent_population_infected DESC

-- Looking at Continent with the Highest Death Count per Population
SELECT continent, MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM ProjectOneCovid..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC

-- Looking at Continents with the Highest Death Count per Population (Different Method)
SELECT location, MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM ProjectOneCovid..CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY total_death_count DESC

-- Showing contintents with 
SELECT continent, MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM ProjectOneCovid..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC

-- Global Numbers
SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, ROUND(SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100,2) AS death_percentage
FROM ProjectOneCovid..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Percentage of Deaths per day Globally
SELECT date , SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, ROUND(SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100,2) AS death_percentage
FROM ProjectOneCovid..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

-- Joining Vaccinations to CovidDeaths
SELECT *
FROM ProjectOneCovid..CovidDeaths AS d
INNER JOIN ProjectOneCovid..CovidVaccinations AS v
	ON d.location = v.location
	AND d.date = v.date

-- Looking at Total Population vs Vaccinations
-- USE CTE
WITH PopvsVac (continent, location, date , population, new_vaccinations, rolling_people_vaccinated)
AS 
(
SELECT 
	d.continent, 
	d.location, 
	d.date, 
	d.population, 
	v.new_vaccinations, 
	SUM(CONVERT(INT,v.new_vaccinations)) OVER (Partition BY d.location ORDER BY d.location, d.date) AS rolling_people_vaccinated
FROM ProjectOneCovid..CovidDeaths AS d
INNER JOIN ProjectOneCovid..CovidVaccinations AS v
	ON d.location = v.location
	AND d.date = v.date
WHERE d.continent IS NOT NULL
)
SELECT *, ROUND((rolling_people_vaccinated/population)*100,2)
FROM PopvsVac

-- TEMP Table
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric
)

Insert into #PercentPopulationVaccinated
SELECT 
	d.continent, 
	d.location, 
	d.date, 
	d.population, 
	v.new_vaccinations,
	SUM(CONVERT(INT,v.new_vaccinations)) OVER (Partition by d.location ORDER BY d.location, d.date) AS rolling_people_vaccinated
FROM ProjectOneCovid..CovidDeaths AS d
INNER JOIN ProjectOneCovid..CovidVaccinations AS v
	ON d.location = v.location
	AND d.date = v.date

Select *, (rolling_people_vaccinated/population)*100
From #PercentPopulationVaccinated

-- Creating View to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated AS
Select 
	d.continent, 
	d.location, 
	d.date, 
	d.population, 
	v.new_vaccinations,
	SUM(CONVERT(INT,v.new_vaccinations)) OVER (Partition by d.location ORDER BY d.location, d.date) AS rolling_people_vaccinated
FROM ProjectOneCovid..CovidDeaths AS d
INNER JOIN ProjectOneCovid..CovidVaccinations AS v
	ON d.location = v.location
	AND d.date = v.date
where d.continent is not null

SELECT *
FROM PercentPopulationVaccinated
