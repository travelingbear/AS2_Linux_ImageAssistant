#!/bin/bash
#Just a simple script to bring the applications in a more readable way
bold=$(tput bold)
normal=$(tput sgr0)

sudo AppStreamImageAssistant list-applications > ~/AS2ImageAssistant/as2_app_list.json

clear

echo "#################################################################"
echo "#                                                               #"
echo "#    These are the current applications in the App Catalog:     #"
echo "#                                                               #"
echo "#################################################################"
echo ""
echo "APP_NAME" "DISPLAY_NAME" "ABSOLUTE_PATH" > ~/AS2ImageAssistant/app_list.txt
echo "--------" "------------" "-------------" >> ~/AS2ImageAssistant/app_list.txt
bash -c "paste <(cat ~/AS2ImageAssistant/as2_app_list.json | jq -r '.applications[] .Name') <(cat ~/AS2ImageAssistant/as2_app_list.json | jq -r '.applications[] .DisplayName') <(cat ~/AS2ImageAssistant/as2_app_list.json | jq -r '.applications[] .AbsoluteAppPath') >> ~/AS2ImageAssistant/app_list.txt"
cat ~/AS2ImageAssistant/app_list.txt | sed -r 's/\s+/ /g' | column -t -s' '
echo ""
read -p "Press any key to return to the assistant ..."
