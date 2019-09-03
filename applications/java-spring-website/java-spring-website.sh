#!/usr/bin/env bash

# Stop Script on Error
set -e

# For Debugging (print env. variables into a file)  
printenv > /var/log/colony-vars-"$(basename "$BASH_SOURCE" .sh)".txt

# Update packages and Upgrade system
echo "****************************************************************"
echo "Updating System"
echo "****************************************************************"
apt-get update -y


echo "****************************************************************"
echo "Installing Java"
echo "****************************************************************"
apt-get install default-jdk -y



echo "****************************************************************"
echo "Installing Tomcat"
echo "****************************************************************"
apt-get install tomcat8 -y
apt-get install tomcat8-admin -y

#echo "****************************************************************"
#echo "Get the web application from github"
#echo "****************************************************************"
#mkdir /home/artifacts
#cd /home/artifacts || exit
#git clone https://github.com/cloudshell-colony/sample_java_spring_source.git
#

echo "****************************************************************"
echo "Prepare the environment configuration file that will be consumed by the servlet"
echo "****************************************************************"
mkdir /home/user/.config/colony-java-spring-sample -p
bash -c "cat >> /home/user/.config/colony-java-spring-sample/app.properties" <<EOL
# Dadabase connection settings:
if [ $DB_HOSTNAME == "none" ]; then
    jdbc.url=jdbc:mysql://mysql.$DOMAIN_NAME:3306/$DB_NAME
else
    jdbc.url=jdbc:mysql://$DB_HOSTNAME/$DB_NAME
fi

jdbc.username=$DB_USER
jdbc.password=$DB_PASS
EOL


echo "****************************************************************"
echo "Deploy to TomCat"
echo "****************************************************************"
#remove the tomcat default ROOT web application
rm -rf /var/lib/tomcat8/webapps/ROOT

# deploy the application as the ROOT web application
cp $ARTIFACTS_PATH/colony-java-spring-sample*.war /var/lib/tomcat8/webapps/ROOT.war

systemctl start tomcat8


