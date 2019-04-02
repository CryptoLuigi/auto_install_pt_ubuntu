# Automatic installation of Profit Trailer on Ubuntu
# By: CryptoLuigi

This script is designed to automatically install Profit Trailer crypto trading bot.
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

```
wget https://raw.githubusercontent.com/CryptoLuigi/auto_install_pt_ubuntu/master/auto_install_pt_ubuntu.sh

chmod +x auto_install_pt_ubuntu.sh

./auto_install_pt_ubuntu.sh
 ```
