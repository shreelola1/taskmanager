echo "start"
rm -rf endpoints/target/
rm -rf scheduler/target/
mvn clean install -Pweb
mvn clean install -Pscheduler

docker build -t webapp -f endpoints/Dockerfile .
docker build -t scheduler -f scheduler/Dockerfile .

docker-compose up


echo "web server is runnuing on http://localhost:8080"

