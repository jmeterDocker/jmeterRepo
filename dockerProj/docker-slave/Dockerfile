FROM jmeter-parent:latest

# Create folder where jmeter-server will be run
RUN mkdir /jmeter/server

# Set working directory
WORKDIR /jmeter/server

# Application to run on starting the container
ENTRYPOINT jmeter-server \
	-Dserver.rmi.localport=50000 \
	-Dserver_port=4000 \
	-Jserver.rmi.ssl.disable=true