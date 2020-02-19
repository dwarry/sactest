from pyspark.sql import SparkSession
from pyspark_llap import HiveWarehouseSession
import pyspark.sql.types as T


spark = SparkSession.builder.appName("SAC-Test").enableHiveSupport().getOrCreate()

sc = spark.sparkContext

sc._jvm.za.co.absa.spline.harvester \
    .SparkLineageInitializer.enableLineageTracking(spark._jsparkSession)


hive = HiveWarehouseSession.session(spark).build()

hive.setDatabase("sactest")

schema = T.StructType()
schema.add(T.StructField("col1", T.IntegerType(), False))
schema.add(T.StructField("col2", T.StringType(), False))
schema.add(T.StructField("col3", T.DateType(), False))

df = spark.read.csv("/tmp/test_data.csv", schema, header=True, quote="'")

df.write.format(HiveWarehouseSession.HIVE_WAREHOUSE_CONNECTOR).mode("append").option("table", "sac_test").save()

df.write.json("/tmp/spline_test.json", "overwrite")
