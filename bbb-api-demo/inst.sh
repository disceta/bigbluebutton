#Steps:
gradle resolveDeps 

gradle build


sudo rm -rf /var/lib/tomcat7/webapps/demo*


sudo cp build/libs/demo.war /var/lib/tomcat7/webapps/


sudo systemctl restart tomcat7




