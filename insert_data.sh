#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games,teams")

cat games.csv | while IFS=',' read YR RND WNR OPT WNRG OPTG
do
  if [[ YR -ne "year" ]]
  then
  #INSERTING WINNER TEAM
  WNR_TM=$($PSQL "SELECT name FROM teams WHERE name='$WNR'")
  if [[ -z $WNR_TM ]]
  then
    INSRTWNR=$($PSQL "INSERT INTO teams(name) VALUES('$WNR')")
    if [[ $INSRTWNR == 'INSERT 0 1' ]]
    then
    echo The Winner Team $WNR Was Added To The Table
    fi
  fi
  #INSERTING OPPONENT TEAM
  OPT_TM=$($PSQL "SELECT name FROM teams WHERE name='$OPT'")
  if [[ -z $OPT_TM ]]
  then
    INSRTOPT=$($PSQL "INSERT INTO teams(name) VALUES('$OPT')")
    if [[ $INSRTOPT == 'INSERT 0 1' ]]
    then
    echo The Opponent Team $OPT Was Added To The Table
    fi  
    fi
    WNR_TM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WNR'")
    OPT_TM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPT'")
    #INSERTING THE GAME
    GAME=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ('$YR','$RND','$WNR_TM_ID','$OPT_TM_ID','$WNRG','$OPTG')")
    if [[ $GAME == 'INSERT 0 1' ]]
    then
    echo On $YR For Round $RND, $WNR Won Against $OPT The Final Score $WNRG-$OPTG
    fi
  fi
done