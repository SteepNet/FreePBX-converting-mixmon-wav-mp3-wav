
# IF you want to convert at the end of each conversation to FREEPBX ----->

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



# IF YOU NEED CONVERTING  ----->

# -----------------------------------
# Intro:
# Convert all audio files in a directory to mp3 format with saving extension wav
# -----------------------------------
# Installation:
# Create a directory:
# mkdir -p /etc/asterisk/scripts; chown asterisk. /etc/asterisk/scripts
# Take the script with github:
# wget https://github.com/SteepNet/FreePBX-converting-mixmon-wav-mp3-wav/blob/master/conversion-wav-mp3-wav.sh -O /etc/asterisk/scripts/conversion-wav-mp3-wav.sh
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
# cd /etc/asterisk/scripts/
# find /var/spool/asterisk/monitor/ -name '*.wav' -exec ./conversion-wav-mp3-wav.sh {} \;
# -----------------------------------
