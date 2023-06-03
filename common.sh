
log_file="${log_file}"

func_print_head() {
  echo -e "\e[33m$1\e[0m"
}

app_prereq(){
    func_print_head "Add application User"
    useradd roboshop &>>${log_file}

    func_print_head "Setup an app directory"
    rm -rf /app
    mkdir /app &>>${log_file}

    func_print_head "Download the application code"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
    cd /app
    unzip /tmp/${component}.zip &>>${log_file}
}

service_setup(){
    func_print_head "Load the service"
    systemctl daemon-reload &>>${log_file}

    func_print_head "Start the service"
    systemctl enable ${component} &>>${log_file}
    systemctl restart ${component} &>>${log_file}
}
func_nodejs() {
    func_print_head "Setup NodeJS repo"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

    func_print_head "Install NodeJS"
    yum install nodejs -y &>>${log_file}

    app_prereq

    func_print_head "Download the dependencies"
    npm install &>>${log_file}

    func_print_head "Setup SystemD Catalogue Service"
    cp /home/centos/roboshop-shell-1/${component}.service /etc/systemd/system/${component}.service

    service_setup
}

mongo_schema_setup() {
  func_print_head "Setup MongoDB repo"
  cp /home/centos/roboshop-shell-1/mongo.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

  func_print_head "Install mongoDB client"
  yum install mongodb-org-shell -y &>>${log_file}

  func_print_head "Load Schema"
  mongo --host mongodb-dev.smitdevops.online </app/schema/${component}.js &>>${log_file}
}

mysql_schema_setup() {
    func_print_head "Install mysql client"
    yum install mysql -y &>>${log_file}

    func_print_head "Load Schema"
    mysql -h mysql-dev.smitdevops.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log_file}

    func_print_head "Restart ${component} service"
    systemctl restart ${component} &>>${log_file}
}
maven() {
    func_print_head "Installing Maven"
    yum install maven -y &>>${log_file}

    app_prereq
    func_print_head "Download the dependencies & build the application"
    mvn clean package &>>${log_file}
    mv target/${component}-1.0.jar ${component}.jar &>>${log_file}

    func_print_head "Setup a Shipping service"
    cp /home/centos/roboshop-shell-1/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
    service_setup
    mysql_schema_setup
}