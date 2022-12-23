#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guessing_game -t --no-align -c"

echo -e "\nEnter your username:"
read USERNAME
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = $USERNAME")
