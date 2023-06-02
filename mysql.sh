echo "\e[33mdisable MySQL 8\e[0m"
yum module disable mysql -y &>>/tmp/roboshop.log

echo "\e[33mSetup the MySQL5.7 repo file\e[0m"
yum install mysql-community-server -y &>>/tmp/roboshop.log

echo "\e[33mInstall MySQL Server\e[0m"
yum install mysql-community-server -y

echo "\e[33mStart MySQL Service\e[0m"
systemctl enable mysqld &>>/tmp/roboshop.log
systemctl restart mysqld &>>/tmp/roboshop.log

echo "\e[33mChange the default root password \e[0m"
mysql_secure_installation --set-root-pass RoboShop@1 &>>/tmp/roboshop.log

