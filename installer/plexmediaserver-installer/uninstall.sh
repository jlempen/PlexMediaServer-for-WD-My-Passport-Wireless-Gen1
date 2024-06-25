#!/bin/sh

###########################################################################
### Uninstaller script for Plex Media Server on WD My Passport Wireless ###
### Rev 0.1 for PMS v1.16.5.1554										    ###
### (c) 2016 by Jürg Lempen - jlempen@me.com				 		    ###
###########################################################################


echo ""
echo "Plex Media Server v1.16.5.1554 for WD My Passport Wireless Uninstaller script (c) 2016 by Jürg Lempen - jlempen@me.com"
echo ""
echo "This script will uninstall the Plex Media Server application, delete all PMS startup scripts from the file system and re-enable the Western Digital media indexing services."
echo ""
echo "It will also re-enable the Twonky Media Server and set the power profile to 'Battery Life'."
echo ""
echo "Your media library and the Plex Media Server database will remain on the hard disk and won't be affected by this uninstaller."
echo ""
echo "Please be aware that this script will only uninstall a Plex Media Server installed by my installer package."
echo ""
echo "A clean working install of PMS made by following my HOWTO on the PLEX FORUMS should uninstall properly as well."
echo ""
echo "The uninstaller is very likely to fail on customised installs."
echo ""


# Ask for confirmation
read -r -p "Do you wish to proceed? [y/N] " response

case $response in
    [yY][eE][sS]|[yY])

        clear
        ;;

    *)

        echo "Aborting!"
        echo ""
        exit 0
        ;;

esac


# Check if the PMS directory exists
if test -d /DataVolume/Plex\ Media\ Server
then

	# Directory exists!
	echo "Found a Plex Media Server directory!"
	echo ""

else

	# Directory doesn't exist.
	echo "No Plex Media Server directory found in '/DataVolume/'!"
	echo "Aborting the uninstaller script."
	echo ""
	exit 1

fi


# Check if the PMS application directory exists
if test -d /DataVolume/Plex\ Media\ Server/Application
then

	# Directory exists!
	echo "Found a Plex Media Server install in the default install directory!"
	echo "Removing the application..."
	echo ""

	# Stop the PMS server
	if test -f /etc/init.d/S92plexmediaserver
	then

		echo "Stopping the Plex Media Server..."
		echo ""
		cd
		sudo bash /etc/init.d/S92plexmediaserver stop
		echo ""

	else

		echo "Plex Media Server is installed, but one or several startup scripts are missing!"
		echo "Attempting to proceed with a clean uninstall..."
		echo ""

	fi

	echo "Removing the Plex Media Server application directory from '/DataVolume/Plex Media Server/'..."
	echo ""
	sudo rm -R /DataVolume/Plex\ Media\ Server/Application

else

	# Directory doesn't exist.
	echo "No Plex Media Server install found in the default install directory!"
	echo "This looks like a broken PMS install..."
	echo "Attempting to proceed with a clean uninstall..."
	echo ""

fi


# Remove the startup scripts from the file system
echo "Removing the startup scripts from the file system..."
echo ""

if test -f /etc/init.d/S92plexmediaserver
then

	echo "Removing the script 'S92plexmediaserver' from the '/etc/init.d/' directory..."
	echo ""
	sudo rm /etc/init.d/S92plexmediaserver

else

	echo "Can't find the script 'S92plexmediaserver' in '/etc/init.d/'. Proceeding..."
	echo ""

fi

if test -f /etc/default/plexmediaserver
then

	echo "Removing the script 'plexmediaserver' from the '/etc/default/' directory..."
	echo ""
	sudo rm /etc/default/plexmediaserver

else

	echo "Can't find the script 'plexmediaserver' in '/etc/default/'. Proceeding..."
	echo ""

fi

if test -f /usr/local/bin/plexmediaserver
then

	echo "Removing the script 'plexmediaserver' from the '/usr/local/bin/' directory ..."
	echo ""
	sudo rm /usr/local/bin/plexmediaserver

else

	echo "Can't find the script 'S92plexmediaserver' in '/usr/local/bin/'. Proceeding..."
	echo ""

fi


echo "Restoring the default Western Digital indexing services..."
echo ""

