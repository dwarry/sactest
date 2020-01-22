#!/usr/bin/bash

hdfs dfs -put -f test_data.csv /tmp

HWC_JAR=local:/usr/hdp/current/hive_warehouse_connector/hive-warehouse-connector-assembly-1.0.0.3.1.4.0-315.jar 
HWC_PY=local:/usr/hdp/current/hive_warehouse_connector/pyspark_hwc-1.0.0.3.1.4.0-315.zip

spark-submit --master yarn \
             --deploy-mode client \
             --jars $HWC_JAR \
             --py-files $HWC_PY \
             load_test_data.py

             #--conf spark.datasource.hive.warehouse.metastoreUri=thrift://cluster3-node-0.dlm.local:9083 \
             #--conf spark.datasource.hive.warehouse.load.staging.dir=/tmp \
             #--conf spark.hadoop.hive.llap.daemon.service.hosts=@llap0 \
             #--conf spark.hadoop.hive.zookeeper.quorum=cluster3-node-0.dlm.local:2181 \


