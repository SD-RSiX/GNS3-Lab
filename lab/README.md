

# Building the Lab

### Requirements

* [GNS3 1.5+](https://www.gns3.com)
* [Docker](https://www.docker.com/)

The Lab is based on GNS3, Docker, [Ryu SDN Controller](https://osrg.github.io/ryu/), [Quagga](http://www.nongnu.org/quagga/), and [Open vSwitch](http://openvswitch.org/). Although, the only two things must be installed are GNS3 and Docker, because Ryu, Quagga, and Open vSwitch run in Docker containers.

### Importing Docker images to GNS3

After installing GNS3 and Docker, open GNS3 and import Open vSwitch and iX Quagga Router images throught __File__ > __Import Appliance__ and select the _.gns3a_ files into the _lab_ directory of this project (the images are imported individually) and install the images in GNS3 according your preferences in the dialog.

### Importing GNS3 project
