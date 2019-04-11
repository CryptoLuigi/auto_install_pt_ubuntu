#!/bin/bash
#Script for the automatic installation for Profit Trailer on Ubuntu
#Script By CryptoLuigi (Michael Ruperto)
#Date: 2019-04-01
#Updated: 2019-04-03

version=$(curl -s https://api.github.com/repos/taniman/profit-trailer/releases | grep tag_name | cut -d '"' -f 4 | sed -n '1p')
lastestdownload=$(curl -s https://api.github.com/repos/taniman/profit-trailer/releases | grep browser_download_url | cut -d '"' -f 4 | sed -n '1p')


function botname()
{
	mkdir -p /var/opt/$server
	cd /var/opt/$server
}
function javasetup()
{
	sudo apt-get install openjdk-8-jdk -y
	curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
	sudo apt-get install -y nodejs
	#sudo ln -s /usr/bin/nodejs /usr/bin/node
}

function javaremove()
{
	sudo apt-get remove openjdk* -y
	sudo apt-get remove --auto-remove openjdk* -y
	sudo apt-get purge openjdk* -y
	sudo apt-get purge --auto-remove openjdk* -y
	sudo apt-get purge nodejs -y
}

function npmsetup()
{
	sudo apt-get install npm -y
	sudo npm install pm2@latest -g
}

function ptsetup()
{
	wget $lastestdownload
	sudo apt-get install unzip -y
	unzip /var/opt/$server/ProfitTrailer-$version.zip
	mv /var/opt/$server/ProfitTrailer-$version/* /var/opt/$server/
	rmdir ProfitTrailer-$version
	rm ProfitTrailer-$version.zip
	chmod +x ProfitTrailer.jar
}

function portsetup()
{
	echo "$port" | sed -i -e"s/^server.port =.*/server.port = $port/" /var/opt/$server/application.properties	
}

function ptstart()
{
	pm2 start pm2-ProfitTrailer.json
	pm2 save
	pm2 startup
}

function applyproperties()
{
	sed -i -e"s/^server.sitename =.*/server.sitename = $server/" /var/opt/$server/application.properties
	sed -i -e"s/profit-trailer/profit-trailer-$server/" /var/opt/$server/pm2-ProfitTrailer.json
}

if [[ $# -eq 0 ]]; then
	sudo apt-get update
	read -p "Enter the name of your bot:" server
	botname
	read -p "Do you want install Java 8?(y/n)" -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		echo
		read -p "Do you want to remove any other possible Java versions?(y/n)" -n 1 -r
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			javaremove
		fi
		javasetup
	fi
	
	echo
	read -p "Do you want install npm?(y/n)" -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		npmsetup
	fi

	echo
	read -p "Do you want install Profit Trailer $version?(y/n)" -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		ptsetup
		applyproperties
	fi

	echo
	read -p "Do you want to change the default port?(y/n)" -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		echo
		read -p "What port do you want to assign the bot to?(Default 8081)" port
		portsetup
	fi

	echo
	read -p "Do you want to enter your License now?(y/n)" -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		echo
		read -p "Enter your License key: " license
		echo "$license" | sed -i -e"s/^license =.*/license = $license/" /var/opt/$server/application.properties
	fi

	echo
	read -p "Do you want to enter your API keys now?(y/n)" -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		echo
		#Exchange being used
		PS3='Please enter your choice of exchange: '
		options=("BINANCE" "BITTREX" "POLONIEX" "KUCOIN" "HUOBI" "Quit")
		select opt in "${options[@]}"
		do
	   	case $opt in
			"BINANCE")
	        		sed -i -e"s/^trading.exchange =.*/trading.exchange = BINANCE/" /var/opt/$server/application.properties
				break
	        	;;
			"BITTREX")
				sed -i -e"s/^trading.exchange =.*/trading.exchange = BITTREX/" /var/opt/$server/application.properties
				break
	        	;;
			"POLONIEX")
	            		sed -i -e"s/^trading.exchange =.*/trading.exchange = POLONIEX/" /var/opt/$server/application.properties
				break
        		;;
			"KUCOIN")
				sed -i -e"s/^trading.exchange =.*/trading.exchange = KUCOIN/" /var/opt/$server/application.properties
				break
        		;;
			"HUOBI")
            			sed -i -e"s/^trading.exchange =.*/trading.exchange = HUOBI/" /var/opt/$server/application.properties
				break
        		;;
       			"Quit")
        	    		break
        		;;
        		*) 
				echo "invalid option $REPLY"
			;;
    		esac
		done
		echo
		read -p "Enter your Default API key: " default_api_key
		echo "$default_api_key" | sed -i -e"s/^default_api_key =.*/default_api_key = $default_api_key/" /var/opt/$server/application.properties
		echo
		read -p "Enter your Default API secret key: " default_api_secret
		echo "$default_api_secret" | sed -i -e"s/^default_api_secret =.*/default_api_secret = $default_api_secret/" /var/opt/$server/application.properties
		echo
		read -p "Enter your second API key: " trading_api_key
		echo "$trading_api_key" | sed -i -e"s/^trading_api_key =.*/trading_api_key = $trading_api_key/" /var/opt/$server/application.properties
		echo
		read -p "Enter your second API secret key: " trading_api_secret
		echo "$trading_api_secret" | sed -i -e"s/^trading_api_secret =.*/trading_api_secret = $trading_api_secret/" /var/opt/$server/application.properties
	fi

	echo
	echo "Be sure to register your Default API key with the discord chat bot before starting Profit Trailer"
	echo
	read -p "Do you want start Profit Trailer?(y/n)" -n 1 -r
	echo

	if [[ $REPLY =~ ^[Yy]$ ]]; then
		ptstart
	fi
	exit
