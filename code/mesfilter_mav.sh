grep -E 'mass='$(printf "%.6f" $1)' DEFAULT_POINT TRIPLET g5g1=|mass='$(printf "%.6f" $1)' DEFAULT_POINT TRIPLET g5g2=|mass='$(printf "%.6f" $1)' DEFAULT_POINT TRIPLET g5g3=' | grep -v _im= | grep -v _disc= | perl -n -e's/\[MAIN\]\[0\]conf #\d+ mass=-*[\.\d]+ DEFAULT_POINT TRIPLET //g; chomp; s/=//g; s/[A-Z_]* TRIPLET//g; print "$_\n" unless ($_=~/^\s?$/);' | perl -n -e'$a=int(($.-1)/1); print "$a $_";'
