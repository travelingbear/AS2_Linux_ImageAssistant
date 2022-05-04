#!/bin/bash

#CreateImage.sh
#It lists the applications > asks the user if they want to save the apps configuration > and creates the image.

#generates a list of the applications and save it in the as2_app_list.json
sudo AppStreamImageAssistant list-applications > ~/AS2ImageAssistant/as2_app_list.json

clear
echo ""
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
read -p "Review the applications above and hit enter to continue..."

if (whiptail --title "Create the image" --yesno "Do you want to save the applications settings into the image?" 12 78); then
    
	#Creates the skel directory - This directory will be used to save the Default Application Settings for users.
	[ ! -d /etc/skel/.config ] && sudo mkdir /etc/skel/.config
	
	sudo cp -R ~/.config/* /etc/skel/.config
	if ( ls /etc/skel/.config ); then
		whiptail --msgbox --title "Create the image" "App folder copied successfully!" 12 78
	else
		whiptail --msgbox --title "Create the image" "The assistant couldn't find any configuration folder." 12 78
	fi
fi

#QUESTION - Can I create the image?
clear
echo "Creating the image..."
if (whiptail --title "Create the image" --yesno "Can I create the image?" 12 78); then
    until [[ $as2_image_name != "" ]]; 
    do
		as2_image_name=$(whiptail --inputbox "*Required\n\nInform an UNIQUE image name" 12 78 --title "Create the image" 3>&1 1>&2 2>&3)
		exitstatus=$?
		if [ $exitstatus = 1 ]; then
			exit
		fi
	done
	#Kills any process owned by as2-test-user; then removes it
	sudo killall -u as2-test-user 2> /dev/null
	sudo userdel as2-test-user 2> /dev/null
	sudo rm -rf /home/as2-test-user 2> /dev/null

	#Removes the as2-test-user from xhost
	xhost -si:localuser:as2-test-user 2> /dev/null
	
	#Creates the image
	sudo /usr/bin/AppStreamImageAssistant create-image --name $as2_image_name > ~/AS2ImageAssistant/create_result.json
	create_result=$(cat ~/AS2ImageAssistant/create_result.json | jq -r '.message')
	if [[ $create_result == "Success" ]]; then 
		whiptail --msgbox --title "Create the image" "The image was created successfully!" 12 78
	else
		whiptail --msgbox --title "Create the image" "There was an error creating the image. Here is the message:\n\n-> $create_result" 12 78
		clear
		exit
	fi
fi
