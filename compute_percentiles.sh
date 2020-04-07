#!/bin/bash

#source ~/env.sh

# arg1 is a file containing directory names
arg1=$1

# arg2 is the percent cutoff
arg2=$2

DASK=$HOME/scheduler.json
if [ -f "$DASK" ]; then
    echo "$DASK exist"
    for n in $(cat $arg1) ; do

        i=$n
        b=$(basename $n)
        python compute_percentiles.py --in $i --out "$b".top"$arg2".csv --perc $arg2 --dask $DASK > "$b".percentiles.log 2>&1
        tail -n +2 "$b".top"$arg2".csv | cut -f2,3 -d',' > "$b".top"$arg2".csv.1 ;
        sort -k2,2 -t',' -nr "$b".top"$arg2".csv.1 > "$b".top"$arg2".csv.2
        echo "name,dock" > "$b".top"$arg2".csv.3
        cat "$b".top"$arg2".csv.2 >> "$b".top"$arg2".csv.3

   done
else
    echo "$DASK does not exist"
    echo "check if dask-mpi is running, maybe run \"sbatch setting1.sbatch\""
fi

