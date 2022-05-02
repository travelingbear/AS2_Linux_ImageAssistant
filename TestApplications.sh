#!/bin/bash
#Just a simple script to test the applications in the catalog
bold=$(tput bold)
normal=$(tput sgr0)

#List the applications and save them in a json file
sudo AppStreamImageAssistant list-applications > ~/AS2ImageAssistant/as2_app_list.json	

#Extracts the Name values of the applications in the json file
apps_to_test=$(cat ~/AS2ImageAssistant/as2_app_list.json | jq -r '.applications[] .Name')

#Constructs a menu on the screen
clear
echo "#################################################################"
echo "#                                                               #"
echo "#    These are the current applications in the App Catalog:     #"
echo "#                                                               #"
echo "#################################################################"
echo ""
echo "APP_NAME" "ABSOLUTE_PATH" > ~/AS2ImageAssistant/app_list.txt
echo "--------" "-------------" >> ~/AS2ImageAssistant/app_list.txt
bash -c "paste <(cat ~/AS2ImageAssistant/as2_app_list.json | jq -r '.applications[] .Name') <(cat ~/AS2ImageAssistant/as2_app_list.json | jq -r '.applications[] .AbsoluteAppPath') >> ~/AS2ImageAssistant/app_list.txt"
cat ~/AS2ImageAssistant/app_list.txt | sed -r 's/\s+/ /g' | column -t -s' '
echo ""
echo "-----------------------------------------------------------------"
echo ""

#Constructs the menu based on the application list
PS3="Choose an app to test: "
var_menu=$(cat ~/AS2ImageAssistant/as2_app_list.json | jq -r '.applications[] .AbsoluteAppPath')
options=($var_menu Exit)
select menu in "${options[@]}";
do
  if [[ $menu == "Exit" ]]; then
    exit
  else
	#If the user didn't cancel, then ask which user to test TEST or ADMIN
    if (whiptail --title "Test Application" --yesno "Would you like to run as ADMIN (to save the settings) or as TEST (to... test)?" 12 78  --no-button "ADMIN" --yes-button "TEST"); then
	
		#Checks if as2-test-user exists. If not, create it.
		does_testuser_exist=$(getent passwd | grep -c '^as2-test-user:')
		if [[ $does_testuser_exist == 0 ]]; then    #if it doesn't exist
			#Creates a test user to test the applications
			sudo useradd -m as2-test-user 2> /dev/null
		else
			#Kills any process owned by as2-test-user; then removes it
			sudo killall -u as2-test-user 2> /dev/null
			sudo userdel as2-test-user 2> /dev/null
			sudo rm -rf /home/as2-test-user 2> /dev/null
			#And THEN creates it again as a NEW test user to test the applications
			sudo useradd -m as2-test-user 2> /dev/null
		fi

		#Checks if as2-test-user is part of the xhost. If not, add it
		is_present_xhost=$(xhost | grep as2-test-user)
		if [[ ! $is_present_xhost ]]
			then 
			#Adds the user to the xhost, so it can use X to open desktop apps
			xhost si:localuser:as2-test-user 2> /dev/null
		fi
		
		#Runs the command as as2-test-user in the as2-test-user enviroment
		clear
		echo ""
		read -p "Press enter to run $menu as ${bold}as2-test-user${normal} (you can ignore the warnings)..."
		echo ""
		sudo -H -u as2-test-user gnome-terminal -- bash -c $menu | grep 'Error constructing proxy for org.gnome.Terminal' &> /dev/null
		exitmessage=$?
		
		#There is an issue with Gnome terminal that can prevent an app from being opened from a different user.
		#If the EXITMESSAGE got from GREP above is 0, then it tries to kill the user and try again
		if [[ $exitmessage == 0 ]]; then
			#Kills any process owned by as2-test-user; then removes it
			sudo killall -u as2-test-user 2> /dev/null
			sudo userdel as2-test-user 2> /dev/null
			sudo rm -rf /home/as2-test-user 2> /dev/null
			#And then creates it again as a NEW test user to test the applications
			sudo useradd -m as2-test-user 2> /dev/null
			#And THEN runs the command again
			sudo -H -u as2-test-user gnome-terminal -- bash -c $menu | grep 'Error constructing proxy for org.gnome.Terminal' &> /dev/null
		fi
		echo ""
		echo ""
		clear
		echo ""
		
	else
		#Runs the command as ImageBuilderAdmin
		clear
		echo ""
		echo "Press enter to run $menu as ${bold}ImageBuilderAdmin${normal}"
		read -p "You can make changes to the app if it supports it"
		echo ""
		$menu 2> /dev/null
		#Ask the user if they want to save the configuration (if supported)
		if (whiptail --title "Test Application" --yesno "Would you like to save the application settings (if supported)?" 12 78); then
			sudo rsync -a -v --delete ~/.config/ /etc/skel/.config  2> /dev/null
			clear
		fi
	fi
  fi
done
exit
