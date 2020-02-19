#!/usr/bin/bash

hdfs dfs -put -f test_data.csv /tmp

HWC_JAR=local:/usr/hdp/current/hive_warehouse_connector/hive-warehouse-connector-assembly-1.0.0.3.1.4.0-315.jar 
HWC_PY=local:/usr/hdp/current/hive_warehouse_connector/pyspark_hwc-1.0.0.3.1.4.0-315.zip
SPLINE_JAR=/home/mario/spline/spark-agent-bundle-2.3-0.4.1.jar
SPLINE_URL=http://$HOSTNAME:8079/spline-rest-gateway/producer

spark-submit --master yarn \
             --deploy-mode client \
             --jars $HWC_JAR,$SPLINE_JAR \
             --driver-java-options -Dspline.producer.url=$SPLINE_URL \
             --py-files $HWC_PY \
             load_test_data.py

