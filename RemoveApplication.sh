#!/bin/bash
#Just a simple script to easily remove the applications from the catalog
bold=$(tput bold)
normal=$(tput sgr0)

sudo AppStreamImageAssistant list-applications > ~/AS2ImageAssistant/as2_app_list.json
apps_to_remove=$(cat ~/AS2ImageAssistant/as2_app_list.json | jq -r '.applications[] .Name')
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
echo "Type the name of the app you want to ${bold}REMOVE${normal} from catalog (blank to cancel): "
read app_to_remove
if [ $app_to_remove ]; then 
	sudo AppStreamImageAssistant remove-application --name $app_to_remove 
else
	echo "No name was informed"
fi
exitstatus=$?
if [ $exitstatus = 1 ]; then
	exit
fi
echo ""
read -p "Press any key to return to the assistant ..."
exit
