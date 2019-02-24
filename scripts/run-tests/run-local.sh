MasterUrl=10.10.30.57

JmeterMasterPath=/jmeter/master/project
JmeterApachePath=/jmeter/apache-jmeter-4.0/lib

# Start containers if they are stopped
docker start jmeter-master &&
docker start jmeter-slave

# Remove previous result files
rm -f log.jtl jmeter.log
docker exec -it jmeter-master bash -c "rm -f $JmeterMasterPath/log.jtl $JmeterMasterPath/jmeter.log"

# Update jmeter project and libs
docker exec jmeter-master git -C $JmeterMasterPath pull
docker exec jmeter-master cp -R $JmeterMasterPath/jmeter-libs/. $JmeterApachePath

# Run jmeter tests
docker exec -it jmeter-master bash -c "cd $JmeterMasterPath; jmeter -n -t TestPlan.jmx -l log.jtl -Djava.rmi.server.hostname=$MasterUrl -Jserver.rmi.ssl.disable=true"

# Copy result files to host of docker container
docker cp jmeter-master:$JmeterMasterPath/log.jtl log.jtl
docker cp jmeter-master:$JmeterMasterPath/jmeter.log jmeter.log