# Use the official Tomcat image as the base image for the runtime
FROM tomcat:9.0-jdk11

# Remove default webapps from Tomcat to avoid conflicts
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built war file into the Tomcat webapps directory
#COPY --from=build /app/target/manik-calculator-*.war /usr/local/tomcat/webapps/ROOT.war
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]

