kubectl exec spark-master-67c8985674-fx9fx -n spark -it -- \
spark-submit --master spark://spark-master:7077 \
             --conf spark.driver.bindAddress=10.244.0.8 \
             --conf spark.driver.host=10.244.0.8 \
             ./scripts/test_park.py