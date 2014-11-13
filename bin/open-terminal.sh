#!/bin/bash


# Copyright (C) 2014 Éderson T. Szlachta <edersonszlachta@gmail.com>
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of the
# License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
# You should have received a copy of the GNU General Public
# License along with this program; if not, write to the
# Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
# Boston, MA 02110-1301 USA


# Where the Idea came from
# http://www.linuxquestions.org/questions/linux-software-2/shell-script-to-start-another-program-if-not-running-625589/#post3077532

# Tip to use `xwininfo` to find the window
# http://www.linuxquestions.org/questions/linux-general-1/how-to-bring-up-application-window-to-front-from-shell-script-83545/

# Command that do the Magic while calling this script
# http://askubuntu.com/questions/21262/shell-command-to-bring-a-program-window-in-front-of-another#21274

# wmctrl
# http://tomas.styblo.name/wmctrl/
# http://spiralofhope.com/wmctrl-examples.html
# http://www.freedesktop.org/wiki/Software/wmctrl/

# xdotool
# http://superuser.com/questions/382616/detecting-currently-active-window#615946



# TEMP file to save Current Window ID
TMP_FILE='/tmp/.last_window_id'

# Create TEMP File
touch $TMP_FILE

# Search terminal PID
PID=`ps -e | grep -v grep | grep gnome-terminal | awk '{print $1}'`

# get current Window Name to avoid PID conflict
CURRENT_PID=`xdotool getwindowfocus getwindowname`

# get current Window ID by Window Name
CURRENT_ID=`wmctrl -l -p | grep "$CURRENT_PID" | awk '{print $1}'`




if test "$PID" = ""
then
	# save current Window ID to use the next time
	echo $CURRENT_ID > $TMP_FILE

	# start a gnome-terminal
	gnome-terminal --hide-menubar --maximize
else
	# get Windows ID by PID of process
	MOVE_TO_ID=`wmctrl -l -p | grep $PID | awk '{print $1}'`

	if test "$CURRENT_ID" != "$MOVE_TO_ID"
	then
		# save current ID to use the next time
		echo $CURRENT_ID > $TMP_FILE
	else
		# get the last actived window id
		MOVE_TO_ID=`cat $TMP_FILE`

		# remove tmp file
		`rm -Rf $TMP_FILE`
	fi

	# Activate the window by switching to its desktop and raising it (see man wmctrl)
	wmctrl -a "$MOVE_TO_ID" -i
fi

