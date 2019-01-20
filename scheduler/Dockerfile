FROM openjdk:8-jre-alpine
WORKDIR /app
ADD scheduler/target/scheduler-0.1-SNAPSHOT.jar /app/scheduler.jar
#RUN sh -c 'touch /app/app.jar'
EXPOSE 9090
ENV JAVA_OPTS=""
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app/scheduler.jar" ]

