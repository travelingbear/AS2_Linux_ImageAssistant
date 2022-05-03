#!/bin/bash

#CreateEnvVariables.sh
#Just a simple script to guide users to create/update their Environment Variables

bold=$(tput bold)
normal=$(tput sgr0)
clear
echo "#################################################################"
echo "#                                                               #"
echo "#   Environment Variables assistant - It's more like a guide    #"
echo "#                                                               #"
echo "#################################################################"
echo ""
echo "--------"
echo "${bold}1st step${normal} - Created the folder /etc/profile.d/"
echo "(if it's not created already)"
echo ""
read -p "Hit enter to continue..."
#If the folder /etc/profile doesn’t exist, run the following command to create it.
[ ! -d /etc/profile.d/ ] && sudo mkdir -p /etc/profile.d
echo ""
echo "--------"
echo "${bold}2nd step${normal} - Created an executable file called 'my-environment.sh' in /etc/profile.d/"
echo "(if it's not created already)"
echo ""
read -p "I will now open GEDIT so you can paste your script - Hit enter to open GEDIT"
if [ ! -f /etc/profile.d/my-environment.sh ]; then 
	sudo touch /etc/profile.d/my-environment.sh
	sudo chmod ugo+rwx /etc/profile.d/my-environment.sh
	echo '#!/bin/bash' > /etc/profile.d/my-environment.sh
	echo "" >> /etc/profile.d/my-environment.sh
	echo "##Examples:" >> /etc/profile.d/my-environment.sh
	echo '#export Department="Marketing"' >> /etc/profile.d/my-environment.sh
	echo '#export Environment="QA"' >> /etc/profile.d/my-environment.sh
	echo "" >> /etc/profile.d/my-environment.sh
	echo "##Put your script below this line" >> /etc/profile.d/my-environment.sh
	echo "" >> /etc/profile.d/my-environment.sh
	sudo gedit /etc/profile.d/my-environment.sh 2> /dev/null
	sudo chmod ugo+x /etc/profile.d/my-environment.sh
else
	sudo gedit /etc/profile.d/my-environment.sh 2> /dev/null
	sudo chmod ugo+x /etc/profile.d/my-environment.sh
fi

echo ""
echo "--------"
echo "${bold}3rd step${normal} - Check if the Environment Variable script works for as2-test-user:"
echo ""
echo "  1. I will change the session to as2-test-user in the terminal"
echo ""
echo "  2. You can test environment variables with 'echo', like 'echo \$Department'"
echo ""
echo "  3. Once finished, type exit to return to the previous session."
echo ""
echo ""
read -p "Hit enter to open the new bash console"
echo ""

#Kills any process owned by as2-test-user; then removes it
sudo killall -u as2-test-user 2> /dev/null
sudo userdel as2-test-user 2> /dev/null
sudo rm -rf /home/as2-test-user 2> /dev/null
#And then creates it again as a NEW test user to test the applications
sudo useradd -m as2-test-user 2> /dev/null
echo -e 'Pa55w0rdas2\nPa55w0rdas2\n' | sudo passwd as2-test-user
#And opens the session
echo "Take note of the password for the test user: ${bold}Pa55w0rdas2${normal}"
su - as2-test-user
echo ""
clear

#Kills any process owned by as2-test-user; then removes it
sudo killall -u as2-test-user 2> /dev/null
sudo userdel as2-test-user 2> /dev/null
sudo rm -rf /home/as2-test-user 2> /dev/null

whiptail --msgbox --title "Create Environment Variables" "Script created successfully!" 12 78
exit
