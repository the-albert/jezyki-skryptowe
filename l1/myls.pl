#!/usr/bin/perl
use strict;
use warnings;

my $dir;
my $arg = "short";

if(@ARGV)
{
  if($ARGV[0] eq "-l")
  {
    $arg = "long";
    if($ARGV[1])
    {
      $dir = $ARGV[1];
    }
    else
    {
      $dir = "./";
    }
  }
  elsif($ARGV[1] eq "-l")
  {
    $arg = "long";
    $dir = $ARGV[0];
  }
  elsif($ARGV[1] ne "-l")
  {
    $dir = $ARGV[0];
  }
  else
  {
    die "Nieprwidłowe argumenty!";
  }
}
else
{
  $dir = ".";
}

opendir my $dh, $dir or die "Nie można było otworzyć: '$dir'\nError: $!\n";
my @dir_content = readdir $dh;
my @sorted = sort @dir_content;

if($arg eq "long")
{
  foreach my $content (@sorted)
  {
    my $path = "${dir}/${content}";
    my @stats = stat($path);
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($stats[9]);
    $year+=1900;

    my $permissions;
    $permissions = sprintf '%04o', $stats[2] & 07777;
    my @fperm = (substr($permissions, 1, 1), substr($permissions, 2, 1), substr($permissions, 3, 1));

    if (-d $path) {$permissions = "d";}
    else {$permissions = "-";}

    foreach my $number (@fperm)
    {
        if($number eq "0") {$permissions .= "---";}
        elsif($number eq "1") {$permissions .= "--x";}
        elsif($number eq "2") {$permissions .= "-w-";}
        elsif($number eq "3") {$permissions .= "-wx";}
        elsif($number eq "4") {$permissions .= "r--";}
        elsif($number eq "5") {$permissions .= "r-x";}
        elsif($number eq "6") {$permissions .= "rw-";}
        elsif($number eq "7") {$permissions .= "rwx";}
    }


    printf '%-30s', $content;
    printf '%-10s', $stats[7];
    printf "${year}-"; printf '%02s', $mon; printf "-"; printf '%02s', $mday;
    printf " "; printf '%02s', $hour; printf ":";
    printf '%02s', $min; printf ":"; printf '%02s', $sec;
    printf '%15s', $permissions;
    print "\n";

  }
}
else
{
  foreach my $content (@sorted)
  {
    my @stats = stat("$content");
    say("$content");
  }
}

closedir $dh;
