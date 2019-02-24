JmeterMasterPath=/jmeter/master/project
JmeterApachePath=/jmeter/apache-jmeter-4.0/lib
JmeterRepoURL=https://github.com/jmeterDocker/jmeterRepo.git

# Download installation files
rm -rf jmeterRepo
git clone $JmeterRepoURL

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
docker run -d --network host --mount source=jmeter-project,target=$JmeterMasterPath --mount source=jmeter-libs,target=$JmeterApachePath --name jmeter-master -t jmeter-master

# Prepare jmeter project and libs
docker exec jmeter-master git clone $JmeterRepoURL -b master /jmeter/master/project
docker exec jmeter-master cp -r $JmeterMasterPath/jmeter-libs/. $JmeterApachePath

# Copy files and grant permission
cp jmeterRepo/scripts/run-tests/* .
chmod u+x run-*