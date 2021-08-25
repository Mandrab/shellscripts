#!/bin/bash
# convert all the wav in a folder to mp3

for f in $1*.wav
do
    NEWNAME="${f%wav}mp3"
    echo "conversion of $f into $NEWNAME"
    ffmpeg -i $f $NEWNAME
done
