
```
______           _   _       _         ______ _      _      _____ ___________ 
|  _  \         | | | |     | |        |  _  (_)    | |    |_   _|  _  | ___ \
| | | |___  __ _| |_| |__   | |_ ___   | | | |_  ___| |_ __ _| | | | | | |_/ /
| | | / _ \/ _` | __| '_ \  | __/ _ \  | | | | |/ __| __/ _` | | | | | |    / 
| |/ |  __| (_| | |_| | | | | || (_) | | |/ /| | (__| || (_| | | \ \_/ | |\ \ 
|___/ \___|\__,_|\__|_| |_|  \__\___/  |___/ |_|\___|\__\__,_\_/  \___/\_| \_|
```

# Dead to DictaTOR
    autamically installand and manage Tor in either a Arch based distro and ubuntu
# Note
    If you need anonymity or strong privacy, manually run torbrowser
## Install
    get bridge by send mail to bellow address
    TO : bridges@torproject.org
    Subject : no need subject
    Body : get transport obfs4
    go to project and save bridges to ddtorrc file
```sh
    $ chmod 755 ./install
    $ sudo ./install
```
## Run

```sh
    # open terminal and run command
    # start tor service
    $ sudo ddtor --start
    # status tor service
    $ sudo ddtor --status
    # open firefox browser
    $ sudo ddtor --open
    # stop tor service
    $ sudo ddtor --stop
```
## Firefox
    better for you use FoxyProxy plugin firefox
    open firefox go to add-ons search  and install foxyproxy 
    set type proxy = SOCKS 5 , IP address = 127.0.0.1 , PORT = 9050
## Telegram Massanger
    open telegram go to setting -> connecting through proxy -> TCP with custom socks5 
    set proxy Hostname = 127.0.0.1 , Port = 9050 
## uninstall
```sh
    $ sudo ./uninstall
```
## Version
    V 0.1
    please help me to improve Dead to DictaTOR project

