#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"
MAIN_MENU() {
if [[ $1 ]]
then
echo -e "\n$1"
fi  
echo -e "1) Buzz cut\n2) Cut & style\n3) Colour\n4) Wash & blowdry"
read SERVICE_ID_SELECTED
case $SERVICE_ID_SELECTED in
  1) ;;
  2) ;;
  3) ;;
  4) ;;
  *) MAIN_MENU "I could not find that service. What would you like today?" ;;
esac
SERVICE_INFO=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
SERVICE_INFO_FORMATTED=$(echo $SERVICE_INFO | sed 's/ |/"/')
}
MAIN_MENU
#get customer info
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
#if customer doesn't exist
if [[ -z $CUSTOMER_NAME ]]
then
# get new customer name
echo -e "\nI don't have a record for that phone number, what's your name?"
read CUSTOMER_NAME
#insert new customer
INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (phone,name) VALUES ('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
fi
#get appointment time
echo -e "\nWhat time would you like your $SERVICE_INFO_FORMATTED, $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')?"
read SERVICE_TIME
# get customer_id
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
# insert appointment
INSERT_SERVICE_ID=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")
# get appointment info
echo -e "\nI have put you down for a $SERVICE_INFO_FORMATTED at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g').\n"
