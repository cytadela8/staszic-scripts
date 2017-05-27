#!/bin/bash

# Skrypt do wyszukiwania błędnych (trole) i należących do gimnazjum (gimbusy) spośród zgłoszonych na Cenzora. Nie
# weryfikuje klasy. (Można dodać porównując CLASS z FINGER_CLASS) Pokazuje osoby o takim samym nazwisku, gdy
# uwzględniając imię nie można znaleźć.
# Przyjmuje plik CSV z imieniem, nazwiskiem i klasą.
#
# USTAWIĆ:
# - pod NAME_COL numer kolumny z imieniem i nazwiskiem
# - pod CLASS_COL numer kolumny z klasą

NAME_COL=2
CLASS_COL=3

if [ "$#" -ne "2" ]; then
    echo Usage: $0 input.csv
fi

POPRAWNE=0
LICZ=0
while read l; do
  LICZ=$(($LICZ + 1))
  NAME=$(echo $l | cut -d',' -f $NAME_COL)
  NAME=$(echo $NAME | xargs)
  CLASS=$(echo $l | cut -d',' -f $CLASS_COL)
  SURNAME=$(echo $NAME | cut -d' ' -f 2)
  FINGER_RAW="$(finger $SURNAME 2>/dev/null)"  #Try by surname
  if [ -z "$FINGER_RAW" ]; then  #If not found, try without polish characters
    SURNAME=$(echo $SURNAME | iconv -f utf8 -t ascii//TRANSLIT)
    NAME=$(echo $NAME | iconv -f utf8 -t ascii//TRANSLIT)
    FINGER_RAW="$(finger $SURNAME 2>/dev/null)"
    if [ -z "$FINGER_RAW" ]; then
      echo $NAME w klasie $CLASS nie znaleziony w ogóle !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      continue
    fi
  fi
  FINGER_DATA="$(echo "$FINGER_RAW" | grep -A1 "$NAME")"  #Try full name
  if [ -z "$FINGER_DATA" ]; then  #If not found, show what was found
    echo $NAME w klasie $CLASS nie znaleziony, ale znaleziono:
    while read znal; do
      echo $znal
    done <<<"$(echo "$FINGER_RAW" | grep "Name:")"
    continue
  fi
  if [[ $(wc -l <<<"$FINGER_DATA") != 2 ]]; then  #If many people with $NAME, show it
    echo za dużo wyników dla $NAME z klasy $CLASS
    continue
  fi
  FINGER_CLASS=$(echo $FINGER_DATA | grep "Directory:" | cut -f 4 -d ":" | cut -d'/' -f 3)
  if [[ $FINGER_CLASS == "gim" ]]; then
    echo "$NAME - GIMBUS GIMBUS GIMBUS!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!1!"
    continue
  fi

  POPRAWNE=$(($POPRAWNE + 1))
done <$1
echo ZAKOŃCZONO
echo SPRAWDZONO $LICZ
echo POPRAWNE $POPRAWNE