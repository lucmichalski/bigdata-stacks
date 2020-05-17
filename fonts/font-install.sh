#! /usr/bin/env bash

mydotfile=$(cd "$(dirname "$0")"; cd ..; pwd)
echo "$mydotfile"

# @ install fonts

if [ -e "$mydotfile/fonts/powerline" ]; then
  cp -r "$mydotfile/fonts/powerline" /usr/share/fonts  && \
  cp -r "$mydotfile/fonts/sourcecodepro-fonts" /usr/share/fonts  && \
    fc-cache -vf
fi
