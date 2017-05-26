#!/bin/bash

POPRAWNE=0
LICZ=0
while read l; do
  LICZ=$(($LICZ + 1))
  NAME=$(echo $l | cut -d',' -f 2)
  NAME=$(echo $NAME | xargs)
  CLASS=$(echo $l | cut -d',' -f 3)
  #echo $NAME, klasa $CLASS
  NAME_S=$(echo $NAME | cut -d' ' -f 2)
  FINGER_RAW="$(finger $NAME_S 2>/dev/null)"
  if [ -z "$FINGER_RAW" ]; then
    NAME_S=$(echo $NAME_S | iconv -f utf8 -t ascii//TRANSLIT)
    NAME=$(echo $NAME | iconv -f utf8 -t ascii//TRANSLIT)
    FINGER_RAW="$(finger $NAME_S 2>/dev/null)"
    if [ -z "$FINGER_RAW" ]; then
      echo $NAME w klasie $CLASS nie znaleziony w ogóle !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      continue
    fi
  fi
  FINGER_DATA="$(echo "$FINGER_RAW" | grep -A1 "$NAME")"
  if [ -z "$FINGER_DATA" ]; then
    echo $NAME w klasie $CLASS nie znaleziony, ale znaleziono:
    while read znal; do
      echo $znal
    done <<<"$(echo "$FINGER_RAW" | grep "Name:")"
    continue
  fi
  if [[ $(wc -l <<<"$FINGER_DATA") != 2 ]]; then
    echo za dużo wyników dla $NAME z klasy $CLASS
    continue
  fi
  FINGER_KLASA=$(echo $FINGER_DATA | grep "Directory:" | cut -f 4 -d ":" | cut -d'/' -f 3)
  if [[ $FINGER_KLASA == "gim" ]]; then
    echo "$NAME - GIMBUS GIMBUS GIMBUS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1"
  fi

  POPRAWNE=$(($POPRAWNE + 1))
done <$1
echo ZAKOŃCZONO
echo SPRAWDZONO $LICZ
echo POPRAWNE $POPRAWNE
