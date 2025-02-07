# kubectl exec spark-master-67c8985674-7qtpw -n spark -it -- \
# spark-submit --master spark://spark-master:7077 \
#              --conf spark.driver.bindAddress=10.244.0.44 \
#              --conf spark.driver.host=10.244.0.44 \
#              ./scripts/spark-poc.py
# PYTHON_SCRIPT=$1  # The first argument is the Python script

# Get Spark master pod name dynamically
SPARK_MASTER_POD=$(kubectl get pods -n spark -l app=spark-master -o jsonpath='{.items[0].metadata.name}')

# Get Spark master pod IP dynamically
SPARK_MASTER_IP=$(kubectl get pod $SPARK_MASTER_POD -n spark -o jsonpath='{.status.podIP}')

# Execute spark-submit with the dynamic values
kubectl exec -n spark -it $SPARK_MASTER_POD -- \
    spark-submit --master spark://spark-master:7077 \
                 --conf spark.driver.bindAddress=$SPARK_MASTER_IP \
                 --conf spark.driver.host=$SPARK_MASTER_IP \
                 ./scripts/spark-poc.py