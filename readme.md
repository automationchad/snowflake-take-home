# Snowflake Query Exercise

Welcome to the Snowflake Query Exercise! This document will guide you through setting up your environment and executing a series of SQL queries on a weather dataset stored in Snowflake. It uses both the Snowflake CLI and SnowSQL to execute the queries.

**View Trial Account**: If you haven't already, check out the [Snowflake Trial Account](https://app.snowflake.com/zzgoyys/wv29513/#/data/databases/TAKE_HOME).

## Database Setup

Before running the queries you must run the following commands in a Snowflake worksheet to create the database, stage, and table.

a. Database `TAKE_HOME` needs to be created.

```sql
CREATE DATABASE TAKE_HOME;
```

b. The stage `my_take_home_stage` needs to be created.
```sql
CREATE STAGE my_take_home_stage;
```

c. The table `weather_data` needs to be created.

```sql
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
```

Once created you can navigate to the `TAKE_HOME` database where the `weather_data` data will be stored.

## CLI Setup

For this exercise, you'll be using the Snowflake CLI to execute the queries. Follow the below instructions to install SnowSQL, connect to the database, and set up the necessary data. To install Snowflake on your Mac, you can use Homebrew:

```shell
brew install --cask snowflake-snowsql
```

Verify that SnowSQL is installed correctly by running the following command:

```shell
snowsql -v
```

### 🚨 Troubleshooting

In the case that the command `snowsql` is not found, open your terminal and run the below to fix it:

```shell
cd ..
cd ..
ls
cd etc
sudo nano paths
```

You'll then be prompted to enter your password. 

After that, add the path to the SnowSQL application to the `paths` file. As an example, the path to the SnowSQL application on my Mac is:

```shell
/Applications/SnowSQL.app/Contents/MacOS/
```

Then, save the file and exit the editor.

---

Connect to the database and set up the necessary table and data:

```shell
snowsql -a kb96841.ap-southeast-2 -u williammarzella
# 🗝️ Password entered here
```

Use the `use` command to switch to the `TAKE_HOME` database:

```shell
use database TAKE_HOME;
```

Upload the file to the stage:

```shell
PUT file:///Users/marzella/Downloads/snowflake_takehome/weather.csv 
@my_take_home_stage 
auto_compress=false;
```

Copy the data into the table:

```sql
COPY into weather_data
from @my_take_home_stage/weather.csv
file_format = (type = csv field_optionally_enclosed_by='"')
on_error = 'skip_file';
```

Done! You're now ready to run the queries.

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

The queries will also be available in the trial account in the worksheet [Take home queries on weather data](https://app.snowflake.com/zzgoyys/wv29513/w32STmaHqJ7e#query).

## Conclusion

This exercise provides a practical way to familiarize yourself with Snowflake and SQL queries. By analyzing real-world weather data, you'll gain insights into data manipulation and querying techniques that are essential for data analysis and business intelligence tasks.

Happy querying!
