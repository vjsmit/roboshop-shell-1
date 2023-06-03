source common.sh

func_print_head "Installing Nginx"
yum install nginx -y &>>/tmp/roboshop.log

func_print_head "Removing default content"
rm -rf /usr/share/nginx/html/*

func_print_head "Download the frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>/tmp/roboshop.log

func_print_head "Extract the frontend content."
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>/tmp/roboshop.log

#Create Nginx Reverse Proxy Configuration.
cp /home/centos/roboshop-shell-1/roboshop.conf /etc/nginx/default.d/roboshop.conf

func_print_head "Start Nginx Server"
systemctl enable nginx &>>/tmp/roboshop.log
systemctl restart nginx &>>/tmp/roboshop.log