FROM lsdopen/swiss-army-knife:latest

ADD https://repo1.maven.org/maven2/sqlline/sqlline/1.9.0/sqlline-1.9.0-jar-with-dependencies.jar /usr/share/sqlline/
ADD https://download.oracle.com/otn-pub/otn_software/jdbc/1911/ojdbc8.jar /usr/share/sqlline/
ADD https://tenet.dl.sourceforge.net/project/jt400/JTOpen-full/10.6/jtopen_10_6.zip /tmp/
ADD https://download.microsoft.com/download/4/c/3/4c31fbc1-62cc-4a0b-932a-b38ca31cd410/sqljdbc_9.2.1.0_enu.tar.gz /tmp/

RUN apt-get update
RUN apt-get install unzip -y
RUN mkdir /tmp/install && \
    cd /tmp/install && \
    unzip ../jtopen_10_6.zip && \
    tar zxvf ../sqljdbc_9.2.1.0_enu.tar.gz && \
    cp lib/java9/jt400.jar /usr/share/sqlline/ && \
    cp sqljdbc_9.2/enu/mssql-jdbc-9.2.1.jre11.jar /usr/share/sqlline/ && \
    rm -rf /tmp/install && \
    rm -f /tmp/jtopen_10_6.zip && \
    rm -f /tmp/sqljdbc_9.2.1.0_enu.tar.gz

ADD sqlline /usr/bin/sqlline