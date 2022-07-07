Select *
From ProjectPortfolio..CovidDeaths
Where continent is not null
order by 3,4


--Select *
--From ProjectPortfolio..CovidVaccinations
--order by 3,4

-- Select Data that will be used

Select location, date,   total_cases, total_deaths, new_cases, population
From ProjectPortfolio..CovidDeaths
order by 1,2


-- Looking at Total Cases vs total deaths
-- Show liklihood of dying if you contract covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 as DeathPercentage
From ProjectPortfolio..CovidDeaths
where location like'%nigeria%'
and continent is not null
order by 1,2


-- Looking at Total Cases vs  Population

Select location, date, total_cases, population, (total_cases/population)* 100 as PercentPopulationInfected
From ProjectPortfolio..CovidDeaths
--where location like'%nigeria%'
order by 1,2


-- Looking at Countries with Highest Infection Rate compared to Population

Select location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))* 100 as PercentPopulationInfected
From ProjectPortfolio..CovidDeaths
--where location like'%nigeria%'
Group by location, population
order by PercentPopulationInfected desc


-- Showing Countries with Highest Death Count per Population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From ProjectPortfolio..CovidDeaths
--where location like'%nigeria%'
Where continent is not null
Group by location
order by TotalDeathCount desc



-- BREAK THINGS DOWN BY CONTINENT
-- Showing continents with highest death count per population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From ProjectPortfolio..CovidDeaths
--where location like'%nigeria%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

-- this is correct, but for the sake of visualization, the above will be used
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From ProjectPortfolio..CovidDeaths
--where location like'%nigeria%'
Where continent is null
Group by location
order by TotalDeathCount desc


--GLOBAL NUMBERS
--with date grouping
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_death, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From ProjectPortfolio..CovidDeaths
--where location like'%nigeria%'
where continent is not null
Group by date
order by 1,2

--without date grouping
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_death, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From ProjectPortfolio..CovidDeaths
--where location like'%nigeria%'
where continent is not null
--Group by date


-- Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations 
, SUM(CONVERT(INT, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From ProjectPortfolio..CovidDeaths dea
Join ProjectPortfolio..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3
	

-- USE CTE

WITH PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations 
, SUM(CONVERT(INT, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From ProjectPortfolio..CovidDeaths dea
Join ProjectPortfolio..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100 
From PopvsVac





-- TEMP TABLE

DROP TABLE IF exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccination numeric
)


INSERT INTO #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations 
, SUM(CONVERT(INT, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccination
--, (RollingPeopleVaccinated/population)*100
From ProjectPortfolio..CovidDeaths dea
Join ProjectPortfolio..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccination/population)*100 
From #PercentPopulationVaccinated





--Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations 
, SUM(CONVERT(INT, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccination
--, (RollingPeopleVaccinated/population)*100
From ProjectPortfolio..CovidDeaths dea
Join ProjectPortfolio..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated



Create View PercentageDeath as
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 as DeathPercentage
From ProjectPortfolio..CovidDeaths
where location like'%nigeria%'
and continent is not null
--order by 1,2

Select *
From PercentageDeath



Create View PercentPopulationInfected as
Select location, date, total_cases, population, (total_cases/population)* 100 as PercentPopulationInfected
From ProjectPortfolio..CovidDeaths
--where location like'%nigeria%'
--order by 1,2

Select *
From PercentPopulationInfected




Create View HighestInfectionCountByCountry as
Select location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))* 100 as PercentPopulationInfected
From ProjectPortfolio..CovidDeaths
--where location like'%nigeria%'
Group by location, population
--order by PercentPopulationInfected desc

Select *
From HighestInfectionCountByCountry



Create View HighestDeathCountByCountry as
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From ProjectPortfolio..CovidDeaths
--where location like'%nigeria%'
Where continent is not null
Group by location
--order by TotalDeathCount desc

Select *
From HighestDeathCountByCountry



Create View HighestDeathCountByContinent as
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From ProjectPortfolio..CovidDeaths
--where location like'%nigeria%'
Where continent is not null
Group by continent
--order by TotalDeathCount desc

Select *
From HighestDeathCountByContinent




Create View GlobalDeathPercentage as
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_death, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From ProjectPortfolio..CovidDeaths
--where location like'%nigeria%'
where continent is not null
Group by date
--order by 1,2

Select *
From GlobalDeathPercentage
