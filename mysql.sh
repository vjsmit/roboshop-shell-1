source common.sh
mysql_pwd=$1

func_print_head "Disable MySQL 8"
yum module disable mysql -y &>>${log_file}

func_print_head "Setup the MySQL5.7 repo file"
cp /home/centos/roboshop-shell-1/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}

func_print_head "Install MySQL Server"
yum install mysql-community-server -y &>>${log_file}


func_print_head "Start MySQL Service"
systemctl enable mysqld &>>${log_file}
systemctl restart mysqld &>>${log_file}

func_print_head "Change the default root password "
mysql_secure_installation --set-root-pass ${mysql_pwd} &>>${log_file}

