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
PS3="Choose an app to test -> configure -> export configuration: "
var_menu=$(cat ~/AS2ImageAssistant/as2_app_list.json | jq -r '.applications[] .AbsoluteAppPath')
var_item_menu=""
options=($var_menu Exit)
select menu in "${options[@]}";
do
  if [[ $menu == "Exit" ]]; then
    exit
  else
    var_item_menu=$menu
    gnome-terminal -- bash -c $menu 2> /dev/null
  fi
done
echo ""
echo "Check if the app is working fine and make all configurations you want to export to the users (if needed)."
echo ""
read -p "Press any key to continue ..."
clear
echo ""
echo "Would like this assistant to 'try' to export the app configuration to the image IF the application supports it?"
echo "(Y/N)"
read as2_allow_config_export
echo ""
if [[ $as2_allow_config_export == "N" ]] || [[ $as2_allow_config_export == "No" ]] || [[ $as2_allow_config_export == "NO" ]] || [[ $as2_allow_config_export == "n" ]] || [[ $as2_allow_config_export == "no" ]]
then
  read -p "Press any key to return to the assistant ..."
  exit
else
	if [[ $as2_allow_config_export == "Y" ]] || [[ $as2_allow_config_export == "y" ]] || [[ $as2_allow_config_export == "Yes" ]] || [[ $as2_allow_config_export == "YES" ]] || [[ $as2_allow_config_export == "yes" ]];	then
	  #Creates the skel directory - This directory will be used to save the Default Application Settings for users.
	  [ ! -d /etc/skel/.config ] && sudo mkdir /etc/skel/.config
	  
	  #Here it will try to find the app configuration folder (the one selected from the menu above) and copy it to skel.
	  if ( ls ~/.config/ | grep -E $var_item_menu ); then
		app_folder=$(ls ~/.config/ | grep -E $var_item_menu)
		sudo cp -R ~/.config/app_folder /etc/skel/.config
		if ( ls /etc/skel/.config | grep -E $var_item_menu ); then
		  echo ""
		  echo "App folder copied successfully!"
		  echo ""
		  read -p "Press any key to return to the assistant ..."
		else
		  echo ""
		  echo "The assistance couldn't copy the configuration folder. Does the application supports it?"
		  echo ""
		  read -p "Press any key to return to the assistant ..."
		fi
	  else 
		  echo ""
		  echo "The assistance couldn't copy the configuration folder. Does the application supports it?"
		  echo ""
		  read -p "Press any key to return to the assistant ..."
	  fi
	else
		echo "Didn't recognize your input. Did you type Y or N?"
	fi
fi
exit
