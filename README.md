# AS2_Linux_ImageAssistant

**What is?**

It is a set of scripts to provide a 'wizard' like experience for users creating AS2 Linux images

**What is included?**

It's a set of 7 scripts, which are:
   - MainMenu.sh -> this is where you can start the app
   - AddApplications.sh -> Add applications you have installed in your Image Builder
   - ListApplications.sh -> List the applications you have added with AddApplications.sh
   - TestApplications.sh -> Test the applications you have added with AddApplications.sh
   - RemoveApplication.sh -> Remove the applications you have added with AddApplications.sh
   - CreateSessionScript.sh -> Opens a new wizard to help you create a Session Script and configure your config.json file
   - CreateImage.sh -> You guessed it, it creates the image

**How to use?**

  1. You can download all the files as a zip or one by one to your Image Builder
  2. Save those files in /usr/local/bin/as2_image_assistant/ for example
  3. Make the files executable by
     a. cd /usr/local/bin/as2_image_assistant/
     b. chmod ugo+x *
  4. Execute the MainMenu.sh with "/usr/local/bin/as2_image_assistant/MainMenu.sh"

