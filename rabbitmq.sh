source common.sh

func_print_head "Configure YUM Repos for erlang"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>/tmp/roboshop.log

func_print_head "Configure YUM Repos for rabbitmq\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>/tmp/roboshop.log

func_print_head "Install RabbitMQ"
yum install rabbitmq-server -y &>>/tmp/roboshop.log

func_print_head "Start RabbitMQ Service"
systemctl enable rabbitmq-server &>>/tmp/roboshop.log
systemctl restart rabbitmq-server &>>/tmp/roboshop.log

func_print_head "Create one user for the app and set permission\e[0m"
rabbitmqctl add_user roboshop roboshop123 &>>/tmp/roboshop.log &>>/tmp/roboshop.log
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>/tmp/roboshop.log