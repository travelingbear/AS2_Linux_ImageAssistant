#!/bin/bash
#Just a simple script to test the applications in the catalog
bold=$(tput bold)
normal=$(tput sgr0)

sudo AppStreamImageAssistant list-applications > ~/AS2ImageAssistant/as2_app_list.json
apps_to_test=$(cat ~/AS2ImageAssistant/as2_app_list.json | jq -r '.applications[] .Name')
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
PS3="Choose an app to test: "
var_menu=$(cat ~/AS2ImageAssistant/as2_app_list.json | jq -r '.applications[] .AbsoluteAppPath')
options=($var_menu Exit)
select menu in "${options[@]}";
do
  if [[ $menu == "Exit" ]]; then
    exit
  else
    gnome-terminal -- bash -c $menu 2> /dev/null
  fi
done
echo ""
read -p "Press any key to return to the assistant ..."
exit