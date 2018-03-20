
```
______           _   _       _         ______ _      _      _____ ___________ 
|  _  \         | | | |     | |        |  _  (_)    | |    |_   _|  _  | ___ \
| | | |___  __ _| |_| |__   | |_ ___   | | | |_  ___| |_ __ _| | | | | | |_/ /
| | | / _ \/ _` | __| '_ \  | __/ _ \  | | | | |/ __| __/ _` | | | | | |    / 
| |/ |  __| (_| | |_| | | | | || (_) | | |/ /| | (__| || (_| | | \ \_/ | |\ \ 
|___/ \___|\__,_|\__|_| |_|  \__\___/  |___/ |_|\___|\__\__,_\_/  \___/\_| \_|
```

# Death to DictaTOR
    ddtor manage and config services tor privoxy dnscrypt-proxy2 for passing the boycott 
# Note
    If you need anonymity or strong privacy, manually run torbrowser
## Dependency
    you must install [Tor](https://github.com/torproject/tor) ,[Dnscrypt-proxy2](https://github.com/)  , [Privoxy](https://www.privoxy.org/)  , [Proxychain-ng](https://github.com/rofl0r/proxychains-ng)  , [obfs4](https://github.com/Yawning/obfs4)  
## Install
    get bridges by sending mail to bridges@bridges.torproject.org with the line "get transport obfs4" by itself in the body of the mail.
    go to project and copy bridges text to ddtorrc file
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
    $ sudo ddtor --open firefox
    # stop tor service
    $ sudo ddtor --stop
```
## Firefox
    better for you use FoxyProxy plugin firefox
    open firefox go to add-ons search  and install foxyproxy 
    set type proxy = HTTP , IP address = 127.0.0.1 , PORT = 8118
## Telegram Massanger
    open telegram go to setting -> connecting through proxy -> HTTP with custom http-proxy 
    set proxy Hostname = 127.0.0.1 , Port = 8118 
## uninstall
```sh
    $ sudo ./uninstall
```
## Contributing
    Contributions are welcome! Please feel free to submit a Pull Request.
## Version
    v 0.3 

