#!/bin/bash
#A whiptail script to create the image
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
read -p "Review the applications above and hit enter to continue..."

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
	sudo /usr/bin/AppStreamImageAssistant create-image --name $as2_image_name > ~/AS2ImageAssistant/create_result.json
	create_result=$(cat ~/AS2ImageAssistant/create_result.json | jq -r '.message')
	if [[ $create_result == "Success" ]]; then 
		whiptail --msgbox --title "Create the image" "The image was created successfully!" 12 78
	else
		whiptail --msgbox --title "Create the image" "There was an error creating the image. Here is the message:\n\n-> $create_result" 12 78
	fi
	exit
else
	exit
	
fi
