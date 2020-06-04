#! /usr/bin/python3
import sys
import pathlib

#funkcja przechodzi przez katalogi i zapisuje ścieżki do plików
files = []
def open_and_check(dir):
    for something in pathlib.Path(dir).iterdir():
        if something.is_file():
            files.append(something)
        elif something.is_dir():
            open_and_check(something)

#funkcja zwracająca wielkość pliku
def file_size(path):
    import os
    stat = os.stat(path)
    return stat.st_size

if len(sys.argv) < 2:
    print("Nie podano ścieżki do pliku.")
    exit(0)

#pobranie plików ze wszystkich podanych katalogów
i = -1;
for dir in sys.argv:
    i += 1
    if i == 0:
        continue
    if pathlib.Path(dir).exists() == False \
    or pathlib.Path(dir).is_dir() == False:
        print("Podany katalog nie istnieje.")
        exit()
    open_and_check(dir)

#sprawdzenie czy pojawiają się duplikaty
duplicated = []
for x in range(len(files)):
    found = False
    for y in range(x+1, len(files)):
        if (file_size(files[x]) == file_size(files[y])):
            f1 = open(files[x], "rb")
            f2 = open(files[y], "rb")
            flag = True
            while True:
                c1 = f1.read(1)
                c2 = f2.read(1)
                if c1 != c2:
                    flag = False
                    break
                if not c1 or not c2:
                    break
            if flag == True:
                duplicated.append(files[y])
                found = True
    #wypisanie duplikatów
    if found == True:
        sum = 0
        sum += file_size(files[x])
        for file in duplicated:
            sum += file_size(file)
        print("Znaleziono duplikaty o łącznej wielkości: ", sum)
        print(files[x])
        for file in duplicated:
            print(file)
        duplicated.clear()
