#!/bin/bash

# .platforms/ci/
docker pull maven:3.8.5-openjdk-17
docker pull openjdk:17.0.2-slim
docker pull mariadb:10.6.13
docker pull adminer:4.8.1
docker pull sonarsource/sonar-scanner-cli:4.8.1
docker pull owasp/zap2docker-stable:2.14.0

# .platforms/tools/
docker pull jenkins/jenkins:2.433-jdk17
docker pull sonarqube:10.3.0-community
docker pull postgres:13.4
docker pull sonatype/nexus3:3.62.0
