# ddtor
ddtor will autamically install Tor in either a Debian based distro like Ubuntu or an Arch based distro and configures them as well.

To do this, just run 'traktor.sh' file in a supported shell like bash and watch for prompts it asks you.

## Note
Do NOT expect anonymity using this method. If you need anonymity or strong privacy, manually run torbrowser

## Install

### Ubuntu
    sudo add-apt-repository ppa:dani.behzi/traktor
    sudo apt update
    sudo apt install traktor
### ArchLinux
    yaourt -S traktor
### Other (May not be able to install yet)
    wget https://github.com/ubuntu-ir/traktor/archive/master.zip -O traktor.zip
    unzip traktor.zip && cd traktor-master
    ./traktor.sh

## Remote update
    curl -s https://raw.githubusercontent.com/ubuntu-ir/traktor/master/traktor.sh | sh
    
## Changes
    Version 0.1:

