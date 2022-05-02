#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#create the getfilestool.sh in ~ and make it executable
echo "#!/bin/bash" > ~/AS2ImageAssistant/getfilestool.sh
echo "lsof -p \$(pstree -p $1 | grep -o '([0-9]\+)' | grep -o '[0-9]\+' | tr '\012' ,)|grep REG | sed -n '1!p' | awk '{print $9}'|awk 'NF'" >> ~/AS2ImageAssistant/getfilestool.sh
chmod u+x ~/AS2ImageAssistant/getfilestool.sh

#Function to clear variables
clear_var () {
	unset as2_application_name
	unset as2_app_display_name
	unset command_display_name
	unset as2_app_absolute_path
	unset bash_application_name
	unset app_to_lower_case
	unset as2_application_pid
	unset as2_app_icon_location
	unset command_icon_location
	unset as2_app_working_directory
	unset command_working_directory	
}

##Create a window to query App information##

#QUESTION 1 - What's the application name?
until [[ $as2_application_name != "" ]]; do
	as2_application_name=$(whiptail --inputbox "*Required\n\nApplication Name (i.e. Mahjongg_1.0)" 12 78 --title "Add Application" 3>&1 1>&2 2>&3)
	exitstatus=$?
	if [ $exitstatus = 1 ]; then
	exit
	fi
done

#QUESTION 2 - What's the application Display Name?
as2_app_display_name=$(whiptail --inputbox "*Optional\n\nApplication DISPLAY Name (i.e. Mahjongg)" 12 78 --title "Add Application" 3>&1 1>&2 2>&3)
[[ ! -z "$as2_app_display_name" ]] && command_display_name="--display-name $as2_app_display_name" || command_display_name=""
exitstatus=$?
if [ $exitstatus = 1 ]; then
exit
fi

#QUESTION 2.5 - Does your application run INSIDE bash?
if (whiptail --title "Add Application" --yesno "Is the application a SHELL or a DESKTOP application?" 12 78  --no-button "DESKTOP" --yes-button "SHELL"); then
	if (whiptail --title "Add Application" --yesno "Do you already have a script to call the app in a different bash window?" 12 78); then
		echo "Cool, moving on..."
	else
		whiptail --msgbox --title "Add Application" "I will open a different assistant to help you create a script to call your application..." 12 78
		app_to_lower_case=$(echo $as2_application_name | head -n1 | awk '{print $1;}' | tr '[:upper:]' '[:lower:]')
		clear
		echo ""
		echo "Ok, I will now open GEDIT for you so you can create a script like this:"
		echo ""
		echo "########################### Script Start ##############################"
		echo ""
		echo ""
		echo "#!/bin/bash"
		echo "#This is a simple script to call my bash application in AppStream"
		echo ""
		echo "gnome-terminal -- bash -c ${bold}MY_APPLICATION${normal}"
		echo ""
		echo ""
		echo "############################ Script End ##############################"
		echo ""
		echo "I will create a new file as ${bold}/usr/local/bin/$app_to_lower_case.sh${normal}"
		echo "You can change the name later if you want."
		echo ""
		if [[ ! -f /usr/local/bin/$app_to_lower_case.sh ]]
		then 
			sudo touch /usr/local/bin/$app_to_lower_case.sh 
			sudo chmod ugo+rwx /usr/local/bin/$app_to_lower_case.sh 
			echo '#!/bin/bash' > /usr/local/bin/$app_to_lower_case.sh
			echo '' >> /usr/local/bin/$app_to_lower_case.sh
			echo '#####################################################################' >> /usr/local/bin/$app_to_lower_case.sh
			echo '#                                                                   #' >> /usr/local/bin/$app_to_lower_case.sh
			echo '# This is a simple script to call my bash application in AppStream  #' >> /usr/local/bin/$app_to_lower_case.sh
			echo '#                                                                   #' >> /usr/local/bin/$app_to_lower_case.sh
			echo '#####################################################################' >> /usr/local/bin/$app_to_lower_case.sh
			echo '' >> /usr/local/bin/$app_to_lower_case.sh
			echo "gnome-terminal -- bash -c $app_to_lower_case" >> /usr/local/bin/$app_to_lower_case.sh
			echo '' >> /usr/local/bin/$app_to_lower_case.sh
			echo '' >> /usr/local/bin/$app_to_lower_case.sh
			echo '###########################################################################' >> /usr/local/bin/$app_to_lower_case.sh
			echo '#                                                                         #' >> /usr/local/bin/$app_to_lower_case.sh
			echo "#     You can close this GEDIT window If the command above is correct     #" >> /usr/local/bin/$app_to_lower_case.sh
			echo '#                                                                         #' >> /usr/local/bin/$app_to_lower_case.sh
			echo "# Otherwise, update the name above (after 'bash -c ____'), save the file  #" >> /usr/local/bin/$app_to_lower_case.sh
			echo '# and save and close this window                                          #' >> /usr/local/bin/$app_to_lower_case.sh
			echo '#                                                                         #' >> /usr/local/bin/$app_to_lower_case.sh
			echo '###########################################################################' >> /usr/local/bin/$app_to_lower_case.sh
			sudo chmod ugo+x /usr/local/bin/$app_to_lower_case.sh 
			read -p "Hit enter to open GEDIT as sudo"
			sudo gedit /usr/local/bin/$app_to_lower_case.sh 2> /dev/null
		else
			sudo gedit /usr/local/bin/$app_to_lower_case.sh 2> /dev/null
		fi
		echo ""
		echo ""
		echo ""
		echo "Remember that ${bold}/usr/local/bin/$app_to_lower_case.sh${normal} is now the 'ABSOLUTE PATH' of your app."
		echo "You need to inform it in the next screen."
		echo ""
		read -p "COPY the path above and hit enter to return to the assistant..."
	fi
fi


#QUESTION 3 - Do you know the ABSOLUTE PATH of your application
if (whiptail --title "Add Application" --yesno "Do you know the ABSOLUTE PATH of your application/script?\n(i.e. /usr/bin/mahjongg or /usr/local/bin/myscript.sh)" 12 78); then
    until [[ $as2_app_absolute_path != "" ]]; 
    do
		as2_app_absolute_path=$(whiptail --inputbox "*Required\n\nWhat's the absolute path? (i.e. /usr/bin/mahjongg)" 12 78 --title "Add Application" 3>&1 1>&2 2>&3)
		exitstatus=$?
		if [ $exitstatus = 1 ]; then
		exit
		fi
	done
else
    if (whiptail --title "Add Application" --yesno "Are you able to open the application from the command line?" 12 78); then
		until [[ $bash_application_name != "" ]]; 
		do
			bash_application_name=$(whiptail --inputbox "*Required\n\nCool, what do you type to open it (i.e. mahjongg)?" 12 78 --title "Add Application" 3>&1 1>&2 2>&3)
			#Look for the absolute path using WHICH command
			as2_app_absolute_path=$(which $bash_application_name)
			if [ -z "$as2_app_absolute_path" ]; then
				whiptail --msgbox --title "Add Application" "I couldn't find any path for $bash_application_name.\nPlease contact your software developer for support." 12 78
				exit
			fi
			exitstatus=$?
			if [ $exitstatus = 1 ]; then
			exit
			fi
		done
	else
		#Ask to open the application, so the app can be searched
		whiptail --msgbox --title "Add Application" "Ok, I will try to find it based on the APPLICATION NAME you typed earlier.\n\nFirst, open the application in the Applications menu. Then come back to this window and hit enter to continue." 12 78
		
		#the idea here is to go to the terminal, search for the Parent PID of the process and then look for its absolute path using the getfilestool.sh
		if (whiptail --title "Add Application" --yesno "Is the application running now?" 12 78); then
			clear #clear the lines to make it easier to spot the PPID
			app_to_lower_case=$(echo $as2_application_name | head -n1 | awk '{print $1;}' | tr '[:upper:]' '[:lower:]')
			echo ""
			echo "I am now looking for $app_to_lower_case"
			echo ""
			echo "##############################################################"
			echo "#                                                            #"
			echo "#   Which of the items in the list is most likely your app?  #"
			echo "#                                                            #"
			echo "#      Take note of the ${bold}number to the right of the name${normal}      #"
			echo "#            and return to the previous window.              #"
			echo "#                                                            #"
			echo "##############################################################"
			echo ""
			ps -ef | grep $app_to_lower_case | grep -v "grep" | grep -v "sudo" | awk {'print "-> " $8 " = " $3'}
			echo ""
			read -p "Press any key to go back to the assistant ..."
		else
			whiptail --msgbox --title "Add Application" "You can initiate the application next time you open this assistant. Bye!" 12 78
			exit
		fi
		#Show the results and ask the user to select the PID that is most likely the app
		until [[ $as2_application_pid > 0 ]]; do
			as2_application_pid=$(whiptail --inputbox "Type PID NUMBER you got from the last screen:" 12 78 --title "Add Application" 3>&1 1>&2 2>&3)
			exitstatus=$?
			if [ $exitstatus = 1 ]; then
			exit
			fi
		done
		
		#show the possible paths so user can choose
		if (whiptail --msgbox --title "Add Application" "I will now list the absolute paths I can find. Copy the one that you believe it's correct if there is more than one." 12 78); then
			clear #clear the lines to make it easier to spot the PPID
			echo "I am now looking for PPID $as2_application_pid"
			echo ""
			echo "############################################################"
			echo "#                                                          #"
			echo "# Which of the items in the list is most likely your app's #"
			echo "#                    ${bold}ABSOLUTE PATH?${normal}                        #"
			echo "#                                                          #"
			echo "#     Copy the path you believe it's the correct below.    #"
			echo "#                                                          #"
			echo "#                                                          #"
			echo "# If you are not sure which one, open a new bash terminal  #"
			echo "#             and test the path(s) below                   #"
			echo "#                                                          #"
			echo "############################################################"
			echo ""
			sudo ~/AS2ImageAssistant/getfilestool.sh $as2_application_pid | grep $app_to_lower_case | grep -v "/usr/lib" | grep -v "/usr/share/" | grep -v "/etc/" | awk {'print "-> " $1 " = " $9'}
			echo ""
			read -p "Copy the path you see above, then press any key to go back to the assistant ..."
		else
			whiptail --msgbox --title "Add Application" "You can initiate the application next time you open this assistant. Bye!" 12 78
			exit
		fi
		
		#Ask the user to inform the ABSOLUTE PATH of the app		
		if (whiptail --title "Add Application" --yesno "Did you get the app's absolute path?" 12 78); then
			until [[ $as2_app_absolute_path != "" ]]; 
			do
				as2_app_absolute_path=$(whiptail --inputbox "*Required\n\nWhat's the absolute path? (i.e. /usr/bin/mahjongg)" 12 78 --title "Add Application" 3>&1 1>&2 2>&3)
				exitstatus=$?
				if [ $exitstatus = 1 ]; then
				exit
				fi
			done
		else
			whiptail --msgbox --title "Add Application" "Please contact your software developer for support." 12 78
			exit
		fi	
	fi
