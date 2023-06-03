source common.sh

func_print_head "Setup a repo file"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>/tmp/roboshop.log

func_print_head "Enable redis 6.2 from package streams"
yum module enable redis:remi-6.2 -y &>>/tmp/roboshop.log

func_print_head "Install Redis"
yum install redis -y &>>/tmp/roboshop.log

func_print_head "Update redis listen address"
sed -i 's|127.0.0.1|0.0.0.0|' /etc/redis.conf &>>/tmp/roboshop.log
sed -i 's|127.0.0.1|0.0.0.0|' /etc/redis/redis.conf &>>/tmp/roboshop.log


func_print_head "Start the redis service"
systemctl enable redis &>>/tmp/roboshop.log
systemctl restart redis &>>/tmp/roboshop.log