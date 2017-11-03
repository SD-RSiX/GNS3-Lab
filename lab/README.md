# Building the Lab

### Requirements

* [GNS3 1.5+](https://www.gns3.com)
* [Docker](https://www.docker.com/)
* Cisco IOS 3725 - Version 12.4(15)T14 image

The Lab is based on GNS3, Docker, [Ryu SDN Controller](https://osrg.github.io/ryu/), [Quagga](http://www.nongnu.org/quagga/), and [Open vSwitch](http://openvswitch.org/). Although, the only two things must be installed are GNS3 and Docker, because Ryu, Quagga, and Open vSwitch run in Docker containers. You also need a Cisco IOS 3725 version 12.4(15)T14 - it requires a license and we can not provide it, so you need to get it by your own.

### Importing Docker images to GNS3

After installing GNS3 and Docker, open GNS3 and import Open vSwitch and iX Quagga Router images throught __File__ > __Import Appliance__ and select the _.gns3a_ files into the _lab_ directory of this project (the images are imported individually) and install the images in GNS3 according your preferences.


### Importing Cisco IOS image

### Importing GNS3 project


After importing, click in any of the Cisco IOS Routers (e.g. Router Server) and select _Auto Idle-PC_ in order to reduce the burden of the Lab in your computer. 
