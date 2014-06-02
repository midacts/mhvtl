#!/bin/bash
# MHVTL Installation Script
# Date: 1st of June, 2014
# Version 1.0
#
# Author: John McCarthy
# Email: midactsmystery@gmail.com
# <http://www.midactstech.blogspot.com> <https://www.github.com/Midacts>
#
# To God only wise, be glory through Jesus Christ forever. Amen.
# Romans 16:27, I Corinthians 15:1-4
#---------------------------------------------------------------
######## RESOURCES ########
# Shout out to james2k2 for his Easy Install for Debian/Ubuntu (04/04/2013)
# http://mhvtl-a-linux-virtual-tape-library.966029.n3.nabble.com/Easy-Install-for-Debian-Ubuntu-td4025413.html
######## VARIABLES ########
compdate=2014-04-13
version=1.5

function install-mhvtl(){
	# Install prerequisite
		echo
		echo -e '\e[01;34m+++ Installing Prerequisite Packages...\e[0m'
		apt-get update
		apt-get install -y apache2 build-essential git libconfig-general-perl liblzo2-dev liblzo2-2 linux-headers-$(uname -r) lsscsi lzop mtx mt-st php5 sg3-utils sudo sysstat zlib1g-dev
		echo -e '\e[01;37;42mThe Prerequisite Packages were successfully installed!\e[0m'

	# Create users and groups
		echo
		echo -e '\e[01;34m+++ Adding MHVTL Users and Groups...\e[0m'
		groupadd -r vtl
		useradd -r -c "Virtual Tape Library" -d /opt/mhvtl -g vtl vtl -s /bin/bash
		echo
		echo -e '\e[01;37;42mThe MHVTL users and groups have been successfully added!\e[0m'

		echo
		echo -e '\e[01;34m+++ Creating the required directories...\e[0m'
		echo
		mkdir -p /opt/mhvtl
		mkdir -p /etc/mhvtl
		chown -R vtl:vtl /opt/mhvtl
		chown -R vtl:vtl /etc/mhvtl
		echo -e '\e[01;37;42mThe required directories have been successfully added!\e[0m'

	# Download the latest mhvtl files
		echo
		echo -e '\e[01;34m+++ Downloading the Latest MHVTL files...\e[0m'
		wget https://sites.google.com/site/linuxvtl2/mhvtl-$compdate.tgz
		echo -e '\e[01;37;42mThe MHVTL installation files were successfully downloaded!\e[0m'

	# Untar the installation files
		echo
		echo -e '\e[01;34m+++ Untarrring the MHVTL files...\e[0m'
		tar xzf mhvtl-$compdate.tgz
		cd mhvtl-$version
		echo
		echo -e '\e[01;37;42mThe MHVTL installation files were successfully untarred!\e[0m'

	# Install mhvtl
		echo
		echo -e '\e[01;34m+++ Installing MHVTL...\e[0m'
		make
		cd kernel
		make
		make install
		cd ..
		make
		make install
		echo -e '\e[01;37;42mMHVTL has been successfully installed!\e[0m'

	# Start MHVTL
		echo
		echo -e '\e[01;34m+++ Starting MHVTL...\e[0m'
		ln -s /usr/lib64/libvtlscsi.so /usr/lib/
		ln -s /usr/lib64/libvtlcart.so /usr/lib/
		service mhvtl start
		echo -e '\e[01;37;42mMHVTL has been successfully started!\e[0m'
}
function install-web-gui(){
	# Installing the mhvtl web gui
		echo
		echo -e '\e[01;34m+++ Installing MHVTL Web GUI...\e[0m'
		cd /var/www
		mkdir mhvtl
		git clone http://github.com/niadev67/mhvtl-gui.git mhvtl
		chown -R www-data:www-data mhvtl
		echo -e '\e[01;37;42mThe MHVTL Web GUI has been successfully installed!\e[0m'

	# Editing the /etc/sudoers file
		echo
		echo -e '\e[01;34m+++ Editing the sudoers and default apache2 site...\e[0m'
		echo
		echo >> /etc/sudoers
		echo "www-data ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

	# Editing the /etc/apache2/sites-available/default file
		sed -i 's@DocumentRoot /var/www@DocumentRoot /var/www/mhvtl/@g' /etc/apache2/sites-available/default
		sed -i 's@Directory /var/www/@Directory /var/www/mhvtl/@g' /etc/apache2/sites-available/default
		echo -e '\e[01;37;42mThe sudoers and default apache2 site have been successfully installed!\e[0m'

	# Restarting the Apache2 service
		echo
		echo -e '\e[01;34m+++ Editing the sudoers and default apache2 site...\e[0m'
		echo
		service apache2 restart
		echo
		echo -e '\e[01;37;42mThe apache2 service has been successfully installed!\e[0m'
}
function doAll(){
	# Calls Function 'install-mhvtl'
		echo
		echo
		echo -e "\e[33m=== Install MHVTL ? (y/n)\e[0m"
		read yesno
		if [ "$yesno" = "y" ]; then
			install-mhvtl
		fi

	# Calls Function 'install-web-gui'
		echo
		echo -e "\e[33m=== Install the MHVTL Web GUI ? (y/n)\e[0m"
		read yesno
		if [ "$yesno" = "y" ]; then
			install-web-gui
		fi

	# Gets the IP of the Ubiquiti unifi controller
		ipaddr=`hostname -I`
		ipaddr=$(echo "$ipaddr" | tr -d ' ')

	# End of Script Congratulations, Farewell and Additional Information
		clear
		farewell=$(cat << EOZ


           \e[01;37;42mWell done! You have successfully setup your MHVTL server! \e[0m

                                \e[01;37mhttp://$ipaddr\e[0m
                                  \e[01;37mPassword: mhvtl\e[0m

                         \e[01;37miSCSI (tgt): Enable and install\e[0m
                    \e[01;37mUtility: Live Update -> Check -> Update\e[0m
                            \e[01;37mConsole: Start daemons\e[0m
                       \e[01;37miSCSI (tgt): Quick Start -> Start\e[0m
           \e[01;37mOperator: Mount -> Select Robot -> Select slot and drive\e[0m

  \e[30;01mCheckout similar material at midactstech.blogspot.com and github.com/Midacts\e[0m

                            \e[01;37m########################\e[0m
                            \e[01;37m#\e[0m \e[31mI Corinthians 15:1-4\e[0m \e[01;37m#\e[0m
                            \e[01;37m########################\e[0m
EOZ
)

		#Calls the End of Script variable
		echo -e "$farewell"
		echo
		echo
		exit 0
}

# Check privileges
	[ $(whoami) == "root" ] || die "You need to run this script as root."

# Welcome to the script
	clear
	welcome=$(cat << EOA


             \e[01;37;42mWelcome to Midacts Mystery's MHVTL Installation Script!\e[0m


EOA
)

# Calls the welcome variable
	echo -e "$welcome"

# Calls the doAll function
	case "$go" in
		* )
			doAll ;;
	esac

# Exits the script
	exit 0
