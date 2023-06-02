echo -e "\e[33mSetup NodeJS repo\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log

echo -e "\e[33mInstall NodeJS\e[0m"
yum install nodejs -y &>>/tmp/roboshop.log

echo -e "\e[33mAdd application User\e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[33mSetup an app directory\e[0m"
rm -rf /app
mkdir /app &>>/tmp/roboshop.log

echo -e "\e[33mDownload the application code\e[0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>/tmp/roboshop.log
cd /app
unzip /tmp/user.zip &>>/tmp/roboshop.log

echo -e "\e[33mDownload the dependencies\e[0m"
npm install &>>/tmp/roboshop.log

echo -e "\e[33mSetup SystemD user Service\e[0m"
cp /home/centos/roboshop-shell-1/user.service /etc/systemd/system/user.service

echo -e "\e[33mLoad the service\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log

echo -e "\e[33mStart the service\e[0m"
systemctl enable user &>>/tmp/roboshop.log
systemctl restart user &>>/tmp/roboshop.log

echo -e "\e[33mSetup MongoDB repo\e[0m"
cp /home/centos/roboshop-shell-1/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[33mInstall mongoDB client\e[0m"
yum install mongodb-org-shell -y &>>/tmp/roboshop.log

echo -e "\e[33mLoad Schema\e[0m"
mongo --host mongodb-dev.smitdevops.online </app/schema/user.js &>>/tmp/roboshop.log