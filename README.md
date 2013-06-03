Final Project for CSPP51050 at UChicago.
=======================================================

This is a command-line interpretation of the excellent
Notational Velocity Mac OS X app created by Zachary Schneirov,
available at http://notational.net/.

All credit to him for creating an amazing app.

Notes:

1) This app was written in Ruby 2.0.0p0.
   Other versions of Ruby have not been tested.

2) This app requires a Unix operating system.

3) This app creates a bin/nvCL directory in your $HOME directory.
   It stores your Dropbox config file here as .token.txt

4) This app requires a Dropbox account.
   On your first action, you will be asked to "Allow" the app to
   access your Dropbox account.
   All files will then be stored in the Apps/Notational Data CL folder

Install:

To install, download the app. I recommend moving the included files to ~/bin/nvCL.

You can make a global shortcut to the app by setting your $PATH to include
the directory where you plan to store the nvCL folder.

Example:
  
    export $PATH = ~/bin/nvCL			      //on command line

    export PATH=${PATH}:/Users/andrewmelis/bin/nvCL   //in ~/.bash_profile

Enjoy!

Feel free to contact me at andrewmelis@gmail.com with questions

