FROM jmeter-parent:latest

# Create folder where jmeter will be run
RUN mkdir /jmeter/master

# Set working directory
WORKDIR /jmeter/master

# Start ssh
RUN service ssh start

RUN mkdir /root/.ssh