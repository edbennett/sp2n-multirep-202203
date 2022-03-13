#grep "CORR_CHIMERA]" | perl -n -e'print "$. $_";' | perl -n -e's/\[CORR_CHIMERA\]//g; chomp; print "$_\n";'
grep "CORR_CHIMERA_DIAG]" | perl -n -e'print "$. $_";' | perl -n -e's/\[CORR_CHIMERA_DIAG\]//g; chomp; print "$_\n";'
