FROM openjdk:8-jre-alpine
WORKDIR /app
ADD endpoints/target/endpoints-0.1-SNAPSHOT.jar /app/webapp.jar
EXPOSE 8080
ENV JAVA_OPTS=""
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app/webapp.jar" ]

