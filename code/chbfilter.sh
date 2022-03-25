grep "CORR_CHIMERA_DIAG]" | perl -n -e'print "$. $_";' | perl -n -e's/\[CORR_CHIMERA_DIAG\]//g; chomp; print "$_\n";'
