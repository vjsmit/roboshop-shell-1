echo -e "\e[33mSetup NodeJS repo\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log

echo -e "\e[33mInstall NodeJS\e[0m"
yum install nodejs -y &>>/tmp/roboshop.log

echo -e "\e[33mAdd application cart\e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[33mSetup an app directory\e[0m"
rm -rf /app
mkdir /app &>>/tmp/roboshop.log

echo -e "\e[33mDownload the application code\e[0m"
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip &>>/tmp/roboshop.log
cd /app
unzip /tmp/cart.zip &>>/tmp/roboshop.log

echo -e "\e[33mDownload the dependencies\e[0m"
npm install &>>/tmp/roboshop.log

echo -e "\e[33mSetup SystemD cart Service\e[0m"
cp /home/centos/roboshop-shell-1/cart.service /etc/systemd/system/cart.service

echo -e "\e[33mLoad the service\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log

echo -e "\e[33mStart the service\e[0m"
systemctl enable cart &>>/tmp/roboshop.log
systemctl restart cart &>>/tmp/roboshop.log