fi

#QUESTION 4 - What's the ICON image file location?
as2_app_icon_location=$(whiptail --inputbox "*Optional\n\nWhat's the ICON image file location?" 12 78 --title "Add Application" 3>&1 1>&2 2>&3)
[[ ! -z "$as2_app_icon_location" ]] && command_icon_location="--absolute-icon-path $as2_app_icon_location" || command_icon_location=""
exitstatus=$?
if [ $exitstatus = 1 ]; then
exit
fi

#QUESTION 5 - What's the app's working directory?
as2_app_working_directory=$(whiptail --inputbox "*Optional\n\nWhat's the app's working directory?" 12 78 --title "Add Application" 3>&1 1>&2 2>&3)
[[ ! -z "$as2_app_working_directory" ]] && command_working_directory="--working-directory $as2_app_working_directory" || command_working_directory=""
exitstatus=$?
if [ $exitstatus = 1 ]; then
exit
fi

#WRAPPING UP and executing the command to add the app
clear #clear the lines 

echo ""
echo "#################################################################"
echo "#                                                               #"
echo "# Ok, I will add the following application:                     #"
echo "#                                                               #"
echo "#################################################################"
echo ""
echo "-> Application Name: $as2_application_name"
echo "-> App Absolute Path: $as2_app_absolute_path"
echo "-> App Display Name: $as2_app_display_name"
echo "-> Absolute Icon Path: $as2_app_icon_location"
echo "-> Working Directory:  $as2_app_working_directory"
echo ""
echo ""
echo ""
read -p "Press enter when you're ready to add the application to the catalog ..."
echo "" > ~/AS2ImageAssistant/add_app_result.json
sudo AppStreamImageAssistant add-application --name $as2_application_name $command_display_name --absolute-app-path $as2_app_absolute_path  $command_icon_location $command_working_directory > ~/AS2ImageAssistant/add_app_result.json
add_app_result=$(cat ~/AS2ImageAssistant/add_app_result.json | jq -r '.message')
if [[ $add_app_result == "Success" ]]; then 
		whiptail --msgbox --title "Add Application" "The application was added successfully!" 12 78
	else
		whiptail --msgbox --title "Add Application" "There was an error adding the application. Here is the message:\n\n-> $add_app_result" 12 78
fi
exit
