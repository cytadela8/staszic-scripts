#!/usr/bin/python2.7

import csv
import sys
import random

f = open(sys.argv[1], 'rt')
data_orig = []
try:
    reader = csv.reader(f)
    for row in reader:
        if not "Sygnatura" in row[0]:
            data_orig.append({"name": row[1], "klasa": row[2].lower()})
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
        last_klasy.append(akt["klasa"])
        if len(last_klasy) > 5:
            last_klasy.pop(0)
    if not ok:
        sys.stdout.write("\rPowtarzam..."+str(tryi))
        sys.stdout.flush()
        tryi+=1
print "Wykonano"
print "zapisuje do wynik.txt"
f = open('wynik.txt', 'w')
f.write("osoba,klasa-osoba,cel\n")
for i in range(len(wynik)-1):
    f.write((wynik[i]["name"] + "," + wynik[i]["klasa"] + "," +wynik[i+1]["name"]))
    f.write("\n")
f.write((wynik[-1]["name"] + "," + wynik[-1]["klasa"] + "," +wynik[0]["name"]))

    
