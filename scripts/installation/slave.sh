JmeterServerPath=/jmeter/server/project
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
docker build -t jmeter-slave jmeterRepo/dockerProj/docker-slave/

# Run jmeter-slave container
docker run -d --network host --mount source=jmeter-project,target=$JmeterServerPath --mount source=jmeter-libs,target=$JmeterApachePath --name jmeter-slave -t jmeter-slave

# Prepare jmeter project and libs
docker exec jmeter-slave git clone $JmeterRepoURL -b master $JmeterServerPath
docker exec jmeter-slave cp -r $JmeterServerPath/jmeter-libs/. $JmeterApachePath

# Copy file and grant permission
cp jmeterRepo/scripts/before-run/before-run-slave.sh
chmod u+x before-run-slave.sh