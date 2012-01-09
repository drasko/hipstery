#!/usr/bin/perl -w

# Print the value of the command line arguments
#$numArgs = $#ARGV + 1;
#print "You provided $numArgs arguments\n";
#print "Input file is $ARGV[0]\n";
#print "Output file is $ARGV[1]\n\n";



### HTML Heredoc ###

$html_top = <<END;

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
  <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
  <title>Drasko DRASKOVIC</title>
  <link rel="stylesheet" href="../css/style.css" media="screen">
</head>

<body>

<div id="container">

<div id="top">
   <h1><a href="index.html">drasko draskovic</a></h1>
</div>

<div id="leftnav">
   <div id="navcontainer">
      <ul id="navlist">
END
########



#<li id="active"><a href="index.html" id="current">home</a></li>

@files = ();
opendir(DIRHANDLE, "photo") or die "couldn't open /usr/bin : $!";
while ( defined ($file = readdir(DIRHANDLE)) ) {
   next if $file =~ /^\.\.?$/;     # skip . and ..

   push(@files, $file);
   print "Inside photo is something called $file\n";
}
closedir(DIRHANDLE);

#sort files
@files = sort(@files);

# index_photo will be the last one (because all others are prefixed by numbers)
$pindex = pop(@files);

@links = ();
foreach (@files) {
   $photo = $_;
   
   # remove number prefix
   $photo =~ s/^\d+_//;
   
   # remove extension
   $photo =~ s/\.[^.]+$//;
   
   $link = "\t\t\t<li id=\"active\"><a href=\"$_.html\" id=\"current\">$photo</a></li>\n";
   push (@links, $link);
}


### html_middle
$html_middle = <<END;
      </ul>
   </div>
</div>   <!-- end rightnav -->

<div id="middle">
<!--   Bla Bla -->
</div>

<div id="content">
END
########


### html_end
$html_end = <<END;
</div>   <!-- end content -->

<div id="footer">
<!-- Sign and date the page, it's only polite! -->
   <address>Made 2009<br>
   by Drasko DRASKOVIC</address>
</div>

</div>   <!-- end container -->

</body>
</html>
END
########


@chtml = ();
push(@chtml, $html_top);
foreach (@links) {
   push(@chtml, $_);
}
push(@chtml, $html_middle);


$pwidth = 500;
$pheight = 500;

# Open index file in write mode
open (INDEX, ">./html/index.html") or die $!;
print INDEX @chtml;
print INDEX "<img src=\"../photo/$pindex\" alt=\"index_photo\" width=\"$pwidth\" height=\"$pheight\"/>\n";
print INDEX $html_end;
close INDEX;


# Produce files
foreach $file (@files) {
   # Open index file in write mode
   open (PHTML, ">./html/$file.html") or die $!;

   print PHTML @chtml;

   $photo = $file;
   
   # remove number prefix
   $photo =~ s/^\d+_//;
   
   # remove extension
   $photo =~ s/\.[^.]+$//;
   
   print PHTML "<img src=\"../photo/$file\" alt=\"$photo\" width=\"$pwidth\" height=\"$pheight\"/>\n";
   print PHTML $html_end;
   close PHTML;
}
