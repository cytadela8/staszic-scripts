#!/bin/bash

# Skrypt szacuje liczbę dziewczyn w liceum używając bardzo prostej heurystyki. Można usunąć "wc -l" z końca linii,
# aby uzyskać listę nazwisk.

ls /home/k* --color=never -1 | xargs finger 2>/dev/null | grep "Name:" | cut -d ":" -f 3 | cut -d " " -f 2- | grep -e ".*a\ " | grep -ve ".*uba\ " | wc -l

