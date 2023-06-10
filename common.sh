log_file="/tmp/roboshop.log"
app_path="/app"
rm -rf ${log_file}
user_id=$(id -u)
if [ ${user_id} -ne 0 ]; then
    echo Script should run as sudo user
    exit 1
fi

func_print_head() {
  echo -e "\e[32m$1\e[0m"
  echo -e "\e[31m$1\e[0m" &>>${log_file}
}
stat_check() {
  if [ $1 -eq 0 ]; then
     echo SUCCESS
  else
     echo FAILURE
     exit 1
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
# shellcheck disable=SC2120
service_start(){
    func_print_head "Setup SystemD Service"
    cp /home/centos/roboshop-shell-1/${component}.service /etc/systemd/system/${component}.service
    sed -i "s|roboshop_app_pwd|${roboshop_app_pwd}|" /etc/systemd/system/${component}.service
    stat_check $?

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
    service_start
}

mongo_schema_setup() {
  func_print_head "Setup MongoDB repo"
  cp /home/centos/roboshop-shell-1/mongo.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
  stat_check $?

  func_print_head "Install mongoDB client"
  yum install mongodb-org-shell -y &>>${log_file}
  stat_check $?

  func_print_head "Load Schema"
  mongo --host mongodb-dev.smitdevops.online <${app_path}/schema/${component}.js &>>${log_file}
  stat_check $?
}

mysql_schema_setup() {
    func_print_head "Install mysql client"
    yum install mysql -y &>>${log_file}
    stat_check $?

    func_print_head "Load Schema"
    mysql -h mysql-dev.smitdevops.online -uroot -p${mysql_pwd} < ${app_path}/schema/${component}.sql &>>${log_file}
    stat_check $?
}
maven() {
    func_print_head "Installing Maven"
    yum install maven -y &>>${log_file}
    stat_check $?

    app_prereq
    func_print_head "Download the dependencies & build the application"
    mvn clean package &>>${log_file}
    mv target/${component}-1.0.jar ${component}.jar &>>${log_file}
    stat_check $?

    mysql_schema_setup
    service_start

}

python() {
    func_print_head "Install Python 3.6"
    yum install python36 gcc python3-devel -y &>>${log_file}
    stat_check $?
    
    app_prereq
    
    func_print_head "Download dependencies"
    pip3.6 install -r requirements.txt &>>${log_file}
    service_start
}

golang() {
  func_print_head "Install GoLang"
  yum install golang -y &>>${log_file}
  stat_check $?
  
  app_prereq
  
  func_print_head "Download the dependencies & build the software"
  go mod init ${component} &>>${log_file}
  go get &>>${log_file}
  go build &>>${log_file}
  stat_check $?
  service_start
}