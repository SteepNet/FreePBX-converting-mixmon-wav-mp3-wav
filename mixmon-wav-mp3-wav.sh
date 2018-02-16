#!/bin/bash
#
# For FreePBX 14 (tested on FreePBX 14.0.1.36 , Distro , CentOS 7)
# Filename: /etc/asterisk/scripts/mixmon-wav-mp3-wav.sh
# Author: Pavel (aka Steep) pavelyar@ya.ru
# Modified script http://andrey.org/mp3-elastix-2-5-frepbx-2-11/
# -----------------------------------
# Intro:
# Convert the file after talking to mp3 using "lame", then use "ffmpeg" to add the title to the record file and change the extension back to .wav
# The size of the stored files will decrease, 7-10 times
# -----------------------------------
# Installation:
# Create a directory:
# mkdir -p /etc/asterisk/scripts; chown asterisk. /etc/asterisk/scripts
# Take the script with github:
# wget https://github.com/SteepNet/FreePBX-converting-mixmon-wav-mp3-wav/blob/master/mixmon-wav-mp3-wav.sh -O /etc/asterisk/scripts/mixmon-wav-mp3-wav.sh
# Installing file permissions:
# chown asterisk. /etc/asterisk/scripts/mixmon-wav-mp3-wav.sh
# chmod a+x /etc/asterisk/scripts/mixmon-wav-mp3-wav.sh
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
# To enable on FreePBX:
# Settings->Advanced Settings
# Display Readonly Settings - true
# Override Readonly Settings - true
# Post Call Recording Script - /etc/asterisk/scripts/mixmon-wav-mp3-wav.sh ^{YEAR} ^{MONTH} ^{DAY} ^{CALLFILENAME} ^{MIXMON_FORMAT} ^{MIXMON_DIR}
# Override Call Recording Location - /var/spool/asterisk/monitor/
# ------------------------------------
# Start script

YEAR=$1
MONTH=$2
DAY=$3
CALLFILENAME=$4
MIXMON_FORMAT=$5
MIXMON_DIR=$6

SUDO="/usr/bin/sudo"
LOWNICE="/bin/nice -n 19 /usr/bin/ionice -c3"

if [ -z "${MIXMON_DIR}" ]; then
SPOOLDIR="/var/spool/asterisk/monitor/"
else
SPOOLDIR=${MIXMON_DIR}
fi

FFILENAME=${SPOOLDIR}${YEAR}/${MONTH}/${DAY}/${CALLFILENAME}.${MIXMON_FORMAT}

${SUDO} /usr/bin/test ! -e ${FFILENAME} && exit 21

WAVFILE=${FFILENAME}
MP3FILE=`echo ${WAVFILE} | /bin/sed 's/.wav/.mp3/g'`

# Convert wav to mp3 phone => 16kbps/mono
${SUDO} ${LOWNICE} /usr/bin/lame --quiet --preset phone -h -v ${WAVFILE} ${MP3FILE}

# Permissions
${SUDO} /bin/chown --reference=${WAVFILE} ${MP3FILE}
${SUDO} /bin/chmod --reference=${WAVFILE} ${MP3FILE}
${SUDO} /bin/touch --reference=${WAVFILE} ${MP3FILE}

# Delete orig wav
${SUDO} /usr/bin/test -e ${MP3FILE} && /bin/rm -f ${WAVFILE}

# Add the title to the record file and change the extension back to .wav
${SUDO} ${LOWNICE} /usr/bin/ffmpeg -loglevel quiet -y -i ${MP3FILE} -f wav -acodec copy ${WAVFILE} >/dev/null 2>&1

# Permissions
${SUDO} /bin/chown --reference=${MP3FILE} ${WAVFILE}
${SUDO} /bin/chmod --reference=${MP3FILE} ${WAVFILE}
${SUDO} /bin/touch --reference=${MP3FILE} ${WAVFILE}

#Delete mp3
${SUDO} /usr/bin/test -e ${WAVFILE} && /bin/rm -f ${MP3FILE}

# End script
