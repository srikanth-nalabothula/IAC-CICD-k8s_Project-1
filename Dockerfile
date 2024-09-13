# Stage 1: Build the application
FROM maven:3.8.7-eclipse-temurin-17 AS build

# Set the working directory in the build container
WORKDIR /app

# Copy the local Maven repository to the container
COPY m2 /root/.m2

# Copy the pom.xml and any other necessary build files to the build container
COPY pom.xml .

# Download the project dependencies (this will be cached unless pom.xml changes)
# RUN mvn dependency:go-offline

# Copy the source code into the build container
COPY src ./src

# Build the application and package it as a jar
RUN mvn clean package -DskipTests

# Stage 2: Create the final runtime image
FROM openjdk:17-jdk-alpine

# Set the working directory in the runtime container
WORKDIR /app

# Copy the jar file from the build stage
COPY --from=build /app/target/*.jar /app/*.jar

# Expose the application's port
EXPOSE 8080

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "/app/*.jar"]
