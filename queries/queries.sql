CREATE DATABASE PROJECT_DB;
USE DATABASE PROJECT_DB;

s

CREATE TABLE CUSTOMER_DETAILS (
  first_name string,
  last_name string,
  address string,
  city string,
  state string
);

select * from customer_details;


 DROP DATABASE PROJECT_DB;


INSERT INTO CUSTOMER_DETAILS (first_name, last_name, address, city, state) VALUES
('Nasim', 'Atkinson', '9375 Eu Rd.', 'Langenburg', 'SK'),
('Mia', 'Simmons', 'P.O. Box 511, 3629 A Road', 'Cork', 'M'),
('Ann', 'Boone', 'P.O. Box 740, 4309 Porttitor Street', 'Almelo', 'Overijssel'),
('Leroy', 'Riddle', '7240 Dolor. Rd.', 'Hamilton', 'NI'),
('Dennis', 'Johns', 'Ap #282-8287 Ipsum Ave', 'Bollnas', 'X'),
('Catherine', 'Graham', '5941 Est Ave', 'Acquafondata', 'LAZ'),
('Ayanna', 'Bush', 'Ap #571-9874 Molestie St.', 'Skovde', 'Vastra Gotalands lan'),
('Troy', 'Lynn', 'Ap #283-9930 Nonummy. Street', 'Sainte-Flavie', 'QC'),
('Britanni', 'Serrano', 'P.O. Box 843, 6710 Parturient Rd.', 'Knoxville', 'Tennessee'),
('Aspen', 'Atkins', 'P.O. Box 315, 2186 Rutrum, Avenue', 'Kilmarnock', 'Ayrshire');


create or replace file format file_format_cli
    type = 'CSV'
    field_delimiter = '|'
    skip_header = 1;


create or replace stage snow_cli_stage
       file_format = file_format_cli


desc stage snow_cli_stage


-- put 'file:///D:\Cloud Data Engineering\ppp\snowflake\snowflake-data-ingestion\data/customer_detail.csv'
--      @snow_cli_stage
--      auto_compress = True;

PUT 'file://D:/Cloud Data Engineering/ppp/snowflake/snowflake-data-ingestion/data/customer_detail.csv'
@snow_cli_stage
AUTO_COMPRESS=TRUE;


COPY INTO CUSTOMER_DETAILS
      FROM @snow_cli_stage
      file_format = file_format_cli
      on_error = 'skip_file';


select * from CUSTOMER_DETAILS; 


CREATE STAGE BULK_COPY
URL='s3://snowflake-loading-data-ui/load-folder/TSLA.csv'
CREDENTIALS=(
 AWS_KEY_ID=''
 AWS_SECRET_KEY=''
);


CREATE OR REPLACE TABLE TESLA_STOCKS(
    date DATE,
    open_value DOUBLE,
    high_vlaue DOUBLE,
    low_value DOUBLE,
    close_vlaue DOUBLE,
    adj_close_value DOUBLE,
    volume BIGINT
);

COPY INTO TESLA_STOCKS
FROM @BULK_COPY
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1);

LIST @BULK_COPY_TESLA_STOCKS;


COPY INTO TESLA_STOCKS
FROM @BULK_COPY_TESLA_STOCKS
FILE_FORMAT = (
TYPE = CSV
SKIP_HEADER = 1
);


COPY INTO TESLA_STOCKS
FROM @BULK_COPY
FILE_FORMAT = (
TYPE = CSV
SKIP_HEADER = 1
);

SELECT * 
FROM TESLA_STOCKS
LIMIT 10;

SELECT COUNT(*) 
FROM TESLA_STOCKS;


CREATE OR REPLACE PIPE S3_TESLA_PIPE
AUTO_INGEST = TRUE
AS
COPY INTO TESLA_STOCKS
FROM @BULK_COPY
FILE_FORMAT = (
TYPE = CSV
SKIP_HEADER = 1
);


SHOW PIPES;

SELECT COUNT(*) 
FROM TESLA_STOCKS;

SELECT *
FROM TESLA_STOCKS
WHERE OPEN_VALUE IS NULL
   OR CLOSE_VLAUE IS NULL;