fi

#System updates, assigns argument 1 to server, then create directories
sudo apt-get update
server=$1
botname
shift

#For Argument 2: If Y is selected, script will reinstall Java, npm and pt, then apply settings
if [[ $1 =~ ^[Yy]$ ]]; then
	javaremove
	javasetup
	npmsetup
	ptsetup
	applyproperties
	shift
#For Argument 2: If N is selected, script will install pt and apply settings
elif [[ $1 =~ ^[Nn]$ ]]; then
	ptsetup
	applyproperties
	shift
else
	echo "2nd argument must be y or n"
	exit
fi

#For Argument 3: Assigns port number. Arugment must be a number
if [[ $1 =~ ^[0-9]+$ ]]; then
	port=$1
	portsetup
	shift
else
	echo "invalid port number"
	exit
fi

#For Argument 4: Assigns the exchange, must select number between [1-6]
if [[ $1 =~ 1 ]]; then
	sed -i -e"s/^trading.exchange =.*/trading.exchange = BINANCE/" /var/opt/$server/application.properties
	shift
elif [[ $1 =~ 2 ]]; then
	sed -i -e"s/^trading.exchange =.*/trading.exchange = BITTREX/" /var/opt/$server/application.properties
	shift
elif [[ $1 =~ 3 ]]; then
    sed -i -e"s/^trading.exchange =.*/trading.exchange = POLONIEX/" /var/opt/$server/application.properties
    shift
elif [[ $1 =~ 4 ]]; then
	sed -i -e"s/^trading.exchange =.*/trading.exchange = KUCOIN/" /var/opt/$server/application.properties
	shift
elif [[ $1 =~ 5 ]]; then
    sed -i -e"s/^trading.exchange =.*/trading.exchange = HUOBI/" /var/opt/$server/application.properties
    shift
else
	echo "Enter the number corresponding with the correct exchange you want to use [1 - 6]"
	exit
fi

#For Argument 5: Assigns License key to properties. Checks to see if it's over 1 character long	
if [[ ${#1} -gt 1 ]]; then
	license=$1
	echo "$license" | sed -i -e"s/^license =.*/license = $license/" /var/opt/$server/application.properties
	shift
else
	echo "enter valid License"
	exit
fi
	
#For Argument 6: Assigns API key to properties. Checks to see if it's over 1 character long	
if [[ ${#1} -gt 1 ]]; then
	default_api_key=$1
	echo "$default_api_key" | sed -i -e"s/^default_api_key =.*/default_api_key = $default_api_key/" /var/opt/$server/application.properties
	shift
else
	echo "enter valid API key"
	exit
fi
	
#For Argument 7: Assigns Secret API key to properties. Checks to see if it's over 1 character long		
if [[ ${#1} -gt 1 ]]; then
	default_api_secret=$1
	echo "$default_api_secret" | sed -i -e"s/^default_api_secret =.*/default_api_secret = $default_api_secret/" /var/opt/$server/application.properties
	shift
else
	echo "enter valid API Secret key"
	exit
fi

#For Argument 8: Assigns API key to properties. Checks to see if it's over 1 character long		
if [[ ${#1} -eq 1 ]];then
	shift
else
	if [[ ${#1} -gt 1 ]]; then
		trading_api_key=$1
		echo -e "\ntrading_api_key =" >> /var/opt/$server/application.properties
		echo "$trading_api_key" | sed -i -e"s/^trading_api_key =.*/trading_api_key = $trading_api_key/" /var/opt/$server/application.properties
		shift
	else
		echo "enter valid API key"
		exit
	fi
fi

#For Argument 9: Assigns Secret API key to properties. Checks to see if it's over 1 character long
if [[ ${#1} -eq 1 ]];then
	shift
else
	if [[ ${#1} -gt 1 ]]; then
		trading_api_secret=$1
		echo -e "\ntrading_api_secret =" >> /var/opt/$server/application.properties
		echo "$trading_api_secret" | sed -i -e"s/^trading_api_secret =.*/trading_api_secret = $trading_api_secret/" /var/opt/$server/application.properties
		shift
	else
		echo "enter valid API Secret key"
		exit
	fi
fi

#For Argument 10: If y is selected PT will start. If 
if [[ $1 =~ ^[Yy]$ ]]; then
	ptstart
elif [[ $1 =~ ^[Nn]$ ]]; then
	echo "PT not started"
else
	echo "For argument 10 please select y/n"
	exit
fi
