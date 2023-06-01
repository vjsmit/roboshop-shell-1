echo -e "\e[32mCopy mongodb repo file\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log

echo -e "\e[32mInstall mongodb\e[0m"
yum install mongodb-org -y &>>/tmp/roboshop.log

echo -e "\e[32mUpdate listen address\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>/tmp/roboshop.log

echo -e "\e[32mstart the service\e[0m"
systemctl enable mongod &>>/tmp/roboshop.log
systemctl restart mongod &>>/tmp/roboshop.log