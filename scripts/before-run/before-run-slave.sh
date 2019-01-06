# Start container if it is stopped
docker start jmeter-slave

# Update jmeter project and libs
docker exec jmeter-slave git -C /jmeter/server/project pull
docker exec jmeter-slave cp -R /jmeter/server/project/jmeter-libs/. /jmeter/apache-jmeter-4.0/lib