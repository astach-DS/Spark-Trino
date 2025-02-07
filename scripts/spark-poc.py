from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, StringType, IntegerType

my_catalog = 'iceberg'
# Initialize the Spark session
spark = SparkSession.builder \
    .appName("CSV to Iceberg") \
    .config(f"spark.sql.catalog.{my_catalog}", "org.apache.iceberg.spark.SparkCatalog") \
    .config(f"spark.sql.catalog.{my_catalog}.type", "hive") \
    .config(f"spark.sql.catalog.{my_catalog}.uri", "thrift://metastore.hive.svc.cluster.local:9083") \
    .config(f"spark.sql.catalog.{my_catalog}.warehouse", "s3a://test/warehouse") \
    .config("spark.hadoop.fs.s3a.endpoint", "http://minio.minio.svc.cluster.local:9000") \
    .config("spark.hadoop.fs.s3a.access.key", "admin") \
    .config("spark.hadoop.fs.s3a.secret.key", "adminpassword123") \
    .config("spark.hadoop.fs.s3a.path.style.access", "true") \
    .config("spark.hadoop.fs.s3a.connection.ssl.enabled", "false") \
    .config("spark.sql.extensions", "org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions") \
    .enableHiveSupport().getOrCreate()

# Create a dataframe
schema = StructType([
    StructField('name', StringType(), True),
    StructField('age', IntegerType(), True),
    StructField('job_title', StringType(), True)
])
data = [("person1", 28, "Doctor"), ("person2", 35, "Singer"), ("person3", 42, "Teacher")]
df = spark.createDataFrame(data, schema=schema)

df.write.format("iceberg").mode("overwrite").saveAsTable(f"{my_catalog}.demo.test")

# databases = spark.sql(f"SHOW SCHEMAS IN {my_catalog}")
# print("Databases:")
# databases.show()
