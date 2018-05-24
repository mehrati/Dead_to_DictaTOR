
```
______           _   _       _         ______ _      _      _____ ___________ 
|  _  \         | | | |     | |        |  _  (_)    | |    |_   _|  _  | ___ \
| | | |___  __ _| |_| |__   | |_ ___   | | | |_  ___| |_ __ _| | | | | | |_/ /
| | | / _ \/ _` | __| '_ \  | __/ _ \  | | | | |/ __| __/ _` | | | | | |    / 
| |/ |  __| (_| | |_| | | | | || (_) | | |/ /| | (__| || (_| | | \ \_/ | |\ \ 
|___/ \___|\__,_|\__|_| |_|  \__\___/  |___/ |_|\___|\__\__,_\_/  \___/\_| \_|
```

***Death to DictaTOR*** <br>
    ddtor install and manage and config tor privoxy dnscrypt-proxy2 services for arch linux distribution
<br>**Demo**<br>
[![asciicast](https://asciinema.org/a/171213.png)](https://asciinema.org/a/171213)
<br>**Note** <br>
    If you need anonymity or strong privacy, manually run torbrowser
<br>**Dependency** <br>
    you must install [Tor](https://github.com/torproject/tor) ,[obfs4](https://github.com/Yawning/obfs4) ,[Dnscrypt-proxy2](https://github.com/jedisct1/dnscrypt-proxy)  , [Privoxy](https://www.privoxy.org) , [Torsocks](https://github.com/dgoulet/torsocks)
<br>**Install**<br>
    get bridges by sending mail to bridges@bridges.torproject.org with the line "get transport obfs4" by itself in the body of the mail no need subject.
    go to project and copy bridges text to ddtorrc file and 
```sh
    $ chmod 755 ./install
    $ sudo ./install
```
<br>**Run**<br>
```sh
    # open terminal and run command
    # start services
    $ sudo ddtor --start
    # status services
    $ sudo ddtor --status
    # stop services
    $ sudo ddtor --stop
```
<br>**Google Chrome**<br>
use [SwitchyOmega](https://github.com/FelisCatus/SwitchyOmega)
<br>**Firefox**<br>
use [Foxyproxy](https://addons.mozilla.org/en-US/firefox/addon/foxyproxy-standard/)
<br>**Telegram Massanger**<br>
    setting -> connecting through proxy -> HTTP with custom http-proxy 
    set proxy Hostname = 127.0.0.1 , Port = 8118 
<br>**CMD**<br>
```sh
    torify commands...
```
<br>**uninstall**<br>
```sh
    $ sudo ./uninstall
```
<br>**Contributing**<br>
    Contributions are welcome! Please feel free to submit a Pull Request.

<br>**Version v0.4**

