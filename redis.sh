yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>/tmp/roboshop.log

yum module enable redis:remi-6.2 -y &>>/tmp/roboshop.log

yum install redis -y &>>/tmp/roboshop.log

sed -i 's|127.0.0.1|0.0.0.0| /etc/redis.conf' &>>/tmp/roboshop.log

systemctl enable redis &>>/tmp/roboshop.log
systemctl start redis &>>/tmp/roboshop.log