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
    print("Nie odnaleziono pliku.")

#utworzenie posortowanej tablicy
sorted = hist.copy()
for j in range(0,26):
    for i in range(len(sorted)-1):
        if sorted[i] > sorted[i+1]:
            temp = sorted[i+1]
            sorted[i+1] = sorted[i]
            sorted[i] = temp
sorted.reverse()

decipher = open("decipher.txt", "w")
try:
    with open(sys.argv[1]) as text:
        line = text.readline()
        while True:
            c = text.read(1)
            if not c:
                break
            elif c == " ":
                decipher.write(" ")
            elif c == "\n":
                decipher.write("\n")
            elif (ord(c)-65) > 25 or (ord(c)-65) < 0:
                decipher.write(c)
            else:
                for x in range(len(sorted)):
                    if hist[(ord(c)-65)] == sorted[x]:
                        decipher.write(line[x])
except FileNotFoundError:
    print("Nie odnaleziono pliku.")
decipher.close()
print(line)
print(hist)
print(sorted)
