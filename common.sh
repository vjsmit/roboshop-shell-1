log_file="/tmp/roboshop.log"
app_path="/app"
rm -rf ${log_file}

func_print_head() {
  echo -e "\e[32m$1\e[0m"
  echo -e "\e[31m$1\e[0m" &>>${log_file}
}
stat_check() {
  if [ $1 -eq 0 ]; then
     echo SUCCESS
  else
     echo FAILURE
   fi
}

app_prereq() {
    func_print_head "Add application User"
    id roboshop &>>${log_file}
    if [ $? -ne 0 ]; then
        useradd roboshop &>>${log_file}
    fi
    stat_check $?

    func_print_head "Setup an app directory"
    rm -rf ${app_path}
    mkdir ${app_path} &>>${log_file}
    stat_check $?

    func_print_head "Download the application code"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
    cd ${app_path}
    unzip /tmp/${component}.zip &>>${log_file}
    stat_check $?
}

service_start(){
    func_print_head "Load the service"
    systemctl daemon-reload &>>${log_file}
    stat_check $?

    func_print_head "Start the service"
    systemctl enable ${component} &>>${log_file}
    systemctl restart ${component} &>>${log_file}
    stat_check $?
}

func_nodejs() {
    func_print_head "Setup NodeJS repo"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
    stat_check $?

    func_print_head "Install NodeJS"
    yum install nodejs -y &>>${log_file}
    stat_check $?

    app_prereq

    func_print_head "Download the dependencies"
    npm install &>>${log_file}
    stat_check $?

    func_print_head "Setup SystemD Catalogue Service"
    cp /home/centos/roboshop-shell-1/${component}.service /etc/systemd/system/${component}.service
    stat_check $?

    service_start
}

mongo_schema_setup() {
  func_print_head "Setup MongoDB repo"
  cp /home/centos/roboshop-shell-1/mongo.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

  func_print_head "Install mongoDB client"
  yum install mongodb-org-shell -y &>>${log_file}

  func_print_head "Load Schema"
  mongo --host mongodb-dev.smitdevops.online <${app_path}/schema/${component}.js &>>${log_file}
}

mysql_schema_setup() {
    func_print_head "Install mysql client"
    yum install mysql -y &>>${log_file}

    func_print_head "Load Schema"
    mysql -h mysql-dev.smitdevops.online -uroot -pRoboShop@1 < ${app_path}/schema/${component}.sql &>>${log_file}

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
    service_start
    mysql_schema_setup
}

python() {
    func_print_head "Install Python 3.6"
    yum install python36 gcc python3-devel -y &>>${log_file}
    
    app_prereq
    
    func_print_head "Download dependencies"
    pip3.6 install -r requirements.txt &>>${log_file}
    
    func_print_head "Setup ${component} service"
    cp /home/centos/roboshop-shell-1/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
    
    service_start
}

golang() {
  echo -e "\e[33mInstall GoLang \e[0m"
  yum install golang -y &>>${log_file}
  
  app_prereq
  
  echo -e "\e[33mDownload the dependencies & build the software \e[0m"
  go mod init ${component} &>>${log_file}
  go get &>>${log_file}
  go build &>>${log_file}
  
  echo -e "\e[33mSetup ${component} service \e[0m"
  cp /home/centos/roboshop-shell-1/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
  
  service_start
}