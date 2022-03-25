grep "CORR_CHIMERA]" | perl -n -e'print "$. $_";' | perl -n -e's/\[CORR_CHIMERA\]//g; chomp; print "$_\n";'
