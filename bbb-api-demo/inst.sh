#Steps

echo build
gradle resolveDeps 
gradle build

echo remove
sudo rm -rf /var/lib/tomcat7/webapps/demo*


echo copy
sudo cp build/libs/demo.war /var/lib/tomcat7/webapps/

echo restart
sudo systemctl restart tomcat7

echo ok