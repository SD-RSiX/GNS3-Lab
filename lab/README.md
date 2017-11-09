# Building the Lab

## Requirements

* [GNS3 1.5+](https://www.gns3.com)
* [Docker](https://www.docker.com/)
* Cisco IOS 3725 - Version 12.4(15)T14 image

The Lab is based on GNS3, Docker, [Ryu SDN Controller](https://osrg.github.io/ryu/), [Quagga](http://www.nongnu.org/quagga/), and [Open vSwitch](http://openvswitch.org/). Although, the only two things must be installed are GNS3 and Docker, because Ryu, Quagga, and Open vSwitch run in Docker containers. You also need a Cisco IOS 3725 version 12.4(15)T14 - it requires a license and we can not provide it, so you need to get it by your own.

## Building Docker images

```
## Run the following commands in the same directory where this file is.

## Route Server
docker build -t sd-rsix/route-server:latest containers-src/route-server

## Quarentine Route Server
docker build -t sd-rsix/quarentine:latest containers/quarentine
```


## Importing to GNS3

### Importing Docker images to GNS3

After installing GNS3 and Docker, open GNS3 and import all the _.gns3a_ files in the _GNS3-import_ folder (one by one). You may change some options in the importing dialog according to your preferences.


### Importing Cisco IOS image

### Importing GNS3 project


After importing, click in any of the Cisco IOS Routers (e.g. Router Server) and select _Auto Idle-PC_ in order to reduce the burden of the Lab in your computer.


## Ryu controller

[Ryu Docker container](https://store.docker.com/community/images/osrg/ryu)
