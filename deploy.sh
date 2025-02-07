#!/bin/bash

# Define constants

MINIO_PORT=9090
BUCKET_NAME="test"
MINIO_YAML="./minio/minio.yaml"
POSTGRES_YAML="./postgres/postgres.yaml"
HIVE_YAML="./hive/hive.yaml"
TRINO_YAML="./trino/trino.yaml"
MINIO_ACCESS_KEY="admin"
MINIO_SECRET_KEY="adminpassword123"
MINIO_SERVICE_NAME="minio"
SPARK_YAML="./spark/spark.yaml"


MINIO_NAMESPACE=$( yq '. | select(.kind == "Namespace") | .metadata.name' $MINIO_YAML)
MINIO_SERVICE_NAME=$( yq '. | select(.kind == "Service") | .metadata.name' $MINIO_YAML)
POSTGRES_NAMESPACE=$( yq '. | select(.kind == "Namespace") | .metadata.name' $POSTGRES_YAML)

# Step 1: Create MinIO
echo "Deploying MinIO..."
kubectl create -f $MINIO_YAML

# Wait for the MinIO service to get the external IP
echo "Waiting for MinIO service to be ready..."
while true; do
  MINIO_IP=$(kubectl get svc $MINIO_SERVICE_NAME -n $MINIO_NAMESPACE -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
  if [ ! -z "$MINIO_IP" ]; then
    echo "MinIO is available at http://$MINIO_IP:$MINIO_PORT"
    break
  fi
  sleep 2
done

# Step 2: Create the bucket using AWS CLI
echo "Creating bucket '$BUCKET_NAME' in MinIO using AWS CLI..."
AWS_ACCESS_KEY_ID=$MINIO_ACCESS_KEY AWS_SECRET_ACCESS_KEY=$MINIO_SECRET_KEY \
aws --endpoint-url http://$MINIO_IP:9000 s3 mb s3://$BUCKET_NAME

echo "Bucket '$BUCKET_NAME' created successfully!"

# Step 3: Deploy PostgreSQL
echo "Deploying PostgreSQL..."
kubectl create -f $POSTGRES_YAML

# Step 4: Wait for PostgreSQL pod to be ready
echo "Waiting for PostgreSQL pod to be up and running..."
while [[ $(kubectl get pods -n $POSTGRES_NAMESPACE -o jsonpath='{.items[0].status.phase}') != "Running" ]]; do
  echo "PostgreSQL is not yet ready..."
  sleep 2
done

echo "PostgreSQL is ready!"

# Step 5: Deploy Hive
echo "Deploying Hive..."
kubectl create -f $HIVE_YAML

# Step 6: Deploy Trino
echo "Deploying Trino..."
kubectl create -f $TRINO_YAML

echo "Deployment completed! You can now access the services."
