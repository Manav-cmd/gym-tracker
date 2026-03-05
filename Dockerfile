FROM tomcat:11-jdk17

COPY target/gym-tracker.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["catalina.sh", "run"]
