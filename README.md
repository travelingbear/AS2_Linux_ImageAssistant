# AS2 Linux Image Creation Wizard

**What is?**
------------

It is a set of scripts to provide a 'wizard' like experience for users creating AS2 Linux images

**What is included?**
---------------------

It's a set of 8 scripts, which are:
   - MainMenu.sh -> this is where you can start the app
   - AddApplications.sh -> Add applications you have installed in your Image Builder
   - ListApplications.sh -> List the applications you have added with AddApplications.sh
   - TestApplications.sh -> Test the applications you have added with AddApplications.sh
   - RemoveApplication.sh -> Remove the applications you have added with AddApplications.sh
   - CreateSessionScript.sh -> Opens a new wizard to help you create a Session Script and configure your config.json file
   - CreateEnvVariables.sh -> Opens a new wizard to help you create a script that exports environment variables to your session.
   - CreateImage.sh -> It creates... the image

**Pre-requisites**
------------------
 - It goes without saying that you need git to clone: ```sudo yum update && sudo yum install git -y```

**How to use?**
---------------

  1. (optional) You can download all the files one by one to your Image Builder
  2. Git clone them like this: ```git clone https://github.com/travelingbear/AS2_Linux_ImageAssistant --depth 1 --branch=main ~/MyFiles/Image_Assistant_Scripts/```
  3. Make the files executable: ```chmod ugo+x ~/MyFiles/Image_Assistant_Scripts/*.sh```
  4. Execute MainMenu.sh: ```~/MyFiles/Image_Assistant_Scripts/MainMenu.sh```

**What's next?**
----------------

 - The 'optimization' seems to not make much difference in almost all the cases I have tested. It's possible to create an automated method for that, I just haven't found a time for that.
