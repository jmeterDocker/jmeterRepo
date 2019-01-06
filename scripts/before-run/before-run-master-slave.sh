# Start containers if they are stopped
docker start jmeter-master &&
docker start jmeter-slave

# Update jmeter project and libs
docker exec jmeter-master git -C /jmeter/master/project pull
docker exec jmeter-master cp -R /jmeter/master/project/jmeter-libs/. /jmeter/apache-jmeter-4.0/lib