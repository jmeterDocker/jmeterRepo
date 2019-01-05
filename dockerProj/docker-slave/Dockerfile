FROM jmeter-parent:latest

ENV jmeter_server_port=4000
ENV jmeter_rmi_port=50000

# Create folder where jmeter-server will be run
RUN mkdir /jmeter/server

# Set working directory
WORKDIR /jmeter/server

# Application to run on starting the container
ENTRYPOINT jmeter-server \
	-Dserver.rmi.localport=$jmeter_rmi_port \
	-Dserver_port=$jmeter_server_port \
	-Jserver.rmi.ssl.disable=true