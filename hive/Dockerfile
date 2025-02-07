FROM openjdk:11-jdk-slim

# Set environment variables
ENV HIVE_VERSION=4.0.0
ENV HADOOP_VERSION=3.3.6
ENV HIVE_HOME=/opt/hive
ENV HADOOP_HOME=/opt/hadoop
ENV PATH="${HIVE_HOME}/bin:${HADOOP_HOME}/bin:${PATH}"

RUN apt-get update && apt-get install -y \
    wget \
    procps \
    netcat \
    && rm -rf /var/lib/apt/lists/*

# Download and extract Hive
RUN wget archive.apache.org/dist/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz -O /tmp/hive.tar.gz \
    && mkdir -p ${HIVE_HOME} \
    && tar -xzf /tmp/hive.tar.gz -C ${HIVE_HOME} --strip-components=1 \
    && rm /tmp/hive.tar.gz

RUN wget downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz -O /tmp/hadoop.tar.gz \
    && mkdir -p ${HADOOP_HOME} \
    && tar -xzf /tmp/hadoop.tar.gz -C ${HADOOP_HOME} --strip-components=1 \
    && rm /tmp/hadoop.tar.gz

RUN wget -O ${HIVE_HOME}/lib/postgresql-42.6.0.jar https://jdbc.postgresql.org/download/postgresql-42.6.0.jar

# Set Hadoop environment variables
ENV HADOOP_CLASSPATH="${HADOOP_HOME}/share/hadoop/tools/lib/*"
