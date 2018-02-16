#!/bin/bash
#
# For FreePBX 14 (tested on FreePBX 14.0.1.36 , Distro , CentOS 7)
# Filename: /etc/asterisk/scripts/conversion-wav-mp3-wav.sh
# Author: Pavel (aka Steep) pavelyar@ya.ru
# Modified script http://andrey.org/mp3-elastix-2-5-frepbx-2-11/
# -----------------------------------
# Intro:
# Convert all audio files in a directory to mp3 format with saving extension wav
# -----------------------------------
# Installation:
# Create a directory:
# mkdir -p /etc/asterisk/scripts; chown asterisk. /etc/asterisk/scripts
# Take the script with github:
# wget https://raw.githubusercontent.com/andrey0001/fpbx-elastix/master/conversion-wav-mp3-wav.sh -O /etc/asterisk/scripts/conversion-wav-mp3-wav.sh
# Installing file permissions:
# chown asterisk. /etc/asterisk/scripts/conversion-wav-mp3-wav.sh
# chmod a+x /etc/asterisk/scripts/conversion-wav-mp3-wav.sh
# -----------------------------------
# Set permissions on the user asterisk:
# visudo
# asterisk ALL = NOPASSWD: /bin/nice
# asterisk ALL = NOPASSWD: /bin/chown
# asterisk ALL = NOPASSWD: /usr/bin/ionice
# asterisk ALL = NOPASSWD: /usr/bin/chmod
# asterisk ALL = NOPASSWD: /usr/bin/touch
# asterisk ALL = NOPASSWD: /usr/bin/test
# -----------------------------------
# Converting:
# To convert files, run the command from the console:
# find /var/spool/asterisk/monitor/ -name '*.wav' -exec ./conversion-wav-mp3-wav.sh {} \;
# -----------------------------------
# Start script

WAVFILE=$1
MP3FILE=`echo ${WAVFILE} | /bin/sed 's/.wav/.mp3/g'`
SUDO="/usr/bin/sudo"


${SUDO} /usr/bin/lame --quiet --preset phone -h -v ${WAVFILE} ${MP3FILE}
${SUDO} /bin/chmod --reference=${WAVFILE} ${MP3FILE}
${SUDO} /bin/touch --reference=${WAVFILE} ${MP3FILE}
${SUDO} /bin/chown --reference=${WAVFILE} ${MP3FILE}

${SUDO} /usr/bin/test -e ${MP3FILE} && rm -f ${WAVFILE}

${SUDO} /usr/bin/ffmpeg -loglevel quiet -y -i ${MP3FILE} -f wav -acodec copy ${WAVFILE} >/dev/null 2>&1

${SUDO} /bin/chmod --reference=${MP3FILE} ${WAVFILE}
${SUDO} /bin/touch --reference=${MP3FILE} ${WAVFILE}
${SUDO} /bin/chown --reference=${MP3FILE} ${WAVFILE}
${SUDO} /usr/bin/test -e ${WAVFILE} && rm -f ${MP3FILE}

# End script