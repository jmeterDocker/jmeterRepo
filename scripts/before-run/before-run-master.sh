# Start container if it is stopped
docker start jmeter-master

# Update jmeter project and libs
docker exec jmeter-master git -C /jmeter/master/project pull
docker exec jmeter-master cp -R /jmeter/master/project/jmeter-libs/. /jmeter/apache-jmeter-4.0/lib