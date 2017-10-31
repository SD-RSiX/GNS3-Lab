



# Running

Before to run, you need to build the Lab.

The detailed information and instructions are in the README.md file into the __lab__ directory.


## Accessing switches

Once the Lab is running, double click in any switch to open its console.

Some of the commands available are the following:

* __ifconfig__: Lists switch's interfaces (physical and bridges)
* __ovs-vsctl show__: Shows bridges information and ports
* __ovs-ofctl -O OpenFlow13 dump-ports br0__: Shows br0's ports information according OpenFlow 1.3 version
* __ovs-ofctl -O OpenFlow13 dump-flows br0__: Shows OpenFlow 1.3 flow entries at br0


## Accessing routers


ovs-vsctl set-fail-mode ovs-switch standalone
