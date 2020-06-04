#! /usr/bin/python3

import sys

if len(sys.argv) < 2:
    print("Nie podano ścieżki do pliku.")
    exit(0)

hist = [0] * 26

#policzenie wytąpień poszczególnych liter
try:
    with open(sys.argv[1]) as text:
        while True:
            c = text.read(1)
            if not c:
                break
            elif  91 > ord(c) > 64:
                hist[ord(c)-65] += 1
            elif 123 > ord(c) > 96:
                hist[ord(c)-97] += 1
except FileNotFoundError:
    print('Nie odnaleziono pliku.')

#policzenie 1 procenta
sum = 0
for c in hist:
    sum += c
proc = sum/100

for c in range(len(hist)):
    print(chr(c+65), "\t", hist[c], "\t\t%.2f" % (hist[c]/proc), "%")
