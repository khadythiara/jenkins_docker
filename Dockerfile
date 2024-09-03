# Étape 1 : Utiliser une image Maven pour compiler l'application
FROM maven:3.9.9-eclipse-temurin-17 AS build

# Copier le code source dans l'image
COPY src /usr/src/app/src
COPY pom.xml /usr/src/app

# Se placer dans le répertoire de l'application
WORKDIR /usr/src/app

# Compiler l'application et créer le fichier JAR
RUN mvn clean package

# Étape 2 : Utiliser une image JDK légère pour exécuter l'application
FROM openjdk:17-jdk-slim

# Copier le JAR compilé de l'étape précédente
COPY --from=build /usr/src/app/target/*.war /usr/app/app.war

# Exposer le port de l'application
EXPOSE 8080

# Commande pour exécuter l'application
CMD ["java", "-jar", "/usr/app/app.jar"]
