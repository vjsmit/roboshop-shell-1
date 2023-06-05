source common.sh

func_print_head "Installing Nginx"
yum install nginx -y &>>${log_file}
stat_check $?

func_print_head "Removing default content"
rm -rf /usr/share/nginx/html/*
stat_check $?

func_print_head "Download the frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
stat_check $?

func_print_head "Extract the frontend content"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}
stat_check $?

func_print_head "Create Nginx Reverse Proxy Configuration"
cp /home/centos/roboshop-shell-1/roboshop.conf /etc/nginx/default.d/roboshop.conf
stat_check $?

func_print_head "Start Nginx Server"
systemctl enable nginx &>>${log_file}
systemctl restart nginx &>>${log_file}
stat_check $?