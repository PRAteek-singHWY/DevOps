FROM eclipse-temurin:21-jdk

WORKDIR /opt/app

COPY Main.java .
RUN javac Main.java

EXPOSE 8080

CMD ["java", "Main"]
