# Script to parse a telegram channel history and export eth addresses and user invites.

if (/, (.+?)(:| \[).*>joined /) { 
  $jn{$1}++; 
  print STDERR qq(joined: $1\n); 
} elsif (/, (.+?)(:| \[).*>invited (.+?)(<| \[)/) { 
  $u1=$1; $u2=$3; 
  if (!$inv{$u2} && !$jn{$u2}) {
    $inv{$u2}=1; 
    $uinv{$u1}{$u2}=1;
  } 
  print STDERR qq(invited: $u1 >> $u2\n) 
} elsif (/^(.*?), (.+?)(:| \[).*(0x[0-9a-fA-F]{40})/) { 
  print STDERR qq(eth: $2 = $4 - $1\n); 
  $eth{$2}=$4; 
  $dt{$2}=$1;
} 

END {
  foreach $u (keys %eth){ 
    $nv=0;
    foreach $v (keys(%{$uinv{$u}})){
      $nv++ if $jn{$v};
    } 
    %vs=%{$uinv{$u}}; 
    print qq($dt{$u},$u,$eth{$u},).keys(%vs).qq(,$nv\n);
  } 
}
