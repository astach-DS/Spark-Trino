from pyspark.sql import SparkSession

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
    .getOrCreate()

databases = spark.sql(f"SHOW SCHEMAS IN {my_catalog}")
print("Databases:")
databases.show()
