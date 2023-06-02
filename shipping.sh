echo -e "\e[33m Installing Maven\e[0m"
yum install maven -y &>>/tmp/roboshop.log

echo -e "\e[33mAdd application User \e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[33ms\Setup an app directory. \e[0m"
rm -rf /app &>>/tmp/roboshop.log
mkdir/app &>>/tmp/roboshop.log

echo -e "\e[33m Download the application code\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip &>>/tmp/roboshop.log
cd /app
unzip /tmp/shipping.zip &>>/tmp/roboshop.log

echo -e "\e[33mDownload the dependencies & build the application \e[0m"
mvn clean package &>>/tmp/roboshop.log
mv target/shipping-1.0.jar shipping.jar &>>/tmp/roboshop.log

echo -e "\e[33mSetup a Shipping service \e[0m"
cp /home/centos/roboshop-shell-1/shipping.service /etc/systemd/system/shipping.service &>>/tmp/roboshop.log

echo -e "\e[33mLoad the service \e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log

echo -e "\e[33mStart the service \e[0m"
systemctl enable shipping &>>/tmp/roboshop.log
systemctl restart shipping &>>/tmp/roboshop.log

echo -e "\e[33mInstall mysql client. \e[0m"
yum install mysql -y &>>/tmp/roboshop.log

echo -e "\e[33m Load Schema\e[0m"
mysql -h mysql-dev.smitdevops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>/tmp/roboshop.log

echo -e "\e[33mRestart shipping service \e[0m"
systemctl restart shipping &>>/tmp/roboshop.log