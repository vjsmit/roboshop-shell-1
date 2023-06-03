source common.sh

func_print_head "Installing Maven"
yum install maven -y &>>/tmp/roboshop.log

func_print_head "Add application User"
useradd roboshop &>>/tmp/roboshop.log

func_print_head "Setup an app directory"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app &>>/tmp/roboshop.log

func_print_head "Download the application code"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip &>>/tmp/roboshop.log
cd /app
unzip /tmp/shipping.zip &>>/tmp/roboshop.log

func_print_head "Download the dependencies & build the application"
mvn clean package &>>/tmp/roboshop.log
mv target/shipping-1.0.jar shipping.jar &>>/tmp/roboshop.log

func_print_head "Setup a Shipping service"
cp /home/centos/roboshop-shell-1/shipping.service /etc/systemd/system/shipping.service &>>/tmp/roboshop.log

func_print_head "Load the service"
systemctl daemon-reload &>>/tmp/roboshop.log

func_print_head "Start the service"
systemctl enable shipping &>>/tmp/roboshop.log
systemctl restart shipping &>>/tmp/roboshop.log

func_print_head "Install mysql client"
yum install mysql -y &>>/tmp/roboshop.log

func_print_head "Load Schema"
mysql -h mysql-dev.smitdevops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>/tmp/roboshop.log

func_print_head "Restart shipping service"
systemctl restart shipping &>>/tmp/roboshop.log