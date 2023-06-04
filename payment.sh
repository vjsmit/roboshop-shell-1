source common.sh
component="payment"
roboshop_app_pwd=$1
if [ -z "$roboshop_app_pwd" ]; then
  echo roboshop app password missing
  exit 1
fi
python

