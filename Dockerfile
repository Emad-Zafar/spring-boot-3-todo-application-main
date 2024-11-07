# Use the Java 17 JDK Alpine image for the build stage
FROM openjdk:17-jdk-alpine AS build

# Set the working directory
WORKDIR /workspace/app

# Copy necessary files
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

# Make mvnw executable and build the project
RUN chmod +x mvnw
RUN ./mvnw install

# Use the Java 17 JDK Alpine image for the runtime stage
FROM openjdk:17-jdk-alpine

# Argument to specify the JAR file location
ARG JAR_FILE=/workspace/app/target/*.jar

# Copy the JAR file from the build stage
COPY --from=build ${JAR_FILE} web-server.jar

# Expose port 8080
EXPOSE 8080

# Set the entry point to run the JAR file
ENTRYPOINT ["java", "-jar", "/web-server.jar"]
