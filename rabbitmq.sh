source common.sh

func_print_head "Configure YUM Repos for erlang"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${log_file}
stat_check $?

func_print_head "Configure YUM Repos for rabbitmq\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${log_file}
stat_check $?

func_print_head "Install RabbitMQ"
yum install rabbitmq-server -y &>>${log_file}
stat_check $?

func_print_head "Start RabbitMQ Service"
systemctl enable rabbitmq-server &>>${log_file}
systemctl restart rabbitmq-server &>>${log_file}
stat_check $?

func_print_head "Create one user for the app and set permission\e[0m"
rabbitmqctl add_user roboshop $1 &>>${log_file} &>>${log_file}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_file}
stat_check $?