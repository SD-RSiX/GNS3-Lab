# Building the Lab

## Requirements

* [GNS3 1.5+](https://www.gns3.com)
* [Docker](https://www.docker.com/)
* [Docker Compose](https://docs.docker.com/compose/)
* Cisco IOS 3725 version 12.4(15)T7 image

The Lab is based on GNS3, Docker, [Ryu SDN Controller](https://osrg.github.io/ryu/), [Quagga](http://www.nongnu.org/quagga/), and [Open vSwitch](http://openvswitch.org/). Although you only need to install GNS3, Docker and Docker Compose, because of Ryu, Quagga, and Open vSwitch run in Docker containers. You also need a Cisco IOS 3725 version 12.4(15)T7 (c3725-adventerprisek9-mz124-15) - it requires a license, and we can not provide it, so you need to get it on your own.

## Building Docker images

### Open vSwitch

We changed the GNS3 Open vSwitch Docker image in order to set the controller to 10.10.10.254:6633 and the fail mode to secure. With this changes, the switches will not forward packets unless they connect to a controller.

Run the following command to build Open vSwitch Docker image:

```
docker build -t sd-rsix/ovs:latest containers-src/open-vswitch
```

### Routers

Containers are not supposed to change: they are supposed to be replaced, so the changes you do in a container will be lost when it is destroyed. We could have used volumes to persist configuration changes, but to make them simpler and portable, they do not store anything but the configuration they were built with.

The commands below build all the router containers with the appropriate configuration. You will build them only once unless you want to change some configuration and make it persistent.

Buiding the first container takes a little longer because it downloads the base image, the others build faster.

Build one by one running the following commands:

```
## Run the following commands in the same directory where this file is.

## Route Server
docker build -t sd-rsix/route-server:latest containers-src/route-server


```


## Importing to GNS3

### Importing Docker images to GNS3

After building the Docker images, open GNS3 and import all the _.gns3a_ files in the _GNS3-import_ folder (one by one). You may change some options in the importing dialog according to your preferences.


### Importing Cisco IOS image

Open _Preferences_ window by going to _Edit_ > _Preferences_. Select _IOS Routers_ on the left and click _New_ on the right. Follow the dialog, but in the second window check _This is an EthernetSwitch router_, so GNS3 will attach a 16 ports switch module.

### Importing GNS3 project

Download the latest version of the project from [here](https://www.dropbox.com/sh/znb6ckb9d7ymiar/AABazkB_lGZ6T7IR4TXXEcyMa?dl=0) and import to GNS3 through _File_ > _Import portable project_.


## Connecting Open vSwitches to the Docker network

At this point, you hare a GNS3 project ready to run. Although, the Open vSwitches need a connection with a Docker network to reach the controller. First, create a Docker network exclusive to this lab running the command below:

```
docker network create --subnet=10.10.10.0/24 --gateway=10.10.10.1 sd_rsix
```

List the Docker networks to get the ID of the network created:

```
$ docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
c33df49ae2e1        bridge              bridge              local
4611cdd66e56        host                host                local
99686584619c        none                null                local
eba863006310        sd_rsix             bridge              local    <<-
```

In the example above, the Network ID of the network __sd_rsix__ is __eba863006310__

In GNS3, go to _Edit_ > _Preferences_; go to _Built-in_ and select _Cloud nodes_ and do the following:

 * Create a new cloud by clicking _new_ and name it as you want and click _Finish_
 * Select the cloud node you just created and click _Edit_
 * In the new window, in the _Ethernet interfaces_ tab, check _Show special Ethernet interfaces_, then select the interface of the network __sd_rsix__ by its ID (__br-eba863006310__) and click _Add_
 * In the _Misc_ tab, it may be convenient to change de _Default name format_ for another name easier to identify when the node is deployed (e.g. Docker-net{0})
 * Click _OK_ and _OK_.

Back to the project window, add the cloud node you created (You must have given a name to it) to the project and connect it to _Management-SW_. The _Management-SW_ connects all the Open vSwitches through their Eth0 interface (Management interface).

## Ajusting Idle-PC

After importing and starting the Lab, click on any of the Cisco IOS Routers (e.g. Router Server) and select _Auto Idle-PC_ to reduce the burden of the Lab on your computer.
