source common.sh
component="catalogue"
func_nodejs

echo -e "\e[33mSetup MongoDB repo\e[0m"
cp /home/centos/roboshop-shell-1/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[33mInstall mongoDB client\e[0m"
yum install mongodb-org-shell -y &>>/tmp/roboshop.log

echo -e "\e[33mLoad Schema\e[0m"
mongo --host mongodb-dev.smitdevops.online </app/schema/catalogue.js &>>/tmp/roboshop.log