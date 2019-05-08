# Automatic installation of Profit Trailer on Ubuntu
---
## By: CryptoLuigi

### This script is designed to automatically install Profit Trailer crypto trading bot.
#### Click link below to learn more about Profit Trailer

https://profittrailer.com/pt/cryptoluigi/

When running this script, the user will be prompted for the name of the bot.
Then creates a directory using the name of the bot. 
Also bot name is added to the application.properties file.
Script prompts user if they want to install all necessary software to run profit trailer.
Once PT is installed the user will be able to enter all mandatory information.
The script will ask for what exchange and for the API keys.
The data will be entered into application.properties file
Once PT is configured the script will ask the user if they want to start the bot.

```
Please note default API must be registered with the Profit Trailer bot on Discord.
Without registering your default API key with bot will not start.
 ```
 
 
For a guided installation enter the following 3 commands
```
wget https://raw.githubusercontent.com/CryptoLuigi/auto_install_pt_ubuntu/master/auto_install_pt_ubuntu.sh

chmod +x ./auto_install_pt_ubuntu.sh

./auto_install_pt_ubuntu.sh
 ```
 
For automatic installation enter all the required arguments 
```
Example usage

./auto_install_pt_ubuntu.sh botname [y/n] Port [1-5] Licensekey DEFAPI DEFSEC [y-n]

./auto_install_pt_ubuntu.sh MoneyMachine n 8085 1 Scv32d3 d323rd ds3df3 y


4th arugment is the exhange. 1=Binance 2=Bittrex 3=Poloniex 4=Kucoin 5=Huobi
First [y/n] is if this is the first install. If yes will install Java.
Last [y/n] is if you want to start up Profit trailer now
 ```
 
 Here is a video guide: https://www.youtube.com/watch?v=QzW5_4M8nfs
 
 [![Profit Trailer Tutorial: How to do an automatic setup 2019](https://img.youtube.com/vi/QzW5_4M8nfs/0.jpg)](https://www.youtube.com/watch?v=QzW5_4M8nfs "Profit Trailer Tutorial: How to do an automatic setup 2019")
