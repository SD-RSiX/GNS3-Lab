# Building the Lab

## Requirements

* [GNS3 1.5+](https://www.gns3.com)
* [Docker](https://www.docker.com/)
* Cisco IOS 3725 - Version 12.4(15)T14 image

The Lab is based on GNS3, Docker, [Ryu SDN Controller](https://osrg.github.io/ryu/), [Quagga](http://www.nongnu.org/quagga/), and [Open vSwitch](http://openvswitch.org/). Although, the only two things must be installed are GNS3 and Docker, because Ryu, Quagga, and Open vSwitch run in Docker containers. You also need a Cisco IOS 3725 version 12.4(15)T14 - it requires a license and we can not provide it, so you need to get it by your own.

## Building Docker images

### Open vSwitch

For this Lab we had to change the GNS3 Open vSwitch Docker image in order to set the controller to 10.10.10.254:6633 and the fail mode to secure. With this changes the switches will not forward packets unless they are connected to a controller.

Run the following command to build Open vSwitch Docker image:

```
docker build -t sd-rsix/ovs:latest containers-src/open-vswitch
```

### Routers
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

In GNS3, go to _Edit_ > _Preferences_; go to _Built-in_ and select _Cloud nodes_. Create a new cloud by clicking _new_ and name it as you want and click _Finish_. Select the cloud node you just created and click _Edit_. In the new window, in the _Ethernet interfaces_ tab, check _Show special Ethernet interfaces_, then select the interface of the network __sd_rsix__ by its ID (__br-eba863006310__) and click _Add_. Click _OK_ and _OK_.

Back to the project window, add the cloud node you created (You must have given a name to it) to the project and connect it to _Management-SW_. The _Management-SW_ connects all the Open vSwitches by their management interfaces.


## Ryu controller

[Ryu Docker container](https://store.docker.com/community/images/osrg/ryu)