# Restore the WD services
if test -d /etc/init.d/DISABLED
then

	if test -f /etc/init.d/DISABLED/S85wdmcserverd
	then

		echo "Restoring the 'S85wdmcserverd' service..."
		echo ""
		sudo mv -f /etc/init.d/DISABLED/S85wdmcserverd /etc/init.d/
		cd
		sudo bash /etc/init.d/S85wdmcserverd start
		echo ""

	else

		if test -f /etc/init.d/S85wdmcserverd
		then

			echo "Restoring the 'S85wdmcserverd' service..."
			echo ""
			cd
			sudo bash /etc/init.d/S85wdmcserverd start
			echo ""

		else

			echo "The 'S85wdmcserverd' script file is missing on your system!"
			echo "Your WD My Passport Wireless system files are inconsistent."
			echo "Please reset your WD My Passport Wireless to its default settings in the Web Interface at http://192.168.60.1."
			echo ""

		fi

	fi

	if test -f /etc/init.d/DISABLED/S92wdnotifierd
	then

		echo "Restoring the 'S92wdnotifierd' service..."
		echo ""
		sudo mv -f /etc/init.d/DISABLED/S92wdnotifierd /etc/init.d/
		cd
		sudo bash /etc/init.d/S92wdnotifierd start
		echo ""

	else

		if test -f /etc/init.d/S92wdnotifierd
		then

			echo "Restoring the 'S92wdnotifierd' service..."
			echo ""
			cd
			sudo bash /etc/init.d/S92wdnotifierd start
			echo ""

		else

			echo "The 'S92wdnotifierd' script file is missing on your system!"
			echo "Your WD My Passport Wireless system files are inconsistent."
			echo "Please reset your WD My Passport Wireless to its default settings in the Web Interface at http://192.168.60.1."
			echo ""

		fi

	fi

	# Remove the DISABLED directory
	rmdir /etc/init.d/DISABLED

else

	if test -f /etc/init.d/S85wdmcserverd
	then

		echo "Restoring the 'S85wdmcserverd' service..."
		echo ""
		cd
		sudo bash /etc/init.d/S85wdmcserverd start
		echo ""

	else

		echo "The 'S85wdmcserverd' script file is missing on your system!"
		echo "Your WD My Passport Wireless system files are inconsistent."
		echo "Please reset your WD My Passport Wireless to its default settings in the Web Interface at http://192.168.60.1."
		echo ""

	fi

	if test -f /etc/init.d/S92wdnotifierd
	then

		echo "Restoring the 'S92wdnotifierd' service..."
		echo ""
		cd
		sudo bash /etc/init.d/S92wdnotifierd start
		echo ""

	else

		echo "The 'S92wdnotifierd' script file is missing on your system!"
		echo "Your WD My Passport Wireless system files are inconsistent."
		echo "Please reset your WD My Passport Wireless to its default settings in the Web Interface at http://192.168.60.1."
		echo ""

	fi

fi


echo "Restoring the Twonky Media Server..."
echo ""

# Enable the Twonky Media Server
sudo echo "enabled" > /etc/nas/service_startup/twonky

# Set permissions and ownership of the Twonky status script
sudo chmod 775 /etc/nas/service_startup/twonky
sudo chown 1000:share /etc/nas/service_startup/twonky

# Start the Twonky server
cd
sudo bash /etc/init.d/S92twonkyserver start
echo ""


echo "Setting the power profile to 'BATTERY LIFE'..."
echo ""

# Set the power profile to PERFORMANCE
sudo echo "powerprofile=max_life" > /etc/power.conf

# Set permissions and ownership of the power status script
sudo chmod 775 /etc/power.conf
sudo chown 1000:share /etc/power.conf

# Restart the power startup script
cd
sudo bash /etc/init.d/S98powerprofile restart
echo ""


# Ask to remove the PMS database
read -r -p "Do you wish to remove the Plex Media Server database as well? [y/N] " response
echo ""

case $response in
    [yY][eE][sS]|[yY])

        echo "Removing the Plex Media Server database..."
        echo ""
        rm -R /DataVolume/Plex\ Media\ Server
        ;;

    *)

		echo "Your Plex Media Server database remains in '/DataVolume/Plex Media Server/Library/'."
        echo ""
        ;;

esac

# Display some final text before exiting

echo ""
echo "The Plex Media Server has been removed from your system."
echo ""
echo "Your media library remains in its original location."
echo ""
echo "BYE!"
echo ""


# Exit from the script with success (0)
exit 0
