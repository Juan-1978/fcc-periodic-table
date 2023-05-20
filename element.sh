#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align --tuples-only -c"

if [[ $1 ]]
then
  # find out id the argument is a valid atomic_number, symbol or element
  if [[ $1 =~ ^[0-9]+$ ]]
  then
  NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  else
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")
  NAME=$($PSQL "SELECT name FROM elements WHERE name='$1'")
  fi
  # if the argument is a valid atomic_number
  if [[ -n $NUMBER ]]
  then
    N_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1")
    N_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
    N_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$1")
    N_MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$1")
    N_BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$1")
    N_TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number=$1")
    echo "The element with atomic number $1 is $N_NAME ($N_SYMBOL). It's a $N_TYPE, with a mass of $N_MASS amu. $N_NAME has a melting point of $N_MELTING celsius and a boiling point of $N_BOILING celsius."
  fi
  # if the argument is a valid symbol
  if [[ -n $SYMBOL ]]
  then
    S_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
    S_NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$1'")
    S_MASS=$($PSQL "SELECT atomic_mass FROM properties INNER JOIN elements USING(atomic_number) WHERE symbol='$1'")
    S_MELTING=$($PSQL "SELECT melting_point_celsius FROM properties INNER JOIN elements USING(atomic_number) WHERE symbol='$1'")
    S_BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) WHERE symbol='$1'")
    S_TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) INNER JOIN elements USING(atomic_number) WHERE symbol='$1'")
    echo "The element with atomic number $S_NUMBER is $S_NAME ($1). It's a $S_TYPE, with a mass of $S_MASS amu. $S_NAME has a melting point of $S_MELTING celsius and a boiling point of $S_BOILING celsius."
  fi
  # if the argument is a valid name
  if [[ -n $NAME ]]
  then
    E_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
    E_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$1'")
    E_MASS=$($PSQL "SELECT atomic_mass FROM properties INNER JOIN elements USING(atomic_number) WHERE name='$1'")
    E_MELTING=$($PSQL "SELECT melting_point_celsius FROM properties INNER JOIN elements USING(atomic_number) WHERE name='$1'")
    E_BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) WHERE name='$1'")
    E_TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) INNER JOIN elements USING(atomic_number) WHERE name='$1'")
    echo "The element with atomic number $E_NUMBER is $1 ($E_SYMBOL). It's a $E_TYPE, with a mass of $E_MASS amu. $1 has a melting point of $E_MELTING celsius and a boiling point of $E_BOILING celsius."
  fi
  if [[ -z $NUMBER && -z $SYMBOL && -z $NAME ]]
  then
    echo "I could not find that element in the database."
  fi
else
  echo Please provide an element as an argument.
fi
