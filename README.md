# ddtor
Dead to DictaTOR will autamically install Tor in either a Arch based distro like Antergos or an manjaro based distro
## Note
    Do NOT expect anonymity using this method. If you need anonymity or strong privacy, manually run torbrowser
## Install
    "get bridge by send mail to bellow address"
    "TO : bridges@torproject.org"
    "Subject : no need subject"
    "Body : get transport obfs4"
    "go to project and save bridges to ddtorrc file"
    "$ chmod 755 ./install "
## run
    "open terminal and run command"
    "start tor service"
    "$ sudo ddtor --start"
    "for status tor service"
    "$ sudo ddtor --status"
    "open firefox browser"
    "$ sudo ddtor --open"
    "for stop tor service"
    "$ sudo ddtor --stop"
## Note firefox
    better for you use FoxyProxy plugin firefox
    open firefox go to add-ons search  and install foxyproxy 
    set type proxy= SOCKS 5 IP address = 127.0.0.1 PORT = 9050
## Note Telegram Massanger
    open telegram go to setting and connecting through proxy and TCP with custom socks5 Hostname=127.0.0.1 Port=9050 
## uninstall
    "sudo ./uninstall"
## Changes
    Version 0.1:

