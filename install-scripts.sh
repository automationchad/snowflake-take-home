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