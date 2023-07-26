#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n ~\^o^/~ Hair Salon ~\^o^/~ \n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\nWhat would you like today?" 
  echo -e "\n1) Haircut\n2) Blowwave\n3) Dyejob"
  read SERVICE_ID_SELECTED
 
  case $SERVICE_ID_SELECTED in
    1) MAKE_APPOINTMENT ;;
    2) MAKE_APPOINTMENT ;;
    3) MAKE_APPOINTMENT ;;
    *) MAIN_MENU "Please enter a valid option." ;;
  esac
}

  MAKE_APPOINTMENT() {
    # get customer info
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    # if customer doesn't exist
    if [[ -z $CUSTOMER_NAME ]]
      then
      # get new customer name
      echo -e "\nWhat's your name?"
      read CUSTOMER_NAME

      # insert new customer
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
    fi

  # get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  

  # get appointment time
      echo -e "\nWhat time would you like to make your booking? (hh:mm)?"
      read SERVICE_TIME

# insert appointment
INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")

# echo appointment details
BOOKING_TYPE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED";)
MAIN_MENU "\nI have put you down for a $BOOKING_TYPE at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU
