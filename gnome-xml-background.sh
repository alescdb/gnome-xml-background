#!/bin/bash

DURATION="1200"
TRANSITION="1.5"

if [[ "$#" != "1" ]]; then
  echo >&2 "Usage: $0 <directory>"
  exit 5
fi

DIRECTORY="$1"
PREV=""
FIRST=""


function addTransition() {
    FROM=$1
    TO=$2
    LENGTH=$3

    echo "  <transition>"
    echo "    <duration>$LENGTH</duration>"
    echo "    <from>$FROM</from>"
    echo "    <to>$TO</to>"
    echo "  </transition>"
}

echo "<?xml version=\"1.0\" ?>"
echo "<background>"

while read IMAGE; do
    [[ -z "$FIRST" ]] && {
        FIRST=$IMAGE
    }
    [[ ! -z "$PREV" ]] && {
        addTransition "$PREV" "$IMAGE" "$TRANSITION"
    }

    echo "  <static>"
    echo "    <duration>$DURATION</duration>"
    echo "    <file>$IMAGE</file>"
    echo "  </static>"

    PREV=$IMAGE
done <<<$(find "$1" -maxdepth 1 -type f | grep -Ei '\.(jpg|png)$')

[[ ! -z "$FIRST" ]] && {
    addTransition "$PREV" "$FIRST" "$TRANSITION"
}

echo "</background>"


#<static>
#  <duration>600</duration>
#  <file>/home/alex/Nextcloud/Wallpapers/adb_boxes.png</file>
#</static>
#<transition>
#  <duration>0.5</duration>
#  <from>/home/alex/Nextcloud/Wallpapers/adb_boxes.png</from>
#  <to>/home/alex/Nextcloud/Wallpapers/adb_bg2.png</to>
#</transition>
