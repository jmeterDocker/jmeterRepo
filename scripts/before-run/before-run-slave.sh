JmeterServerPath=/jmeter/server/project
JmeterApachePath=/jmeter/apache-jmeter-4.0/lib

# Start container if it is stopped
docker start jmeter-slave

# Remove previous result files from slave
docker exec -it jmeter-slave bash -c "rm -f $JmeterServerPath/log.jtl $JmeterServerPath/jmeter.log"

# Update jmeter project and libs
docker exec jmeter-slave git -C $JmeterServerPath pull
docker exec jmeter-slave cp -R $JmeterServerPath/jmeter-libs/. $JmeterApachePath
