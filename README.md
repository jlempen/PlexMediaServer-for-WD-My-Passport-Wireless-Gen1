# Unofficial Plex Media Server for the WD My Passport Wireless Gen1
 Run Plex Media Server on the first generation WD My Passport Wireless hard drive

Based on my now obsolete [HOWTO](http://forums.plex.tv/discussion/200687/obsolete-howto-plex-media-server-v1-0-on-the-wd-my-passport-wireless/p1 "HOWTO") thread for installing Plex Media Server on the WD My Passport Wireless (non-Pro model), I built an **unofficial installer package** which makes the installation of Plex Media Server a breeze on the "old" WD My Passport Wireless portable hard drive.

This self-extracting installer package will automate all steps of my now obsolete [HOWTO](http://forums.plex.tv/discussion/200687/obsolete-howto-plex-media-server-v1-0-on-the-wd-my-passport-wireless/p1 "HOWTO") to install Plex Media Server on the WD My Passport Wireless. The package does all kinds of error checking and will perform a new PMS install or upgrade an existing PMS install to the latest version and detect broken installs and fix them. I've also thrown in an uninstaller script to completely remove PMS from the WD MPW and restore the device to its factory settings without deleting your media files and Plex Media Server database.

This package contains a public release of the Plex Media Server. I will not publish installers based on Plex Pass / Beta releases.

# Installation guidelines

1. Download my unofficial installer package from the releases
2. Connect to your WD My Passport Wireless WiFi network
3. Open the WD My Passport Wireless web interface in a web browser at http://192.168.60.1
4. Navigate to the **Admin** tab and enable the **SSH** and **FTP** access options. You may also switch the Battery Optimization scheme to **Performance** in the **Hardware** tab and turn off the Twonky Media Server by disabling the **DLNA Streaming** option on the **Media** tab of the web interface. If you don't, my installer package will take care of all that anyway.
5. Copy the installer package to your WD My Passport Wireless public folder either by opening a network connection to your device or by connecting the device to your computer via USB. **Leave the installer package in the root directory of your drive, do not copy it into a subfolder!**
6. SSH into your WD My Passport Wireless with a SSH client, for instance "Terminal" on OSX or "PuTTY" on Windows. Enter `ssh root@192.168.60.1` in the SSH client, then enter the password: `welc0me` (yes, that's a zero, not an capital "O").
7. Navigate to the root directory of the hard drive by entering`cd /DataVolume` in the SSH client.
8. Make sure that the installer package is located in the root directory by entering `ls` in the SSH client. The package should be listed under the name `PlexMediaServer-1.16.5.1554-WDMPW.run`.
9. Run the installer package by entering `./PlexMediaServer-1.16.5.1554-WDMPW.run` in the SSH client and let it perform its magic. This will take a few minutes.
10. Done! I highly recommend restarting the My Passport Wireless now.

You may now reach and configure your shiny new Plex Media Server by entering http://192.168.60.1:32400/web in any web browser on your local network.


# Upgrading an existing Plex Media Server installation

If you have already installed Plex Media Server with an older version of my installer package or if you're one of the few brave who installed PMS by following my now obsolete [HOWTO](http://forums.plex.tv/discussion/200687/obsolete-howto-plex-media-server-v1-0-on-the-wd-my-passport-wireless/p1 "HOWTO"), you may also use my unofficial installer package to upgrade your Plex Media Server installation to the latest version. The installer script will detect that PMS is already installed and perform a safe and clean upgrade.


# Uninstalling Plex Media Server

I have included an uninstaller script in the package. This script will perform a clean uninstall and restore your WD My Passport Wireless to its factory settings without deleting your media files and Plex Media Server database. It provides an option to remove the Plex Media Server database as well. Your media files will remain untouched on your hard disk.

To uninstall Plex Media Server:

1. Copy the uninstaller script to the root folder of your hard disk: 
    `cp -f /DataVolume/Plex\ Media\ Server/Application/WDMPW_SCRIPTS/uninstall.sh /DataVolume/`
2. Run the uninstaller: `./uninstall.sh`
3. Remove the uninstaller script: `sudo rm uninstall.sh`
4. Eventually remove the remaining installer directory: `sudo rm -R plexmediaserver-installer`
3. Done!


# So what does the installer script exactly do?

- Self-extract to `/DataVolume/plexmediaserver-installer`
- Detect an existing `/Plex Media Server` directory in `/DataVolume`
- Detect an existing PMS application located in `DataVolume/Plex Media Server/Application` and stop the server
- If it exists, remove the old PMS application folder from `DataVolume/Plex Media Server`
- Copy the updated PMS application to `DataVolume/Plex Media Server/Application`
- Copy the `S92plexmediaserver` startup script to `/etc/init.d`
- Copy the `plexmediaserver` startup script to `/etc/default`
- Copy the `start.sh` startup script to`/usr/local/bin` and rename it to `plexmediaserver`
- Create a `DISABLED` directory in `/etc/init.d` to backup some WD media indexing services startup scripts
- Stop the `S85wdmcserverd` and `S92wdnotifierd` WD media indexing services
- Move the `S85wdmcserverd` and `S92wdnotifierd` startup scripts to `/etc/init.d/DISABLED`
- Stop the Twonky Media Server
- Disable the Twonky Media Server by writing `"disabled"` into the `/etc/nas/service_startup/twonky` configuration file
- Set the power profile to `Performance` by writing `"powerprofile=max_system_performance"` into the `/etc/power.config` configuration file
- Restart the power profile service
- Set the permissions and ownership of the PMS application directory and startup scripts to `"777"` and `"root:root"`
- Start the Plex Media Server
- Remove the installer package
- Leave the `/DataVolume/plexmediaserver-installer` directory in the root folder of the hard disk


# A few considerations

As you add content to your portable Plex Media Server and start scraping Metadata for your content, you will notice that the WD MPW is not the fastest kid in town. Scraping Metadata for a movie may take up to a minute until the posters, fan art and movie info is displayed in the PMS Web interface. Browsing through the Web interface isn't the fastest experience neither, nevertheless, the WD MPW serves content quickly and flawlessly to Plex clients on its network.

Sometimes the PMS web interface will throw an error while loading the Dashboard or the Server Settings pages. This seems to happen mainly when PMS is very busy scanning your media files and fetching data from the Internet. Clicking on the Home or Settings button again usually fixes the issue.

**Please be patient with your WD My Passport Wireless Plex Media Server!**
**Give it some time to scan your media files and fetch data from the internet.**

According to [this WD support thread,](http://support.wdc.com/KnowledgeBase/answer.aspx?ID=13963 "this WD support thread,"), this seems to happen on the new WD My Passport Wireless Pro as well...

I noticed that the Plex team has added a bunch of new content auto-updating options in PMS since v1.0. This means that PMS will scan your media files and/or its own database quite often to perform maintenance tasks even if you haven't added any new content recently. This is great when you run PMS on a powerful computer or NAS and have a good internet connection, however, on the MPW, this may lead to slowdowns which are not necessary.

I recommend that you turn off as much content auto-updating features as possible once your PMS is up and running and update manually only when you add new content.

Specifically, in the PMS web interface, go to `Settings`, `Server`, `Library`, turn on `Show Advanced` and untick the following options:

    "Update my library automatically"
    "Run a partial scan when changes are detected"
    "Include music libraries in automatic updates"
    "Update my library periodically"

Moreover, set `Generate video thumbnails` and `Generate chapter thumbnails` to never.

Also, tick the `Run scanner tasks at a lower priority` option.

Then, go to `Settings`, `Server`, `Scheduled Tasks` and untick the following options:

    "Refresh local metadata every three days"
    "Update all libraries during maintenance"
    "Upgrade media analysis during maintenance"
    "Refresh metadata periodically"
    "Perform extended media analysis during maintenance"

You may keep the following options ticked, as they won't put too much strain on the device:

    "Backup database every three days"
    "Optimize database every week"
    "Remove old bundles every week"
    "Remove old cache files every week"

Once we connect to the WD MPW Plex Media Server from a client device, we need to force the client to precache the Metadata from the server. Do do this, simply browse for instance to the Movie library and show all movies. Then, slowly move down the movie list while the list gets populated with Metadata (posters) until you get to the bottom of the list. This takes about one to two seconds per movie. Once you've done that, browsing your movie library will be snappy. Repeat this for your TV shows, making sure that you display all episodes of all seasons for every TV show. The same applies for your Music library, repeat the above steps for the Artist list and for the Albums list. You'll need to do this precaching on every Plex client you plan on using with the server. 

Don't expect your portable PMS to be able to transcode any media, its tiny single-core ARM processor is just not made for such heavy processing. It'll happily stream any kind of content to your devices by DirectPlay though.

To copy content to the device, connect the drive by USB 3.0 instead of WiFi, this will be at least 20 times faster.

If you have a large media library with several hundreds or even thousands of movies and albums, the best way to set up your portable PMS is to replicate the library from your main Plex Media Server hosted on your NAS device or computer. To do so, follow the official instructions here: 
[support.plex.tv/hc/en-us/articles/201370363-Move-an-Install-to-Another-System](https://support.plex.tv/hc/en-us/articles/201370363-Move-an-Install-to-Another-System "https://support.plex.tv/hc/en-us/articles/201370363-Move-an-Install-to-Another-System")

On our WD MPW Plex Media Server install, you'll find the Plex Library in the following location:

`/DataVolume/Plex\ Media\ Server/Library/Application\ Support/Plex\ Media\ Server/`

The official HOWTO to move an install to another system works perfectly, but there's a catch. As soon as you have pointed your libraries to the new media directories on your WD MPW, PMS starts to re-download all Metadata from the Internet again, and that's obviously not what we want!

The trick is to create a symbolic link on our WD My Passport Wireless that replicates the directory path of the PMS we replicated the library from. This will work without a hitch if your main Plex Media Server is on a Linux or Mac OSX box. If your main PMS is on a Windows machine, you're probably screwed...

You may think of this symbolic link as an "alternative path" to your media folders.

As an example, here is what I did. My main PMS is on a QNAP NAS. On this device, my media folders are all located under `/share/CACHEDEV1_DATA/Plex\ Media`.

I simply replicated the original file path of my QNAP NAS on the WD MPW and created a symlink pointing to my actual media folders, which is under `/DataVolume/Plex\ Media/`.

    mkdir share
    cd share
    mkdir CACHEDEV1_DATA
    ln -s /DataVolume/Plex\ Media/ /share/CACHEDEV1_DATA/Plex\ Media

I can now reach my media folder in two ways:

`/DataVolume/Plex\ Media/`

and

`/share/CACHEDEV1_DATA/Plex\ Media/`

Both paths point to my media folder.

Now, the Plex Media Server on the WD MPW sees the media files in the exact same directory as on the original Plex Media Server on the QNAP NAS I replicated the library from, and thus doesn't do any cumbersome Metadata scraping.
