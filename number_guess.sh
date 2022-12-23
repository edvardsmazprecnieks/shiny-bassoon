#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guessing_game -t --no-align -c"

echo -e "\nEnter your username:"
read USERNAME_INPUT
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME_INPUT'")

if [[ -z $USER_ID ]]
then
INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username) VALUES ('$USERNAME_INPUT')")
echo "Welcome, $USERNAME_INPUT! It looks like this is your first time here."
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME_INPUT'")
else
USERNAME=$($PSQL "SELECT username FROM users WHERE user_id = $USER_ID")
GAMES_PLAYED=$($PSQL "SELECT COUNT(game_id) FROM games WHERE user_id = $USER_ID")
BEST_GAME=$($PSQL "SELECT MAX(guesses) FROM games WHERE user_id = $USER_ID")
if [[ -z BEST_GAME ]]
then
BEST_GAME = 0
fi
echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

SECRET_NUMBER=$((1+$RANDOM%1000))
echo -e "\nGuess the secret number between 1 and 1000:"
read PLAYER_GUESS
NUMBER_OF_GUESSES=1

while [ $SECRET_NUMBER != $PLAYER_GUESS ]
do
if [[ $PLAYER_GUESS =~ ^[0-9]+$ ]]
then
if (( $PLAYER_GUESS > $SECRET_NUMBER ))
then
NUMBER_OF_GUESSES=$((NUMBER_OF_GUESSES+1))
echo -e "\nIt's lower than that, guess again:"
read PLAYER_GUESS
else
NUMBER_OF_GUESSES=$((NUMBER_OF_GUESSES+1))
echo -e "\nIt's higher than that, guess again:"
read PLAYER_GUESS
fi
else
echo -e "\nThat is not an integer, guess again:"
read PLAYER_GUESS
fi
done

INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(user_id, guesses) VALUES ($USER_ID, $NUMBER_OF_GUESSES)")
echo -e "\nYou guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"