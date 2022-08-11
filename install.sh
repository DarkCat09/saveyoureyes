#!/bin/bash

RESET='\033[0m'
BOLD='\033[1m'
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
NEWLINE=$'\n'

COLOR=''

script_file=$(realpath ~/.sye.sh)
script_vars=''

script_time=''
script_excl=''
script_cmd=''

about () {
	echo -e " ${BLUE}╭───────────────────────────╮${RESET}"
	echo -e " ${BLUE}│      Save your eyes       │${RESET}"
	echo -e " ${BLUE}│       by DarkCat09        │${RESET}"
	echo -e " ${BLUE}╰───────────────────────────╯${RESET}"
	echo
	echo "Install.sh generates a script"
	echo "which will notify you when you"
	echo "spend too much time working on PC"
	echo
}

block () {
	# Print text in a block
	echo -ne "${COLOR}|${RESET} "
	echo -ne "$1"
	# $2 = No newline
	if [[ $2 != 'n' ]]; then echo; fi
}

safetime () {

	COLOR="$PURPLE"
	block 'How old are you? ' n
	echo -ne "$COLOR"
	read age
	echo -ne "$RESET"

	# Safe time for diffirent ages
	result=60      # 18+
	if (( age < 8 )); then
		result=10  # 5-7
	elif (( age < 12 )); then
		result=15  # 8-11
	elif (( age < 14 )); then
		result=20  # 12-13
	elif (( age < 16 )); then
		result=25  # 14-15
	elif (( age < 18 )); then
		result=30  # 16-17
	fi

	block "${BOLD}Safe time for you is${RESET} " n
	echo -e "${GREEN}$result min${RESET}"
	echo

	# Sleeping time in seconds
	script_time=$((${result}*60))
}

whitelist () {

	COLOR="$YELLOW"
	block "${BOLD}Whitelist${RESET}"
	block
	block "Notification won't appear when"
	block "you are watching a film in VLC,"
	block "just specify \"vlc\" (without quotes)"
	block
	block "Enter apps whitelist separated with comma:"
	block "" n
	echo -ne "$COLOR"
	read apps
	echo -ne "$RESET"
	echo

	script_excl=$(echo -n $apps | sed 's/, */\|/g')

	script_cmd="ps -e |grep -E '$(echo -n $apps | sed 's/, */\|/g')' >/dev/null; if [[ \$? == 1 ]]; then SAVEYOUREYES_CMD; fi"
}

notifycmd () {
	
	COLOR="$RED"
	block "Enter notification text:"
	block "" n
	echo -ne "$COLOR"
	read content
	echo -ne "$RESET"
	block "Enter notification title:"
	block "" n
	echo -ne "$COLOR"
	read caption
	echo -ne "$RESET"
	echo

	COLOR="$CYAN"
	block "Choose notification type:"
	block "1. ${COLOR}GtkDialog (default)${RESET}"
	block "2. ${COLOR}libnotify${RESET}"
	block "3. ${COLOR}Open browser${RESET}"
	block "" n
	echo -ne "$COLOR"
	read msgtype
	echo -ne "$RESET"
	echo

	if [[ $msgtype == 2 ]]; then
		# Using libnotify to create a notification
		# (Desktop Environment independent, works on every DE)
		script_cmd="notify-send -a \"$caption\" \"$content\""

	elif [[ $msgtype == 3 ]]; then
		# Opening default browser
		COLOR="$BLUE"
		block "Current default browser: ${COLOR}$(xdg-settings get default-web-browser | sed 's/\.desktop//')${RESET}"
		block "You can change it via xdg-settings command, e.g.:"
		block "${BOLD}xdg-settings set default-web-browser chrmoium-browser.desktop${RESET}"
		block "${BOLD}xdg-settings set default-web-browser vivaldi-stable.desktop${RESET}"
		block "${BOLD}xdg-settings set default-web-browser firefox.desktop${RESET}"
		echo
		script_cmd="xdg-open \"https://darkcat09.codeberg.page/text/?title=$caption&text=$content&theme=dark\""
	else
		# Calling GTK MessageDialog from Python
		COLOR="$CYAN"
		block "Installing showdialog==1.0.1"
		python3 -m pip install -U 'showdialog==1.0.1' >/dev/null
		block "Exit code: $?"
		script_cmd="python -c \"from showdialog import show_msg; show_msg(title=\\\"\\\",text=\\\"$caption\\\",sectext=\\\"$content\\\")\""
	fi
}

buildscript () {

	script_vars="SYE_TIME='$script_time'${NEWLINE}SYE_EXCL='$script_excl'${NEWLINE}SYE_CMD='$script_cmd'${NEWLINE}"
	echo "$script_vars" | cat - .template.sh >$script_file
	chmod +x $script_file

	COLOR="$GREEN"
	block "Script was saved to ${COLOR}$script_file${RESET}"
	block "" n
	ls -alihQ --color=none $script_file
	block "" n
	file $script_file
	echo
}

cronconfig () {

	COLOR="$PURPLE"
	block "Add cron task for autorun? [Y/n] " n
	echo -ne "$COLOR"
	read add
	echo -ne "$RESET"

	# if it's a latin or cyrillic letter N
	# (\s* means no matter how much spaces before),
	# exit from the script
	if [[ $add =~ ^\s*[NnНн] ]]
	then echo && exit
	fi

	task="@reboot env PATH='$PATH' DISPLAY=$DISPLAY DESKTOP_SESSION=$DESKTOP_SESSION bash \"$script_file\""
	block "Generated task:"
	block "$task"

	# Get the crontab contents, if it exists
	crontab=$(crontab -l) || crontab=''
	# Add to it \n, generated task, \n
	echo "$crontab${NEWLINE}$task${NEWLINE}" | crontab -

	# Show updated crontab for debug reasons
	block "${BOLD}New crontab content:${RESET}"
	crontab -l
	echo
}

main () {
	clear
	about
	safetime
	whitelist
	notifycmd
	buildscript
	cronconfig
}

main
