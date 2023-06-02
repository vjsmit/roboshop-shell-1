echo -e "\e[33mSetup a repo file\e[0m"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>/tmp/roboshop.log

echo -e "\e[33mEnable redis 6.2 from package streams\e[0m"
yum module enable redis:remi-6.2 -y &>>/tmp/roboshop.log

echo -e "\e[33mInstall Redis\e[0m"
yum install redis -y &>>/tmp/roboshop.log

echo -e "\e[33mUpdate redis listen address\e[0m"
sed -i 's|127.0.0.1|0.0.0.0| /etc/redis.conf' &>>/tmp/roboshop.log

echo -e "\e[33mStart the redis service\e[0m"
systemctl enable redis &>>/tmp/roboshop.log
systemctl start redis &>>/tmp/roboshop.log