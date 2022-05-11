#!/bin/bash

#TestApplications.sh
#Just a simple script to test the applications in the catalog

bold=$(tput bold)
normal=$(tput sgr0)

#Before starting the tests, ask the user if any application needs SUDO. Will then set a session variable to run tests AND create the image allowing the as2-streaming-user to run with SUDO.

if (whiptail --title "Test Application" --yesno "Will any of your applications need SUDO?" 12 78); then

	#Set apps_need_sudo with 'TRUE' so the app AND the user will know if they are using SUDO
	apps_need_sudo='TRUE'

	#checks if the group 'as2-sudo-users' exists in the OS
	if [ ! $(getent group as2-sudo-users) ]; then
		groupadd as2-sudo-users
	fi

	#checks if the group 'as2-sudo-users' exists in the sudoers file
	sudo cat /etc/sudoers | grep as2-sudo-users &> /dev/null
	if [[ $? == 1 ]]; then

		#Creates a backup of /etc/sudoers, just in case...
		sudo cp /etc/sudoers /etc/sudoers_as2_old

		#Adds the group 'as2-sudo-users' to the sudoers file allowing it to perform administrative tasks WITHOUT asking for password
		echo "" | sudo tee -a /etc/sudoers
		echo "## AS2 Linux Image Assistant start" | sudo tee -a /etc/sudoers
		echo "## The following line allows users in the group 'as2-sudo-users' to use sudo" | sudo tee -a /etc/sudoers
		echo "%as2-sudo-users ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
		echo "" | sudo tee -a /etc/sudoers
		echo "## AS2 Linux Image Assistant end" | sudo tee -a /etc/sudoers
		echo "" | sudo tee -a /etc/sudoers

		#Adds the user as2-streaming-user to the sudoers file
		sudo usermod -a -G as2-sudo-users as2-streaming-user
	fi
else
	#Set apps_need_sudo with 'FALSE' so the app AND the user will know if they are using SUDO
	apps_need_sudo='FALSE'
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
echo "#                        Using SUDO? ${bold}$apps_need_sudo${normal}                      #"
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

#function to RECREATE the menu for the next time user runs the test in the same session

test_menu() {
	clear
	echo "#################################################################"
	echo "#                                                               #"
	echo "#    These are the current applications in the App Catalog:     #"
	echo "#                                                               #"
	echo "#                        SUDO enabled? ${bold}$apps_need_sudo${normal}                    #"
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

}


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
		
		#Checks if SUDO is needed
		if [[ $apps_need_sudo == 'TRUE' ]]; then
			#Adds the test user to the as2-sudo-users group
			sudo usermod -a -G as2-sudo-users as2-test-user 2> /dev/null
		else
			sudo gpasswd -d as2-test-user as2-sudo-users
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
		echo "Running $menu as ${bold}as2-test-user${normal} (you can ignore the warnings)..."
		read -t 2
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
		test_menu
	
	else
		#Runs the command as ImageBuilderAdmin
		clear
		echo ""
		echo "Running $menu as ${bold}ImageBuilderAdmin${normal}. You can make changes to the app if it supports it"
		read -t 3
		echo ""
		$menu 2> /dev/null
		#Ask the user if they want to save the configuration (if supported)
		if (whiptail --title "Test Application" --yesno "Would you like to save the application settings (if supported)?" 12 78); then
			sudo rsync -a -v --delete ~/.config/ /etc/skel/.config  2> /dev/null
			clear
		test_menu
		fi
	fi
  fi
done
exit
