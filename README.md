# Automatic installation of Profit Trailer on Ubuntu
---
# By: CryptoLuigi

## This script is designed to automatically install Profit Trailer crypto trading bot.
https://profittrailer.com/pt/ovlx/

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

./auto_install_pt_ubuntu.sh botname [y/n] Port [1-6] Licensekey DEFAPI DEFSEC TRADAPI TRADSEC [y-n]

./auto_install_pt_ubuntu.sh MoneyMachine n 8085 1 Scv32d3 d323rd ds3df3 s3refs3 sdf3sdf3 y

First [y/n] is if this is the first install. If yes will install Java.
Last [y/n] is if you want to start up Profit trailer now
 ```
 
