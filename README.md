Blah blah blah about the projetc. Not for now.

# Running

Before to run, you need to build the Lab.

The detailed information and instructions are in the README.md file in the __lab__ folder. After building the Lab, back here to run it following the sections below.


## GNS3 Lab

After building the Docker images and importing them to GNS3, importing the Cisco 3725 image (not provided with this project), and configuring and deploying the cloud node to connect to the Docker network, click the __Start (PLAY)__ button. Just that!


## Controller

This project uses the [Ryu SDN Controller](http://osrg.github.io/ryu/) on a Docker container; you may run the controller before or after starting the GNS3 Lab. It uses _docker-compose_ to build the image and run the container. Ryu runs the code in the _src_ folder.

In order to start the controller container, run the following command inside _controller_ folder:

```
docker-compose up
```

If you change the code in _src_ folder, you need to deploy de container again. Preferably, always start the container with the command below just in case:

```
## Rebuilds the image and starts the controller container
docker-compose up --build
```

If you want to remove everything created by _docker-compose_, run:

```
# Remove container, network and the image locally generated:
docker-compose down --rmi local
```


## OpenFlow switches (Open vSwitch) commands and operating modes

Open vSwitches start when you run the GNS3 Lab by clicking the _play_ button. In order to access the switches' console, once the Lab is running, double-click in any switch.

Follow some useful commands:

```
## List switch's interfaces (physical and bridges)
ifconfig

## Show information and ports of all bridges
ovs-vsctl show

## Show br0's ports information in OpenFlow 1.3 and 1.0 versions
ovs-ofctl -O OpenFlow13 dump-ports br0
ovs-ofctl -O OpenFlow10 dump-ports br0

## Show br0's flow entries in OpenFlow 1.3 and 1.0 versions
ovs-ofctl -O OpenFlow13 dump-flows br0
ovs-ofctl -O OpenFlow13 dump-flows br0
```

### Changing Open vSwitches operating mode

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

## Routers, BGP, and VLANs

In this same folder, there is the file _routers-bgp-vlans.md_ with instructions and configuration examples on how to configure routers and VLANs.
