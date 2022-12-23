#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guessing_game -t --no-align -c"

echo -e "\nEnter your username:"
read USERNAME
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")

if [[ -z $USER_ID ]]
then
INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username) VALUES ('$USERNAME')")
echo -e "\nWelcome, $USERNAME! It looks like this is your first time here"
else
GAMES_PLAYED=$($PSQL "SELECT COUNT(game_id) FROM games WHERE user_id = $USER_ID")
BEST_GAME=$($PSQL "SELECT MAX(guesses) FROM games WHERE user_id = $USER_ID")
echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

SECRET_NUMBER=$((1+$RANDOM%1000))
echo $SECRET_NUMBER
echo -e "\nGuess the secret number between 1 and 1000:"
read PLAYER_GUESS

while [ $SECRET_NUMBER != $PLAYER_GUESS ]
do
if (( $PLAYER_GUESS > $SECRET_NUMBER ))
then
echo -e "\nIt's lower than that, guess again:"
read PLAYER_GUESS
else
echo -e "\nIt's higher than that, guess again:"
read PLAYER_GUESS
fi
done