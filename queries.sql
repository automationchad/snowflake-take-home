-- What is the range of dates IN the weather data?
SELECT
  MIN(observation_date) AS min_date,
  MAX(observation_date) AS max_date
FROM
  weather_data;

-- How many countries are included IN the dataset? What countries are there?
SELECT
  COUNT(DISTINCT country) AS num_countries
FROM
  weather_data;

-- What is the coldest day ever recorded IN Toronto? How cold was it?
SELECT
  MIN(temp_min_f) AS coldest_temperature
FROM
  weather_data
WHERE
  city = 'Toronto';

-- What is the snowfall total for Denver IN 2014?
SELECT
  SUM(total_snowfall_in) AS snowfall_total
FROM
  weather_data
WHERE
  city = 'Denver'
  AND observation_date BETWEEN '2014-01-01'
  AND '2014-12-31';

-- What are the top 5 rainiest cities IN 2018? How much rain did each receive?
SELECT
  city,
  SUM(total_precip_in) AS total_precipitation
FROM
  weather_data
WHERE
  observation_date BETWEEN '2018-01-01'
  AND '2018-12-31'
GROUP BY
  city
ORDER BY
  total_precipitation DESC
LIMIT
  5;

-- How many days IN each month of 2019 did Olympia, Washington see some sort of precipitation?
SELECT
  TO_CHAR(observation_date, 'Mon') AS month_text,
  COUNT(*) AS days_with_precipitation
FROM
  weather_data
WHERE
  city = 'Olympia'
  AND state = 'Washington'
  AND observation_date BETWEEN '2019-01-01'
  AND '2019-12-31'
  AND (
    total_precip_in > 0
    OR total_snowfall_in > 0
  )
GROUP BY
  TO_CHAR(observation_date, 'Mon')
ORDER BY
  MIN(TO_DATE(TO_CHAR(observation_date, 'Mon'), 'Mon'));

-- What are the cities experiencing higher snowfall than the average snowfall IN their states IN January 2019?
WITH state_snowfall_avg AS (
  SELECT
    state,
    AVG(total_snowfall_in) AS avg_snowfall
  FROM
    weather_data
  WHERE
    observation_date BETWEEN '2019-01-01'
    AND '2019-01-31'
  GROUP BY
    state
)
SELECT
  wd.city,
  wd.state,
  SUM(wd.total_snowfall_in) AS city_snowfall
FROM
  weather_data wd
  JOIN state_snowfall_avg ssa ON wd.state = ssa.state
WHERE
  wd.observation_date BETWEEN '2019-01-01'
  AND '2019-01-31'
  AND wd.total_snowfall_in > ssa.avg_snowfall
GROUP BY
  wd.city,
  wd.state
ORDER BY
  city_snowfall DESC
LIMIT
  10;

-- What is the maximum number of consecutive days of rainfall IN each city IN June 2016?
WITH RainfallEvents AS (
  SELECT
    city,
    observation_date,
    DATE_PART('day', observation_date) - ROW_NUMBER() OVER (
      PARTITION BY city
      ORDER BY
        observation_date
    ) AS GroupID
  FROM
    weather_data
  WHERE
    total_precip_in > 0
    AND observation_date BETWEEN '2016-06-01'
    AND '2016-06-30'
),
ConsecutiveRainfall AS (
  SELECT
    city,
    MIN(observation_date) AS StartDate,
    MAX(observation_date) AS EndDate,
    COUNT(*) AS ConsecutiveDays
  FROM
    RainfallEvents
  GROUP BY
    city,
    GroupID
),
MaxConsecutiveRainfall AS (
  SELECT
    city,
    MAX(ConsecutiveDays) AS MaxConsecutiveDays,
    StartDate,
    EndDate
  FROM
    ConsecutiveRainfall
  GROUP BY
    city,
    StartDate,
    EndDate
  ORDER BY
    MaxConsecutiveDays DESC
  LIMIT
    5
)
SELECT
  *
FROM
  MaxConsecutiveRainfall;

-- How much space does the TABLE of weather data take up?
SELECT
  table_name,
  active_bytes / (1024 * 1024) AS size_in_mb
FROM
  "INFORMATION_SCHEMA".TABLE_STORAGE_METRICS
WHERE
  table_name = 'WEATHER_DATA';