# sactest
Simple test project to investigate the Spark Atlas Connector

## Environment
* The test was run on a new cluster with HDP3.1.4 installed. 
* Spark Atlas Connector was enabled in Ambari and services restarted. 
* Spark entities did not appear in the Atlas search criteria, so I added the 
  1100-spark_model.json file to `<ATLAS_HOME>/models/1000-Hadoop` as per the
  readme for https://github.com/hortonworks-spark/spark-atlas-connector
  

## Files

* Schema.hql

  Hive DDL file to create the test database and table

* load_test_data.py

  PySpark job that loads data from a file in HDFS and saves it to Hive using the Hive Warehouse Connector

* submit_load_test_data.sh

  Shell script that submits the `load_test_data.py` file to run on Spark. 

* test_data.csv

  A few rows of test data
  
* load_test_data.log

  The output from running `load_test_data.py`
  
## Results

* The output from Spark certainly shows some entries related to Atlas, but no lineage information was captured: 
  * No Spark Process entities were created in Atlas
  * Lineage for the sac_test table just showed data being loaded from a temporary file by an LOAD DATA INPATH Hive statement. 
