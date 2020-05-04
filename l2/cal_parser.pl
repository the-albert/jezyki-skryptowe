#!/usr/bin/perl
use strict;
use warnings;

#użytkownik nie podał pliku
if(!@ARGV){
  die "Podaj nazwę pliku ics.\n";
}

#zmienne potrzebne do odczytu
my $flag=0;   #czy jest w vevent
my $icsfile;  #ścieżka do pliku
my $calendar; #plik handle
my $line;     #odczytywana linia
my $starthour;#godzina rozpoczęcia zajęć
my $startmin; #minuta rozpoczęcia
my $stophour; #godzina zakończenia zajęć
my $stopmin;  #minuta zakończenia
my $lessons=0;#ilość godzin lekcyjnych

#pobranie nazwy pliku i otwarcie
$icsfile = $ARGV[0];
open $calendar, $icsfile or die "Nie można było otworzyć: '$icsfile'\nError: $!\n";

#przejście przez plik co linię
while ($line = <$calendar>) {
   #ustawienie flagi
   if($line =~ /BEGIN:VEVENT/){
     $flag = 1;
   }
   #pobranie czasu rozpoczęcia zajęć
   if($flag eq 1 and $line =~ /DTSTART/){
     ($starthour, $startmin) = ($line =~ /T(\d\d)(\d\d)\d\d/);
   }
   #pobranie czasu zakończenia zajęć
   if($flag eq 1 and $line =~ /DTEND/){
     ($stophour, $stopmin) = ($line =~ /T(\d\d)(\d\d)\d\d/);
   }
   #zdjęcie flagi i doliczenie godzin
   if($line =~ /END:VEVENT/){
     $flag = 0;
     $lessons += int((($stophour-$starthour)*60 - $startmin + $stopmin)/45);
   }
}

#wyświetlenie odpowiedzi i zamknięcie pliku
printf "Ilość godzin lekcyjnych w semestrze: %d\n", $lessons;

close $calendar;
