#!/bin/bash
#Script for the automatic installation for Profit Trailer on Ubuntu
#Script By CryptoLuigi (Michael Ruperto)
#Date: 2019-04-01

version=$(curl -s https://api.github.com/repos/taniman/profit-trailer/releases | grep tag_name | cut -d '"' -f 4 | sed -n '1p')
lastestdownload=$(curl -s https://api.github.com/repos/taniman/profit-trailer/releases | grep browser_download_url | cut -d '"' -f 4 | sed -n '1p')

read -p "Enter the name of your bot:" server
mkdir -p /var/opt/$server
cd /var/opt/$server
sudo apt-get update

read -p "Do you want install Java 8?(y/n)" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo
	read -p "Do you want to remove any other possible Java versions?(y/n)" -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		sudo apt-get remove openjdk* -y
		sudo apt-get remove --auto-remove openjdk* -y
		sudo apt-get purge openjdk* -y
		sudo apt-get purge --auto-remove openjdk* -y
		sudo apt-get purge nodejs -y
	fi
	sudo apt-get install openjdk-8-jdk -y
	curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
	sudo apt-get install -y nodejs
	#sudo ln -s /usr/bin/nodejs /usr/bin/node
fi

echo
read -p "Do you want install npm?(y/n)" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	sudo apt-get install npm -y
	sudo npm install pm2@latest -g
fi

echo
read -p "Do you want install Profit Trailer $version?(y/n)" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	wget $lastestdownload
	sudo apt-get install unzip
	unzip /var/opt/$server/ProfitTrailer-$version.zip
	mv /var/opt/$server/ProfitTrailer-$version/* /var/opt/$server/
	rmdir ProfitTrailer-$version
	rm ProfitTrailer-$version.zip
	chmod +x ProfitTrailer.jar
fi

sed -ie "s/^server.sitename =.*/server.sitename = $server/" /var/opt/$server/application.properties

sed -ie "s/profit-trailer/profit-trailer-$server/" /var/opt/$server/pm2-ProfitTrailer.json

echo
read -p "Do you want to change the default port?(8081)" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	read -p "What port do you want to assign the bot to?(Default 8081)" port
	echo "$port" | sed -i -e"s/^server.port =.*/server.port = $port/" /var/opt/$server/application.properties
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
	#Default API
	echo
	read -p "Enter your Default API key: " default_api_key
	echo "$default_api_key" | sed -ie "s/^default_api_key =.*/default_api_key = $default_api_key/" /var/opt/$server/application.properties
	#Default API Secret
	echo
	read -p "Enter your Default API secret key: " default_api_secret
	echo "$default_api_secret" | sed -ie "s/^default_api_secret =.*/default_api_secret = $default_api_secret/" /var/opt/$server/application.properties
	#Second API Key
	echo
	read -p "Enter your second API key: " trading_api_key
	echo "$trading_api_key" | sed -ie "s/^trading_api_key =.*/trading_api_key = $trading_api_key/" /var/opt/$server/application.properties
	#Second API Secret
	echo
	read -p "Enter your second API secret key: " trading_api_secret
	echo "$trading_api_secret" | sed -ie "s/^trading_api_secret =.*/trading_api_secret = $trading_api_secret/" /var/opt/$server/application.properties
fi

echo
echo "Be sure to register your Default API key with the discord chat bot before starting Profit Trailer"
echo
read -p "Do you want start Profit Trailer?(y/n)" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	pm2 start pm2-ProfitTrailer.json
fi
pm2 save
pm2 startup
