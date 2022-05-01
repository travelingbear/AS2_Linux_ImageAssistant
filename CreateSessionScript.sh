#!/bin/bash
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
echo "${bold}3rd step${normal} - Update CONFIG.JSON's 'Filename' value."
echo ""
echo ""
echo " -( Some tips for you )------------------------------------------------"
echo ""
echo "  1. Review this page to see an example:"
echo -e "     \e[34mhttps://docs.aws.amazon.com/appstream2/latest/developerguide/create-session-scripts.html\e[0m"
echo ""
echo "  2. If you dont have 'Arguments' to declare, leave them blank \"\""
echo ""
echo -e "  3. Validate your config.json with \e[34mhttps://jsonlint.com\e[0m"
echo ""
echo " ----------------------------------------------------------------------"
echo ""
read -p "Hit enter to open GEDIT - Dont forget to save before closing it."
sudo gedit /opt/appstream/SessionScripts/config.json 2> /dev/null
clear
echo ""
echo "Script created successfully."
echo ""
read -p "That's it! Hit enter to return to the main menu..."
exit

