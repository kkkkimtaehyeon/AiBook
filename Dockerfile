FROM eclipse-temurin:21
WORKDIR /app
COPY build/libs/aibook-latest.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]