
It is a network lab designed for SDN approaches for [Internet Exchange Points (IXP)](https://en.wikipedia.org/wiki/Internet_exchange_point) prototyping. This project has been developed in conjunction with [\[SD\]RSiX Controller](https://bitbucket.org/sd-rsix/sd-rsix-controller/overview).

The Lab was based (in a reduced scale) on the [RSiX Internet Exchange (Rio Grande do Sul IXP - Porto Alegre) Infrastructure](http://ix.br/adesao/rs/) and [connected ASes](http://ix.br/particip/rs), and it mirrors the services and configurations in use in Brazilian IXPs.

Without a running controller, the Lab works as well. Check the "_Changing Open vSwitches operating mode_" section below for details.


# Requirements

* [GNS3 1.5+](https://www.gns3.com)
* [Docker](https://www.docker.com/)
* [Docker Compose](https://docs.docker.com/compose/)
* Cisco IOS 3725 version 12.4(15)T7 image

The Lab is based on GNS3, Docker, [Quagga](http://www.nongnu.org/quagga/), and [Open vSwitch](http://openvswitch.org/). Although you only need to install GNS3, Docker and Docker Compose, because of Ryu, Quagga, and Open vSwitch run in Docker containers. You also need a Cisco IOS 3725 version 12.4(15)T7 (c3725-adventerprisek9-mz124-15) - it requires a license, and we can not provide it, so you need to get it on your own.


# Building the Lab

## Docker images

We used routers and switches running on Docker in order to reduce the Lab's burden on personal computers. This section covers how to build the images we will import ahead into GNS3.

### Open vSwitch

We changed the GNS3 Open vSwitch Docker image in order to set the controller to 10.10.10.254:6633 and the fail mode to secure. With this changes, the switches will not forward packets unless they connect to a controller.

Run the following command to build Open vSwitch Docker image:

```
docker build -t sd-rsix/ovs:latest containers-src/open-vswitch
```

### Routers

Containers are not supposed to change: they are supposed to be replaced, so the changes you do in a container will be lost when the container is destroyed (closing GNS3, for example). We could have used volumes to persist container's configuration changes, but to make them simpler and portable, they do not store anything but the configuration they were built with.

The commands below build all the router containers with the appropriate configuration. You will build them only once unless you want to change some configuration and make it persistent.

Buiding the first container takes a little longer because it downloads the base image.

Build one by one running the following Docker commands:

```
## Run the following commands in the same directory where this file is.

## Route Server
docker build -t sd-rsix/route-server:latest containers-src/route-server
##
## AS2906-b
docker build -t sd-rsix/as2906-b:latest containers-src/as2906-b
```


## GNS3

This document does not cover GNS3 installation. The sections below cover how to import Docker and IOS into GNS3.

### Importing Docker images to GNS3

After building the Docker images, open GNS3 and import all the _.gns3a_ files in the _GNS3-import_ folder (one by one). You may change some options in the importing dialog according to your preferences.

### Importing Cisco IOS image

Open _Preferences_ window by going to _Edit_ > _Preferences_, select _IOS Routers_ on the left and click _New_, on the right. Follow the dialog, but in the second window check _This is an EthernetSwitch router_, so GNS3 will attach a 16 ports switch module.

### Importing GNS3 project

Download the latest version of the project from [here](https://www.dropbox.com/sh/znb6ckb9d7ymiar/AABazkB_lGZ6T7IR4TXXEcyMa?dl=0) and import to GNS3 through _File_ > _Import portable project_.


## Connecting Open vSwitches to the Docker network

At this point, you have a GNS3 project ready to run. Although, the Open vSwitches need a connection with a Docker network to reach the controller.

First, create a Docker network exclusive to this lab running the command below:

```
docker network create --subnet=10.10.10.0/24 --gateway=10.10.10.1 sd_rsix
```

List the Docker networks to get the ID of the network you just created:

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

## Ajusting Idle-PC (Reduce processing)

After importing and starting the Lab, click on any of the Cisco IOS Routers (e.g. Router Server) and select _Auto Idle-PC_ to reduce the burden of the Lab on your computer.


# Changing Open vSwitches operating mode

Open vSwitch has two different _fail mode_ configuration:

 * __standalone__: in this mode, the switch forwards packets normally regardless it connects or not to a controller. If connected to a controller, the switch processes the packets against flow entries before the normal switching.
 * __secure__: in secure mode, the switch only forwards packets based on flow entries. It does not connect to a controller or if a controller connection goes down the packets will be forwarded based on the existing flow entries until they expire; if the switch can not get any flow entry packets will not be forwarded.

The images built for the Lab operate in _secure mode_ by default, but it can be changed running the commands below. Remember that changing the container does not change the image, so if you close GNS3 it removes containers and it will restore them to the original state when it opens the Lab again.

```
## change fail mode to 'standalone'
ovs-vsctl set-fail-mode br0 standalone

## change fail mode to 'secure'
ovs-vsctl set-fail-mode br0 secure
```


# Rebuilding a Docker-based Router

If you pulled this repository and it changed the configuration files of the routers (files inside 'containers-src' folder), or you changed it manually, you need to rebuild the image to get the newer version running.
