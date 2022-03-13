grep RESULT | perl -n -e'print "$. $_";' | perl -n -e's/\[RESULT\]\[0\]Eig//g; chomp; print "$_\n";'
