#!/usr/bin/perl
use strict;
use warnings;

#użytkownik nie podał pliku
if(!@ARGV){
  die "Podaj ścieżkę do pliku.\n";
}

#potrzebne zmienne
my $path;   #ścieżka do pliku
my $htmldoc;#plik handle
my $line;   #wczytywana linia
my $flag=0; #czy zaczęła się tabela
my @header; #nagłówek tabeli
my @content;#zawartość tabeli
my @names;  #imiona i nic
my $columns;#ilość kolumn w tabeli
my $cells;  #ilość komórek w tabeli
my $name;   #index kolumny NAME
my $temp;   #zmienna wspomagająca
my $file;   #plik do zapisu
my $i = 0;  #iterator
my $j = 0;  #iterator 2

#pobranie nazwy pliku i otwarcie
$path = $ARGV[0];
open $htmldoc, $path or die "Nie można było otworzyć: '$path'\nError: $!\n";

#czytanie z pliku linia po linii
while($line = <$htmldoc>)
{
  #flaga jeśli tablela się rozpoczęła
  if($line =~ /Bieżący ranking/){
    $flag = 1;
  }
  #sprawdzam czy zaczęła się tabela
  if($flag eq 1){
    #pobieram wartości nagłówkowe
    while($line =~ />([A-Z]+[0-9A-Z]*)</g){
        push @header, $1;
        if($1 eq "SCORE"){
          last;
        }
    }
    #pobieram wartości punktowe
    while($line =~  /[^br]>([0-9-]+[.0-9]*)</g){
        push @content, $1;
    }
    #pobieram imiona i nicki
    while($line =~ /\/([a-z0-9_]+)">([_\[\]\'A-Z0-9a-z.Ą ą Ć ć Ę ę Ł ł Ń ń Ó ó Ś ś Ź ź Ż ż ]*\s*[_\[\]\'Ą ą Ć ć Ę ę Ł ł Ń ń Ó ó Ś ś Ź ź Ż ż A-Z0-9a-z]*)</gu){
      $temp = $2 . ' (' . $1 . ')';
      push @names, $temp;
    }
  }
  #wyłączam flagę po wyjściu z tabeli
  if($flag eq 1 and $line =~ /<\/table>/){
    $flag = 0;
  }
}

#określenie kolumny imion
$columns = scalar(@header);
for($i=0; $i<$columns; $i++){
  if($header[$i] eq "NAME"){
    $name = $i;
  }
}

#otworzenie pliku do zapisu
open($file, ">", "table_out.txt");

#wypisanie wybranych komórek
$cells = scalar(@content);
for($i=0; $i<$cells; $i++){
  if($i % ($columns-1) eq 0){
    print $file "\n";
  }
  if($i % ($columns-1) eq $name){
    print $file "\"$names[$j]\"\; ";
    $j++;
  }
  #podmiana znaków
  $content[$i] =~ tr/./,/;
  $content[$i] =~ s/-/0,0/;
  print $file "\"$content[$i]\"\; ";
}

#zamknięcie pliku
close $file;
close $htmldoc;
