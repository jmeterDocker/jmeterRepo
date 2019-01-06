rm -rf jmeterRepo
git clone https://github.com/jmeterDocker/jmeterRepo.git

# Clean up previous runs
docker kill $(docker ps -q)
docker rm $(docker ps -a -q)
#docker rmi $(docker images -q)
docker volume rm -f $(docker volume ls -q)

# Prepare volumes and create containers
docker volume create jmeter-libs
docker volume create jmeter-project
docker build -t jmeter-parent jmeterRepo/dockerProj/docker-parent/
docker build -t jmeter-slave jmeterRepo/dockerProj/docker-slave/

# Run jmeter-slave container
#docker run -d --network host --mount source=jmeter-project,target=/jmeter/server/project --mount source=jmeter-libs,target=/jmeter/apache-jmeter-4.0/lib --name jmeter-slave -t jmeter-slave -e jmeter_server_port=4001 -e jmeter_rmi_port=50000
docker run -d --network host --mount source=jmeter-project,target=/jmeter/server/project --mount source=jmeter-libs,target=/jmeter/apache-jmeter-4.0/lib --name jmeter-slave -t jmeter-slave

# Prepare jmeter project and libs
docker exec jmeter-slave git clone https://github.com/jmeterDocker/jmeterRepo.git -b master /jmeter/server/project
docker exec jmeter-slave cp -r /jmeter/server/project/jmeter-libs/. /jmeter/apache-jmeter-4.0/lib