# Snowflake Query Exercise

Welcome to the Snowflake Query Exercise! This document will guide you through setting up your environment and executing a series of SQL queries on a weather dataset stored in Snowflake. 

## Getting Started

1. **Create a Trial Account**: If you haven't already, sign up for a trial account at [Snowflake](https://app.snowflake.com/zzgoyys/wv29513/#/data/databases/TAKE_HOME).

2. **Access the Database**: Once logged in, navigate to the `TAKE_HOME` database where the `weather_data` table is stored.

## Environment Setup

Before running the queries, ensure you have SnowSQL installed on your machine. Follow the below instructions to install SnowSQL, connect to the database, and set up the necessary table and data.

To install Snowflake on your Mac, you can use Homebrew:

```bash
brew install --cask snowflake-snowsql
```

#In the case that the command `snowsql` is not found, open your terminal and run the below to fix it:

```shell
cd ..
cd ..
ls
cd etc
sudo nano paths
# 2. Enter Password
# 3. Add in the path as follows:
   /Applications/SnowSQL.app/Contents/MacOS/
control + x
Y
[ENTER]
```

snowsql -v
snowsql -a kb96841.ap-southeast-2 -u williammarzella
# password entered here

use database TAKE_HOME;

# Upload the file to the stage

PUT file:///Users/marzella/Downloads/snowflake_takehome/weather.csv 
@my_take_home_stage 
auto_compress=false;

# Create the table

CREATE TABLE weather_data (
    country VARCHAR,
    state VARCHAR,
    city VARCHAR,
    postal_code VARCHAR,
    observation_date DATE,
    day_of_year INTEGER,
    temp_min_f FLOAT,
    temp_max_f FLOAT,
    temp_avg_f FLOAT,
    total_precip_in FLOAT,
    total_snowfall_in FLOAT,
    total_snowdepth_in FLOAT
);

# Copy the data into the table

COPY into weather_data
from @my_take_home_stage/weather.csv
file_format = (type = csv field_optionally_enclosed_by='"')
on_error = 'skip_file';

## Running Queries

The `queries.sql` file contains a series of SQL queries designed to extract meaningful insights from the weather data. These queries will help you understand:

- The range of dates covered by the weather data.
- The number of countries included in the dataset and their names.
- The coldest day ever recorded in Toronto and its temperature.
- The total snowfall in Denver for the year 2014.
- The top 5 rainiest cities in 2018 and the amount of rain they received.
- The number of days with precipitation in each month of 2019 in Olympia, Washington.
- Cities experiencing higher snowfall than the average in their states in January 2019.
- The maximum number of consecutive days of rainfall in each city in June 2016.
- The space the weather data table occupies.

## Conclusion

This exercise provides a practical way to familiarize yourself with Snowflake and SQL queries. By analyzing real-world weather data, you'll gain insights into data manipulation and querying techniques that are essential for data analysis and business intelligence tasks.

Happy querying!
