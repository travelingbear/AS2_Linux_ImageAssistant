#!/bin/bash
#Just a simple script to test the applications in the catalog
bold=$(tput bold)
normal=$(tput sgr0)


#Checks if test-user exists. If not, create it.
does_testuser_exist=$(getent passwd | grep -c '^test-user:')
if [[ ! $does_testuser_exist ]]
	then 
	#Creates a test user to test the applications
	sudo useradd -m test-user 2> /dev/null
fi

#Checks if test-user is part of the xhost. If not, add it
is_present_xhost=$(xhost | grep test-user)
if [[ ! $is_present_xhost ]]
	then 
	#Adds the user to the xhost, so it can use X to open desktop apps
	xhost si:localuser:test-user 2> /dev/null
fi
	
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
		#Runs the command as test-user in the test-user enviroment
		clear
		echo ""
		read -p "Press enter to run $menu as ${bold}test-user${normal} (you can ignore the warnings)..."
		echo ""
		sudo -H -u test-user gnome-terminal -- bash -c $menu
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
		gnome-terminal -- bash -c $menu 2> /dev/null
		echo ""
		echo "------------------------------------"
		echo ""
	fi
  fi
done
exit
