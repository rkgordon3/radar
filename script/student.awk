BEGIN { FS=","; OFS="," }
{
  if (x == 0) { 
      print $0; 
  } else { 
      print "\"" NR "\"",$2,$3,$4,$5,$6,$7,"\"12/12/1992\"","\"123-123-1234\"",$10,$11,$12,$13,"\"555-123-1234\"","\"555-123-1233\"","\"555-123-1231\"",$17,$18;
  }
  x++;
}
END { print x}