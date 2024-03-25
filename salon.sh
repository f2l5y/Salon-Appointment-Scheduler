#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?\n"

MAIN_MENU() {
if [[ $1 ]]
 then
   echo -e "\n$1"
 fi
 echo "$($PSQL "SELECT * FROM services;")" | while IFS='|' read ID SERVICE
  do
	  if [[ $SERVICE != "name" ]]
	  then
		  echo "$ID) $SERVICE"
          fi
  done
	read SERVICE_CHOICE
		case $SERVICE_CHOICE in
		1) SERVICE_ID_SELECTED=$SERVICE_CHOICE ;;
		2) SERVICE_ID_SELECTED=$SERVICE_CHOICE ;;
		3) SERVICE_ID_SELECTED=$SERVICE_CHOICE ;;
		4) SERVICE_ID_SELECTED=$SERVICE_CHOICE ;;
		5) SERVICE_ID_SELECTED=$SERVICE_CHOICE ;;
		*) MAIN_MENU "I could not find that service. What would you like today?" ;;
         	esac	

# get service name
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

# get the customer number
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE
RESULT_CUSTOMER_PHONE=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")

# if no customer number
if [[ -z $RESULT_CUSTOMER_PHONE ]] 
then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  # Ask for a name
  read CUSTOMER_NAME  

  # Create a customer entry
  $($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME');")

  # Ask for a time
  echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
  read SERVICE_TIME

  # insert the customer appointment and service
   #get customer_id
   CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'")
   
   #insert appointment data  
  RESULT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")

   #Communicate the data entered
   echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

else
   
  # Get customer name from DB customers
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")

# Get customer ID
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAMEa';")

  # Ask for a time
  echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
  read SERVICE_TIME

   
   #insert appointment data  
  RESULT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")

   #Communicate the data entered
   echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."

fi

}

MAIN_MENU
