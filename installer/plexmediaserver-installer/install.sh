#!/bin/sh

#########################################################################
### Installer script for Plex Media Server on WD My Passport Wireless ###
### Rev 0.1 for PMS v1.16.5.1554										  ###
### (c) 2016 by Jürg Lempen - jlempen@me.com				 		  ###
#########################################################################


echo ""
echo "Plex Media Server v1.16.5.1554 for WD My Passport Wireless"
echo "Installer script (c) 2016 by Jürg Lempen - jlempen@me.com"
echo ""
echo "This installer script will install the Plex Media Server application into the '/DataVolume/Plex Media Server/Application/' directory or upgrade an existing install if one is found in this directory."
echo ""
echo "It will also copy the required PMS startup scripts into the file system and disable the built-in Twonky Media Server, as well as disable some Western Digital media indexing services which unnecessarily slow down the system once PMS is installed."
echo ""
echo "The power profile of your WD My Passport Wireless will be set to 'PERFORMANCE'."
echo ""
echo "If you already have a fully functional Plex Media Server installed through my installer script or by following my HOWTO on the PLEX FORUMS, this installer will upgrade your installation to PMS v1.16.5.1554."
echo ""
echo "If you tried to install PMS by following my HOTWO on the PLEX FORUMS but failed to make it work properly, it is highly advised to manually remove your install before proceeding with this installer script."
echo ""


# Ask for confirmation
read -r -p "Do you wish to proceed? [y/N] " response
echo ""

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

	echo "Plex Media Server directory found!"
	echo ""

else

	echo "Creating Plex Media Server directory..."
	echo ""

	# Create PMS directory
	sudo mkdir -p /DataVolume/Plex\ Media\ Server

	# Set the permissions for the PMS directory
	sudo chmod -R 777 /DataVolume/Plex\ Media\ Server

	# Set the owner for the PMS directory
	sudo chown -R root:root /DataVolume/Plex\ Media\ Server
fi


# Check if the PMS application directory exists
if test -d /DataVolume/Plex\ Media\ Server/Application
then

	# Directory exists!
	echo "Plex Media Server found in '/DataVolume/Plex Media Server/Application/'!"
	echo "Upgrading to v1.16.5.1554..."
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
		echo "Proceeding with a clean install..."
		echo ""

	fi

	# Remove the old PMS application directory
	echo "Removing the old Plex Media Server application directory..."
	echo ""
	rm -R /DataVolume/Plex\ Media\ Server/Application

else

	# Directory doesn't exist.
	echo "Installing Plex Media Server v1.16.5.1554."
	echo ""

fi


echo "Copying the PMS application directory to '/DataVolume/Plex Media Server/'."
echo "This will take a few minutes..."
echo ""

# Copy the PMS application directory to the PMS directory
sudo cp -Rf /DataVolume/plexmediaserver-installer/Application /DataVolume/Plex\ Media\ Server/


echo "Copying the startup scripts to the file system..."
echo ""

# Copy the startup scripts to the file system
sudo cp -f /DataVolume/Plex\ Media\ Server/Application/WDMPW_SCRIPTS/S92plexmediaserver /etc/init.d/
sudo cp -f /DataVolume/Plex\ Media\ Server/Application/WDMPW_SCRIPTS/plexmediaserver /etc/default/
sudo cp -f /DataVolume/Plex\ Media\ Server/Application/Resources/start.sh /usr/local/bin/plexmediaserver


echo "Setting permissions for the startup scripts..."
echo ""

# Set the permissions for the startup scripts
sudo chmod 777 /etc/init.d/S92plexmediaserver
sudo chmod 777 /etc/default/plexmediaserver
sudo chmod 777 /usr/local/bin/plexmediaserver


echo "Setting ownership for the startup scripts..."
echo ""

# Set the owner for the startup scripts
sudo chown root:root /etc/init.d/S92plexmediaserver
sudo chown root:root /etc/default/plexmediaserver
sudo chown root:root /usr/local/bin/plexmediaserver


echo "Setting permissions for the Plex Media Server application directory..."
echo ""

# Set the permissions for the PMS application directory
sudo chmod -R 777 /DataVolume/Plex\ Media\ Server/Application


echo "Setting ownership for the Plex Media Server application directory..."
echo ""

# Set the owner for the PMS application directory
sudo chown -R root:root /DataVolume/Plex\ Media\ Server/Application


echo "Disabling Western Digital indexing services..."
echo ""

# Check if the WD backup directory exists
if test -d /etc/init.d/DISABLED
then

	echo "The backup directory for the WD services script files already exists!"
	echo ""

else

	echo "Creating a backup directory for the WD services script files..."
	echo ""
	sudo mkdir -p /etc/init.d/DISABLED

fi

# Disable a few WD services to optimize the install
if test -f /etc/init.d/S85wdmcserverd
then
	echo "Disabling the 'S85wdmcserverd' service..."
	echo ""
	cd
	sudo bash /etc/init.d/S85wdmcserverd stop
	echo ""
	sudo mv -f /etc/init.d/S85wdmcserverd /etc/init.d/DISABLED/
else
	echo "The 'S85wdmcserverd' service is already disabled."
	echo ""
fi

if test -f /etc/init.d/S92wdnotifierd
	then
	echo "Disabling the 'S92wdnotifierd' service..."
	echo ""
	cd
	sudo bash /etc/init.d/S92wdnotifierd stop
	echo ""
	sudo mv -f /etc/init.d/S92wdnotifierd /etc/init.d/DISABLED/
else
	echo "The 'S92wdnotifierd' service is already disabled."
	echo ""
fi


echo "Disabling the Twonky Media Server..."
echo ""

# Stop the Twonky server
cd
sudo bash /etc/init.d/S92twonkyserver stop
echo ""

# Disable the Twonky Media Server
sudo echo "disabled" > /etc/nas/service_startup/twonky

# Set permissions and ownership of the Twonky status script
sudo chmod 775 /etc/nas/service_startup/twonky
sudo chown 1000:share /etc/nas/service_startup/twonky


echo "Setting the power profile to 'PERFORMANCE'..."
echo ""

# Set the power profile to PERFORMANCE
sudo echo "powerprofile=max_system_performance" > /etc/power.conf

# Set permissions and ownership of the power status script
sudo chmod 775 /etc/power.conf
sudo chown 1000:share /etc/power.conf

# Restart the power startup script
cd
sudo bash /etc/init.d/S98powerprofile restart


echo ""
echo "Starting the Plex Media Server..."
echo ""

# Start the PMS server
cd
sudo bash /etc/init.d/S92plexmediaserver start


# Remove the RUN installer package
if test -f /DataVolume/PlexMediaServer-1.16.5.1554-WDMPW.run
then

	rm /DataVolume/PlexMediaServer-1.16.5.1554-WDMPW.run

fi


# Display some final text before exiting

echo ""
echo "Installation complete."
echo ""
echo "Please remove the temporary installation directory manually by entering 'sudo rm -R plexmediaserver-installer' in your terminal."
echo ""
echo "You may access and configure your Plex Media Server by entering ‘http://192.168.60.1:32400/web' in any web browser on your local network."
echo ""
echo "I strongly recommend restarting your WD My Passport Wireless to make sure that the Plex Media Server install is working across restarts."
echo ""
echo "ENJOY!"
echo ""


# Exit from the script with success (0)
exit 0
