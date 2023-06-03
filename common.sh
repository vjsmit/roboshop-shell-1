
log_file="/tmp/roboshop.log"

func_print_Head() {
  echo -e "\e[33m$1\e[0m"
}

func_nodejs() {
    func_print_head "Setup NodeJS repo"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

    func_print_head "Install NodeJS"
    yum install nodejs -y &>>${log_file}

    func_print_head "Add application User"
    useradd roboshop &>>${log_file}

    func_print_head "Setup an app directory"
    rm -rf /app
    mkdir /app &>>${log_file}

    func_print_head "Download the application code"
    curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
    cd /app
    unzip /tmp/catalogue.zip &>>${log_file}

    func_print_head "Download the dependencies"
    npm install &>>${log_file}

    func_print_head "Setup SystemD Catalogue Service"
    cp /home/centos/roboshop-shell-1/catalogue.service /etc/systemd/system/catalogue.service

    func_print_head "Load the service"
    systemctl daemon-reload &>>${log_file}

    func_print_head "Start the service"
    systemctl enable catalogue &>>${log_file}
    systemctl restart catalogue &>>${log_file}

}
