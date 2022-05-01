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
	echo "3) Remove application"
	echo "4) Test applications"
	echo "5) Create/Update Session Script"
	echo "6) Create Image"
	echo "7) Exit"
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
	"Remove application"
	"Test applications"
	"Create/Update Session Script"
	"Create Image"
	"Exit"
)

PS3="Choose an action (1-${#options[@]}): "

select option in "${options[@]}"; do
    case "$REPLY" in 
        1) ./AddApplications.sh && home_screen ;;
        2) ./ListApplications.sh && home_screen ;;
        3) ./RemoveApplication.sh && home_screen ;;
        4) ./TestApplications.sh && home_screen ;;
        5) ./CreateSessionScript.sh && home_screen ;;
        6) ./CreateImage.sh && home_screen ;;
        7) break ;;
    esac
done
