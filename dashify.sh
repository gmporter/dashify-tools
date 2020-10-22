#!/bin/bash

# Copyright 2019, 2020, George Porter <gmporter@cs.ucsd.edu>

bitrates="480 1000 2400 4800 9600"

if ! [ -x "$(command -v x264)" ]; then
  echo 'Error: x264 is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v MP4Box)" ]; then
  echo 'Error: MP4Box is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v ffmpeg)" ]; then
  echo 'Error: ffmpeg is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v mp4fragment)" ]; then
  echo 'Error: mp4fragment is not installed (https://www.bento4.com/).' >&2
  exit 1
fi

if ! [ -x "$(command -v mp4dash)" ]; then
  echo 'Error: mp4dash is not installed (https://www.bento4.com/).' >&2
  exit 1
fi

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 input-file.mp4"
	exit 1
fi

NAME=$(basename $1 .mp4)

echo "Processing file ${NAME}..."

if [[ -d "${NAME}.intermediate" ]]
then
    echo "Intermediate directory ${NAME}.intermediate already exists, exiting." >&2
	exit 1
fi

if [[ -d "${NAME}.output" ]]
then
    echo "Out directory ${NAME}.output already exists, exiting." >&2
	exit 1
fi

mkdir ${NAME}.intermediate

for b in $bitrates;
do
	vmax=$((${b} * 2))
	vbuf=$((${b} * 4))
	x264 --output ${NAME}.intermediate/intermediate_${b}.264 --fps 24 --preset slow --bitrate ${b} --vbv-maxrate ${vmax} --vbv-bufsize ${vbuf} --min-keyint 48 --keyint 48 --scenecut 0 --no-scenecut --pass 1 ${1}

	MP4Box -add ${NAME}.intermediate/intermediate_${b}.264 -fps 24 ${NAME}.intermediate/unannotated_${b}.mp4

	mp4fragment ${NAME}.intermediate/unannotated_${b}.mp4 ${NAME}.intermediate/fragmented_${b}.mp4
done

FLIST=""
for b in $bitrates;
do
	FLIST+="${NAME}.intermediate/fragmented_${b}.mp4 "
done

mp4dash -o ${NAME}.output --use-segment-list ${FLIST}
