#!/usr/bin/bash
HWC_JAR=/usr/hdp/current/hive_warehouse_connector/hive-warehouse-connector-assembly-1.0.0.3.1.4.0-315.jar 
HWC_PY=/usr/hdp/current/hive_warehouse_connector/pyspark_hwc-1.0.0.3.1.4.0-315.zip

pyspark --jars $HWC_JAR --py-files $HWC_PY \
  --conf spark.datasource.hive.warehouse.metastoreUri=thrift://cluster3-node-0.dlm.local:9083 \
  --conf spark.datasource.hive.warehouse.load.staging.dir=/tmp \
  --conf spark.hadoop.hive.llap.daemon.service.hosts=@llap0 \
  --conf spark.hadoop.hive.zookeeper.quorum=cluster3-node-0.dlm.local:2181 

#  --conf spark.sql.hive.hiveserver2.jdbc.url=jdbc:hive2://cluster3-node-0.dlm.local:2181/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2-interactive \
#  --conf spark.sql.hive.hiveserver2.jdbc.url.principal=hive/_HOST@DLM.LOCAL

