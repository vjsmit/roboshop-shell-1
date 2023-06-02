"\e[33mConfigure YUM Repos for erlang \e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>/tmp/roboshop.log

"\e[33m Configure YUM Repos for rabbitmq\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>/tmp/roboshop.log

"\e[33mInstall RabbitMQ \e[0m"
yum install rabbitmq-server -y &>>/tmp/roboshop.log

"\e[33mStart RabbitMQ Service \e[0m"
systemctl enable rabbitmq-server &>>/tmp/roboshop.log
systemctl restart rabbitmq-server &>>/tmp/roboshop.log

"\e[33m Create one user for the app and set permission\e[0m"
rabbitmqctl add_user roboshop roboshop123 &>>/tmp/roboshop.log
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>/tmp/roboshop.log