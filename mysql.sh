source common.sh


func_print_head "Disable MySQL 8"
yum module disable mysql -y &>>/tmp/roboshop.log

func_print_head "Setup the MySQL5.7 repo file"
cp /home/centos/roboshop-shell-1/mysql.repo /etc/yum.repos.d/mysql.repo &>>/tmp/roboshop.log

func_print_head "Install MySQL Server"
yum install mysql-community-server -y &>>/tmp/roboshop.log


func_print_head "Start MySQL Service"
systemctl enable mysqld &>>/tmp/roboshop.log
systemctl restart mysqld &>>/tmp/roboshop.log

func_print_head "Change the default root password "
mysql_secure_installation --set-root-pass RoboShop@1 &>>/tmp/roboshop.log

