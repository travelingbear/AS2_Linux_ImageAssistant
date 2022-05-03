#!/bin/bash
#This is the main menu of the Image Assistant
set -e
set -u
clear

cd $(dirname $0)

#Creates the AS2 Image Assistant directory - This directory will be used to save lists and other files important for the script to run.
[ ! -d ~/AS2ImageAssistant/ ] && mkdir ~/AS2ImageAssistant/

#Here is where I populate the menu options
home_screen () {
	clear
	echo ""
	echo "     ##########################################"
	echo "     #                                        #"
	echo "     #  AppStream 2.0 Image Assistant (beta)  #"
	echo "     #                                        #"
	echo "     ##########################################"
	echo ""
	
	echo "1) Add applications"
	echo "2) List applications"
	echo "3) Test applications"
	echo "4) Remove application"
	echo "5) Create/Update Session Script"
	echo "6) Create/Update Environment Variables"
	echo "7) Create Image"
	echo "8) Exit"
	echo ""
}
echo ""
echo "     ##########################################"
echo "     #                                        #"
echo "     #  AppStream 2.0 Image Assistant (beta)  #"
echo "     #                                        #"
echo "     ##########################################"
echo ""
options=(
	"Add applications"
	"List applications"
	"Test applications"
	"Remove application"
	"Create/Update Session Script"
	"Create/Update Environment Variables"
	"Create Image"
	"Exit"
)

PS3="Choose an action (1-${#options[@]}): "

select option in "${options[@]}"; do
    case "$REPLY" in 
        1) ./AddApplications.sh && home_screen ;;
        2) ./ListApplications.sh && home_screen ;;
        3) ./TestApplications.sh && home_screen ;;
        4) ./RemoveApplication.sh && home_screen ;;
        5) ./CreateSessionScript.sh && home_screen ;;
        6) ./CreateEnvVariables.sh && home_screen ;;
        7) ./CreateImage.sh && home_screen ;;
        8) break ;;
    esac
done
