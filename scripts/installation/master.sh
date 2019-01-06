rm -rf jmeterRepo
git clone https://github.com/jmeterDocker/jmeterRepo.git

# Clean up previous runs
docker kill $(docker ps -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)
docker volume rm -f $(docker volume ls -q)

# Prepare volumes and create containers
docker volume create jmeter-libs
docker volume create jmeter-project
docker build -t jmeter-parent jmeterRepo/dockerProj/docker-parent/
docker build -t jmeter-master jmeterRepo/dockerProj/docker-master/

# Run jmeter-master container
docker run -d --network host --mount source=jmeter-project,target=/jmeter/master/project --mount source=jmeter-libs,target=/jmeter/apache-jmeter-4.0/lib --name jmeter-master -t jmeter-master

# Prepare jmeter project and libs
docker exec jmeter-master git clone https://github.com/jmeterDocker/jmeterRepo.git -b master /jmeter/master/project
docker exec jmeter-master cp -r /jmeter/master/project/jmeter-libs/. /jmeter/apache-jmeter-4.0/lib