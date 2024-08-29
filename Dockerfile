FROM lsdopen/swiss-army-knife:latest

RUN apt-get update
RUN apt-get install openjdk-11-jre curl gnupg unzip -y

# Confluent Community tooling
ADD https://packages.confluent.io/archive/7.7/confluent-community-7.7.0.tar.gz /tmp/confluent-community/
RUN cd /tmp/confluent-community && \
    tar -xzvf confluent-community-7.7.0.tar.gz --directory /usr/share/ && \
    rm -rf /tmp/confluent-community/
ENV PATH="${PATH}:/usr/share/confluent-7.7.0/bin"

# Confluent CLI
RUN mkdir -p /etc/apt/keyrings && \
    curl https://packages.confluent.io/confluent-cli/deb/archive.key | gpg --dearmor -o /etc/apt/keyrings/confluent-cli.gpg && \
    chmod go+r /etc/apt/keyrings/confluent-cli.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/confluent-cli.gpg] https://packages.confluent.io/confluent-cli/deb stable main" | tee /etc/apt/sources.list.d/confluent-cli.list >/dev/null && \
    apt update && \
    apt install confluent-cli

# sqlline
ADD https://repo1.maven.org/maven2/sqlline/sqlline/1.9.0/sqlline-1.9.0-jar-with-dependencies.jar /usr/share/sqlline/
ADD sqlline /usr/share/sqlline/
ENV PATH="${PATH}:/usr/share/sqlline"

# Oracle driver
ADD https://download.oracle.com/otn-pub/otn_software/jdbc/1911/ojdbc8.jar /usr/share/sqlline/

# IBM DB2 JTOpen driver
# ADD https://tenet.dl.sourceforge.net/project/jt400/JTOpen-full/10.6/jtopen_10_6.zip /tmp/jt400/
COPY ./drivers/jtopen_10_6.zip /tmp/jt400/
RUN cd /tmp/jt400 && \
    unzip jtopen_10_6.zip && \
    cp lib/java9/jt400.jar /usr/share/sqlline/ && \
    rm -rf /tmp/jt400

# MSSQL driver
ADD https://download.microsoft.com/download/4/c/3/4c31fbc1-62cc-4a0b-932a-b38ca31cd410/sqljdbc_9.2.1.0_enu.tar.gz /tmp/sqljdbc/
RUN cd /tmp/sqljdbc && \
    tar -xzvf sqljdbc_9.2.1.0_enu.tar.gz && \
    cp sqljdbc_9.2/enu/mssql-jdbc-9.2.1.jre11.jar /usr/share/sqlline/ && \
    rm -rf /tmp/sqljdbc

# add extra profile to .profile for ssh logins
ADD extra-profile /tmp/
RUN cat /tmp/extra-profile >> /root/.profile && \
    rm /tmp/extra-profile
