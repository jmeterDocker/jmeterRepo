FROM openjdk:8-jre-slim

#JMeter version
ARG JMETER_VERSION=4.0

# Install few utilities
RUN apt-get clean && \
    apt-get update && \
    apt-get install -y \
		wget \
		telnet \
		git \
		openssh-client \
		openssh-server \
		iputils-ping \
		unzip

# Install JMeter
RUN mkdir /jmeter \
	&& cd /jmeter \
	&& wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-$JMETER_VERSION.tgz \
	&& tar -xzf apache-jmeter-$JMETER_VERSION.tgz \
	&& rm apache-jmeter-$JMETER_VERSION.tgz

# Set JMeter Home
ENV JMETER_HOME /jmeter/apache-jmeter-$JMETER_VERSION

# Add JMeter to the Path
ENV PATH $JMETER_HOME/bin:$PATH