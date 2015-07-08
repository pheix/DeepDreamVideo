#!/bin/bash

MOVIEFILE=$1
IFS=. read MOVIENAME MOVIEEXT <<< "${MOVIEFILE}"

MOVIEPATH=./movie/${MOVIENAME}.mp4

if [ $# -eq 0 ]; then
    echo "please provide the directory of the processed frames"
    echo "./3_frames2movie original-movie.mp4 [directory]"
    exit 1
fi

ffmpeg -framerate 25 -i $2/%4d.jpg -c:v libx264 -r 30 -pix_fmt yuv420p tmp.mp4

ffmpeg -i ${MOVIEPATH} _music_track.mp3
ffmpeg -i _music_track.mp3 _music_track.wav

secs=$(ffprobe -i tmp.mp4 -show_entries format=duration -v quiet -of csv="p=0")

ffmpeg -i _music_track.wav -ss 0 -t $secs _music_track.short.wav
ffmpeg -i _music_track.short.wav -i tmp.mp4 -strict -2 ${MOVIENAME}.inception.mp4
rm tmp.mp4
rm _music_track.mp3
rm _music_track.wav
rm _music_track.short.wav

echo -e "+++++++++++\nCurrent movie duration in seonds: ${secs}\n+++++++++++\n"
