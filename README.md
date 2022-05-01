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

  1. You can download all the files one by one to your Image Builder OR
  2. Git clone them like this: ```git clone https://github.com/travelingbear/AS2_Linux_ImageAssistant --depth 1 --branch=main ~/MyFiles/Image_Assistant_Scripts/```
  3. Make the files executable: ```chmod ugo+x ~/MyFiles/Image_Assistant_Scripts/*.sh```
  4. Execute MainMenu.sh: ```~/MyFiles/Image_Assistant_Scripts/MainMenu.sh```

