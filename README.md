# Chef-Homeserver
Homeserver-Installation with Chef

## Description
This should provide a useful homeserver installation with nice 
cloud and home network support. Planned features:

- Network Time Server (ntpd)
- DNS / DHCP with central adblocking feature
- LDAP-Server as central user source
- ZFS filesystem for data storage, snapshots and easy backup
- MariaDB database
- Kerberos integration for clients
- Fileserver (samba and possibly nfs)
- CalDav and CardDav with NextCloud
- File sync mechanism for mobile devices (SyncThing?)
- ... more! 

This is currently a work in progress and should be used in test environments only!

Requirements to use the recipe in a test environment:

- A Chef Server (a virtual machine is preferred)
- separated test network segment (homeserver starts a dhcp server!)
- virtual server for tests with chef client installed (recipes are for Debian 9)
- a dedicated virtual client in the test network segment for tests
