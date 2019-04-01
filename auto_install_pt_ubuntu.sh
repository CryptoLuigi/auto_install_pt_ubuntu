#!/bin/bash
#Script for the automatic installation for Profit Trailer on Ubuntu
#Script By CryptoLuigi (Michael Ruperto)
#Date: 2019-04-01

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
read -p "Do you want install Profit Trailer 2.2.12?(y/n)" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	wget https://github.com/taniman/profit-trailer/releases/download/2.2.12/ProfitTrailer-2.2.12.zip
	sudo apt-get install unzip
	unzip /var/opt/$server/ProfitTrailer-2.2.12.zip
	mv /var/opt/$server/ProfitTrailer-2.2.12/* /var/opt/$server/
	rmdir ProfitTrailer-2.2.12
	rm ProfitTrailer-2.2.12.zip
	chmod +x ProfitTrailer.jar
fi
sed -i -e"s/^server.sitename =.*/server.sitename = $server/" /var/opt/$server/application.properties
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
        *) echo "invalid option $REPLY";;
    esac
	done
	#Default API
	echo
	read -p "Enter your Default API key: " default_api_key
	echo "$default_api_key" | sed -i -e"s/^default_api_key =.*/default_api_key = $default_api_key/" /var/opt/$server/application.properties
	#Default API Secret
	echo
	read -p "Enter your Default API secret key: " default_api_secret
	echo "$default_api_secret" | sed -i -e"s/^default_api_secret =.*/default_api_secret = $default_api_secret/" /var/opt/$server/application.properties
	#Second API Key
	echo
	read -p "Enter your second API key: " trading_api_key
	echo "$trading_api_key" | sed -i -e"s/^trading_api_key =.*/trading_api_key = $trading_api_key/" /var/opt/$server/application.properties
	#Second API Secret
	echo
	read -p "Enter your second API secret key: " trading_api_secret
	echo "$trading_api_secret" | sed -i -e"s/^trading_api_secret =.*/trading_api_secret = $trading_api_secret/" /var/opt/$server/application.properties
fi

echo
echo "Be sure to register your Default API key with the discord chat bot before starting Profit Trailer"
echo
read -p "Do you want start Profit Trailer?(y/n)" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	pm2 start pm2-ProfitTrailer.json
fi
