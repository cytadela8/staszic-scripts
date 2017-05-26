#!/usr/bin/env python3

"""

Skrypt umożliwia wygenerowanie losowego cyklu osób dla gry Cenzor (Zabójca). Ale słowa z rodziny "bić" są ZŁEEEE!!!!

Skrypt przyjmuje jako pierwszy parametr listę zapisanych w formacie CSV. Pomija pierwszy wiersz. Pod NAME_COL wstaw
numer kolumny z imieniem i nazwiskiem pod KLASA_COL wstaw numer kolumny z klasą.

Skrypt losuje metodą bruteforce taką permutację osób, aby separacja między osobami z jednej klasy (liczba osób z
innej klasy między osobami z jednej klasy) wynosiła min MIN_KLASA_SEP.

Wynik pracy londuje w pliku wynik.txt

Jako źródło losowości wykorzystuje standardową bibliotekę random
(!!! to nie jest bezpiczne, TODO zrobić bezpiecznie !!!)

"""

import csv
import sys
import random

NAME_COL = 1
KLASA_COL = 2
MIN_KLASA_SEP = 5

if len(sys.argv) != 2:
    print("Usage: %s input.csv" % sys.argv[0])
    exit(1)

f = open(sys.argv[1], 'rt')
data_orig = []
try:
    reader = csv.reader(f)
    for row in reader:
        data_orig.append({"name": row[NAME_COL], "klasa": row[KLASA_COL].lower()})
    data_orig = data_orig[1:]
finally:
    f.close()
ok = False
wynik = []
tryi = 1
while not ok:
    ok = True
    wynik = []
    last_klasy = ["asd"]
    data = list(data_orig)
    while data:
        akt = {"klasa" : last_klasy[-1]}
        count = 0
        while akt["klasa"] in last_klasy:
            akt = random.choice(data)
            count+=1
            if count > 100:
                ok = False
                break
        if not ok:
            break
        data.remove(akt)
        wynik.append(akt)
        if MIN_KLASA_SEP > 0:
            last_klasy.append(akt["klasa"])
        if len(last_klasy) > MIN_KLASA_SEP > 0:
            last_klasy.pop(0)
    if not ok:
        sys.stdout.write("\rPowtarzam..."+str(tryi))
        sys.stdout.flush()
        tryi += 1
print("Wykonano")
print("zapisuje do wynik.txt")
f = open('wynik.txt', 'w')
f.write("osoba,klasa-osoba,cel\n")
for i in range(len(wynik)-1):
    f.write((wynik[i]["name"] + "," + wynik[i]["klasa"] + "," +wynik[i+1]["name"]))
    f.write("\n")
f.write((wynik[-1]["name"] + "," + wynik[-1]["klasa"] + "," +wynik[0]["name"]))
