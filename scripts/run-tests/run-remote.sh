# Remove previous result files from master
rm -f log.jtl jmeter.log
docker exec -it jmeter-master bash -c 'rm -f /jmeter/master/project/log.jtl /jmeter/master/project/jmeter.log'

# Update jmeter project and libs
docker exec jmeter-master git -C /jmeter/master/project pull
docker exec jmeter-master cp -R /jmeter/master/project/jmeter-libs/. /jmeter/apache-jmeter-4.0/lib

# Run jmeter tests
docker exec -it jmeter-master bash -c 'cd /jmeter/master/project; jmeter -n -t TestPlan.jmx -l log.jtl -R127.0.0.1:4000,10.10.30.72:4000 -Djava.rmi.server.hostname=10.10.30.56 -Jserver.rmi.ssl.disable=true'

# Copy result files to host of docker container
docker cp jmeter-master:/jmeter/master/project/log.jtl log.jtl
docker cp jmeter-master:/jmeter/master/project/jmeter.log jmeter.log
