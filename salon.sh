#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?\n"

MAIN_FUNCTION() {

#echo -e "1) cut\n2) color\n3) perm\n4) style\n5) trim"

MAIN_MENU

# get service name
SERVICE_ID_SELECTED2=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_NAME_SELECTED")

SERVICE_ID_SELECTED2=$(echo $SERVICE_ID_SELECTED2 | sed -r 's/^ *| *$//g')

#if a valid id has been selected, run the program
if [[ -n $SERVICE_ID_SELECTED2 ]]
then

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
  RESULT_INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME');")


  # Ask for a time
  echo -e "\nWhat time would you like your cut, $(echo $CUSTOMER_NAME | sed    -r 's/^ *| *$//g')?"
  read SERVICE_TIME

  # insert the customer appointment and service
   #get customer_id
   CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'")
   
   #insert appointment data  
RESULT_INSERT_APP1=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_NAME_SELECTED,'$SERVICE_TIME')")

   #Communicate the data entered
   echo -e "\nI have put you down for a $SERVICE_ID_SELECTED2 at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed    -r 's/^ *| *$//g')."

else
   
  # Get customer name from DB customers
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")

# Get customer ID
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")

  # Ask for a time
  echo -e "\nWhat time would you like your cut, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')?"
  read SERVICE_TIME

  #insert appointment data  
RESULT_INSERT_APP2=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_NAME_SELECTED,'$SERVICE_TIME');")

   #Communicate the data entered
   echo -e "\nI have put you down for a $SERVICE_ID_SELECTED2 at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
fi
fi
}
MAIN_MENU() {
if [[ $1 ]]
 then
   echo -e "\n$1"
 fi
 echo "$($PSQL "SELECT * FROM services;")" | while IFS='|' read ID SERVICE
  do
	  if [[ $SERVICE != "name" ]]
	  then
		  echo "$(echo $ID | sed -r 's/^ *| *$//g')) $(echo $SERVICE | sed -r 's/^ *| *$//g')"
          fi
  done
	read SERVICE_ID_SELECTED
		case $SERVICE_ID_SELECTED in
		1) SERVICE_NAME_SELECTED=$SERVICE_ID_SELECTED ;;
		2) SERVICE_NAME_SELECTED=$SERVICE_ID_SELECTED ;;
		3) SERVICE_NAME_SELECTED=$SERVICE_ID_SELECTED ;;
		4) SERVICE_NAME_SELECTED=$SERVICE_ID_SELECTED ;;
		5) SERVICE_NAME_SELECTED=$SERVICE_ID_SELECTED ;;
		*) MAIN_MENU "I could not find that service. What would you like today?" ;;
         	esac	
}

MAIN_FUNCTION
