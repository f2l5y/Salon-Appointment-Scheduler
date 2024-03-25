#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

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
#	read SERVICE_CHOICE
#		case $SERVICE_CHOICE in
#		1) CUT ;;
#		2) COLOR ;;
#		3) PERM ;;
#		4) STYLE ;;
#		5) TRIM ;;
#		*) MAIN_MENU "I could not find that service. What would you like today?" ;;
#         	esac	

}

MAIN_MENU
