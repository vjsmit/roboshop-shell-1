"\e[33mInstall GoLang \e[0m"
yum install golang -y &>>/tmp/roboshop.log

"\e[33mAdd App User \e[0m"
useradd roboshop &>>/tmp/roboshop.log

"\e[33mCreate App dir \e[0m"
rm -rf /app
mkdir /app &>>/tmp/roboshop.log

"\e[33mDownload the app code \e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip &>>/tmp/roboshop.log
cd /app
unzip /tmp/dispatch.zip &>>/tmp/roboshop.log

"\e[33mDownload the dependencies & build the software \e[0m"
go mod init dispatch &>>/tmp/roboshop.log
go get &>>/tmp/roboshop.log
go build &>>/tmp/roboshop.log

"\e[33mSetup dispatch service \e[0m"
cp /home/centos/roboshop-shell-1/dispatch.service /etc/systemd/system/dispatch.service &>>/tmp/roboshop.log

"\e[33mLoad the service \e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log

"\e[33mStart the service \e[0m"
systemctl enable dispatch &>>/tmp/roboshop.log
systemctl restart dispatch &>>/tmp/roboshop.log

