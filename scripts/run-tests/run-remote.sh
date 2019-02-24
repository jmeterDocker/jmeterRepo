MasterUrl=10.10.30.57
SlaveUrlList="10.10.30.66"
SlaveProjectPath=Documents

JmeterMasterPath=/jmeter/master/project
JmeterApachePath=/jmeter/apache-jmeter-4.0/lib

# Start containers if they are stopped
docker start jmeter-master &&
docker start jmeter-slave

# Remove previous result files from master
rm -f log.jtl jmeter.log
docker exec -it jmeter-master bash -c "rm -f $JmeterMasterPath/log.jtl $JmeterMasterPath/jmeter.log"

# Prepare slaves - start containers if needed, clean logs and update files
# Also build string with list of url:port for jmeter command
for SlaveUrl in $SlaveUrlList
do
  ssh $SlaveUrl $SlaveProjectPath/before-run-slave.sh
  JmeterSlaves="$JmeterSlaves,$SlaveUrl:4000"
done

sed 's/.\(.*\)/\1/' $JmeterSlaves > /dev/null 2>&1

# Update jmeter project and libs on master
docker exec jmeter-master git -C $JmeterMasterPath pull
docker exec jmeter-master cp -R $JmeterMasterPath/jmeter-libs/. $JmeterApachePath

# Run jmeter tests
docker exec -it jmeter-master bash -c "cd $JmeterMasterPath; jmeter -n -t TestPlan.jmx -l log.jtl -R127.0.0.1:4000,$JmeterSlaves -Djava.rmi.server.hostname=$MasterUrl -Jserver.rmi.ssl.disable=true"

# Copy result files to host of docker container
docker cp jmeter-master:$JmeterMasterPath/log.jtl log.jtl
docker cp jmeter-master:$JmeterMasterPath/jmeter.log jmeter.log
