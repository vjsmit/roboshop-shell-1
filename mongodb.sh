source common.sh
func_print_head "Copy mongodb repo file"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log

func_print_head "Install mongodb"
yum install mongodb-org -y &>>/tmp/roboshop.log

func_print_head "Update listen address"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>/tmp/roboshop.log

func_print_head "start the service"
systemctl enable mongod &>>/tmp/roboshop.log
systemctl restart mongod &>>/tmp/roboshop.log