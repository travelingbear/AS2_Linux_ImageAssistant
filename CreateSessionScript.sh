#!/bin/bash

#CreateSessionScript.sh
#Just a simple script to guide users to create/update their SessionScripts

bold=$(tput bold)
normal=$(tput sgr0)
clear
echo "#################################################################"
echo "#                                                               #"
echo "#         Session Script assistant - It's more a guide          #"
echo "#                                                               #"
echo "#################################################################"
echo ""
echo "--------"
echo "${bold}1st step${normal} - Created a folder in /opt/appstream/SessionScripts/custom_scripts/"
echo "(if it's not created already)"
echo ""
read -p "Hit enter to continue..."
#Creates a scripts directory - This directory will be used to save customer scripts for Session Scripts.
[ ! -d /opt/appstream/SessionScripts/custom_scripts/ ] && sudo mkdir /opt/appstream/SessionScripts/custom_scripts/
echo ""
echo "--------"
echo "${bold}2nd step${normal} - Created an executable file called 'my_session_script.sh' in /opt/appstream/SessionScripts/custom_scripts/"
echo ""
read -p "I will now open GEDIT so you can paste your script - Hit enter to open GEDIT"
sudo touch /opt/appstream/SessionScripts/custom_scripts/my_session_script.sh
sudo chmod ugo+rwx /opt/appstream/SessionScripts/custom_scripts/my_session_script.sh
echo '#!/bin/bash' > /opt/appstream/SessionScripts/custom_scripts/my_session_script.sh
echo "" >> /opt/appstream/SessionScripts/custom_scripts/my_session_script.sh
echo "#Put your script below this line" >> /opt/appstream/SessionScripts/custom_scripts/my_session_script.sh
echo "" >> /opt/appstream/SessionScripts/custom_scripts/my_session_script.sh
sudo gedit /opt/appstream/SessionScripts/custom_scripts/my_session_script.sh 2> /dev/null
sudo chmod ugo+x /opt/appstream/SessionScripts/custom_scripts/my_session_script.sh
echo ""
echo "Your script is now set as: "
echo ""
echo " ----------------------------------------------------------------------"
echo "|                                                                      |"
echo "|  /opt/appstream/SessionScripts/custom_scripts/my_session_script.sh   |"
echo "|                                                                      |"
echo " ----------------------------------------------------------------------"
echo ""
read -p "Copy the above and hit enter to continue..."
echo ""
echo "--------"
echo "${bold}3rd step${normal} - Update CONFIG.JSON's 'Filename' value. Check the tips below:"
echo ""
echo "  1. Review this page to see an example:"
echo -e "     \e[34mhttps://docs.aws.amazon.com/appstream2/latest/developerguide/create-session-scripts.html\e[0m"
echo ""
echo "  2. If you dont have 'Arguments' to declare, leave them blank \"\""
echo ""
echo -e "  3. Validate your config.json with \e[34mhttps://jsonlint.com\e[0m"
echo ""
echo "  4. Try to test your script before creating the image"
echo ""
echo ""
read -p "Hit enter to open GEDIT - Dont forget to save before closing it."
sudo gedit /opt/appstream/SessionScripts/config.json 2> /dev/null
clear
#QUESTION - Does it need to run as SUDO?
echo "Creating the script..."
if (whiptail --title "Create Environment Variables" --yesno "Does the script needs to run as SUDO?" 12 78); then

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
	fi
	
	#Adds the user as2-streaming-user to the sudoers file
	sudo usermod -a -G as2-sudo-users as2-streaming-user
	
	whiptail --msgbox --title "Create Session Script" "Script created successfully!" 12 78
else
	whiptail --msgbox --title "Create Session Script" "Script created successfully" 12 78
fi
exit
