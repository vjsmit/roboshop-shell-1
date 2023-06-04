source common.sh

func_print_head "Setup a repo file"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log_file}

func_print_head "Enable redis 6.2 from package streams"
yum module enable redis:remi-6.2 -y &>>${log_file}

func_print_head "Install Redis"
yum install redis -y &>>${log_file}

func_print_head "Update redis listen address"
sed -i 's|127.0.0.1|0.0.0.0|' /etc/redis.conf &>>${log_file}
sed -i 's|127.0.0.1|0.0.0.0|' /etc/redis/redis.conf &>>${log_file}


func_print_head "Start the redis service"
systemctl enable redis &>>${log_file}
systemctl restart redis &>>${log_file}