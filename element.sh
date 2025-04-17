#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then
  echo 'Please provide an element as an argument.'
else
  # check in atomic_number column, symbol column, name column;
  for NOUN in atomic_number symbol name;
  do
    CHECK_RESULT_IN_ELEMENTS=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE $NOUN = '$1'")
    if [[ $CHECK_RESULT_IN_ELEMENTS ]]
    then 
      FIND_SOMETHING=$CHECK_RESULT_IN_ELEMENTS
    fi
  done
 
  if [[ -z $FIND_SOMETHING ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$FIND_SOMETHING" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME
    do
      # check the info in properties table;
      CHECK_RESULT_IN_PROPERTIES=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
      echo "$CHECK_RESULT_IN_PROPERTIES" | while IFS="|" read ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE_ID
      do
        CHECK_RESULT_IN_TYPES=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")
        TYPE=$(echo "$CHECK_RESULT_IN_TYPES")
         echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
    done
  fi
fi
