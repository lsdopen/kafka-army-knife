FROM lsdopen/swiss-army-knife:latest

RUN apt-get update
RUN apt-get install openjdk-17-jre curl gnupg unzip python3-pip sudo -y
RUN pip install pyiceberg["s3fs,hive,rest,pyarrow"]

# Confluent CLI
RUN mkdir -p /etc/apt/keyrings && \
    curl https://packages.confluent.io/confluent-cli/deb/archive.key | gpg --dearmor -o /etc/apt/keyrings/confluent-cli.gpg && \
    chmod go+r /etc/apt/keyrings/confluent-cli.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/confluent-cli.gpg] https://packages.confluent.io/confluent-cli/deb stable main" | tee /etc/apt/sources.list.d/confluent-cli.list >/dev/null && \
    apt update && \
    apt install confluent-cli

# Add user and include in sudoers
RUN useradd -d /home/kafka -m kafka -s /bin/bash -c "Kafka User"
RUN usermod -aG sudo kafka
RUN echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Change to user kafka
USER kafka

# Create .local dirs
RUN mkdir -p /home/kafka/.local/bin
RUN mkdir -p /home/kafka/.local/share

# Confluent tooling
RUN wget https://packages.confluent.io/archive/7.9/confluent-7.9.0.tar.gz -O /tmp/confluent-7.9.0.tar.gz
RUN tar -xzvf /tmp/confluent-7.9.0.tar.gz -C /home/kafka/.local/share/ && rm -rf /tmp/confluent*
RUN ln -s /home/kafka/.local/share/confluent-7.9.0 /home/kafka/.local/share/confluent
ENV PATH="${PATH}:/home/kafka/.local/share/confluent/bin:/home/kafka/.local/bin"

# Minio tooling
ARG TARGETARCH
RUN if [ "${TARGETARCH}" = "amd64" ]; then wget https://dl.min.io/client/mc/release/linux-amd64/mc -O /home/kafka/.local/bin/mc; fi
RUN if [ "${TARGETARCH}" = "arm64" ]; then wget https://dl.min.io/client/mc/release/linux-arm64/mc -O /home/kafka/.local/bin/mc; fi
RUN chmod a+x /home/kafka/.local/bin/mc

# Spark SQL
RUN wget https://dlcdn.apache.org/spark/spark-3.5.6/spark-3.5.6-bin-hadoop3.tgz -O /tmp/spark-3.5.6-bin-hadoop3.tgz
RUN tar -xzvf /tmp/spark-3.5.6-bin-hadoop3.tgz -C /home/kafka/.local/share/ && rm -rf /tmp/spark*
RUN ln -s /home/kafka/.local/share/spark-3.5.6-bin-hadoop3 /home/kafka/.local/share/spark
RUN wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.4/hadoop-aws-3.3.4.jar \
    -O /home/kafka/.local/share/spark/jars/hadoop-aws-3.3.4.jar
RUN wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.12.648/aws-java-sdk-bundle-1.12.648.jar \
    -O /home/kafka/.local/share/spark/jars/aws-java-sdk-bundle-1.12.648.jar
ENV PATH="${PATH}:/home/kafka/.local/share/spark/bin"
