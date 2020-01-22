#!/usr/bin/bash
HWC_JAR=local:/usr/hdp/current/hive_warehouse_connector/hive-warehouse-connector-assembly-1.0.0.3.1.4.0-315.jar 
HWC_PY=local:/usr/hdp/current/hive_warehouse_connector/pyspark_hwc-1.0.0.3.1.4.0-315.zip

pyspark --jars $HWC_JAR --py-files $HWC_PY --conf  spark.hadoop.hive.llap.daemon.service.hosts=@llap0

