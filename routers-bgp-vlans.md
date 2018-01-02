This file contains templates and examples of configuration of devices used in the Labs.


# VLAN

## RSiX VLANs - Production and Quarentine

At Brazilians IX VLANs 10 and 20 are used in production environment to connect all connected ASes IPv4 and IPv6 respectively. Additionally, VLANs 101, 102 and 103 are used for IPv4 quarentine, and vlan 201, 202 and 203 for IPv6 quarentine. Quarentine VLANs are used for a short period before to migrate ASes to the production VLANs and also use the template below.

Address blocks in use are:

 * VLAN 10 (and 101, 102, 103): 200.219.143.XXX/24 - _The addresses are defined by RSiX_
 * VLAN 20 (and 201, 202, 203): 2001:12F8:0:6::<ASN>/64 - _The interface identifier of the IPv6 address uses the ASN; see the templates below for 16 - 32 bits numbers:_
    * 2001:12F8:0:6::XXXX
    * 2001:12F8:0:6::X:XXXX
    * 2001:12F8:0:6::XX:XXXX

```
conf t
!
vlan 10
 name RSiX-v4
 exit
vlan 20
 name RSiX-v6
 exit
!
interface Vlan10
 description RSiX IPv4 interface
 ip address 200.219.143.XXX 255.255.255.0
!
interface Vlan20
 description RSiX IPv6 interface
 no ip address
 ipv6 address 2001:12F8:0:6::<ASN>/64
!
interface FastEthernet1/0
 description RSiX
 switchport
 !!! The IOS used requires VLANs 1, 1002-1005 on each trunk
 switchport trunk allowed vlan 1,10,20,1002-1005
 switchport mode trunk
 duplex full
 speed 100
 no shutdown
 end
!
write memory
!
```

## Bilateral VLANs

Bilateral VLANs are employed in private communication between two ASes. __VLAN's IDs are defined by the IX team.__

ASes may ask as many bilateral VLANs as they want.

```
conf t
!
vlan <VLAN ID>
 name VLAN_<AS name>_x_<other AS name>
 exit
!
interface Vlan<VLAN ID>
 description VLAN_<AS name>_x_<other AS name>
 ip address <IP address> <network mask>
 ipv6 address <IPv6 adress>/<network mask>
!
interface FastEthernet1/0
 switchport trunk add vlan <VLAN ID>
 end
!
write memory
!
```


# BGP

```
ip routing
ipv6 unicast-routing
```

## Peering configuration in Route Server

The Route Server is a BGP daemon running on a Docker container so that the configuration below, after edited, must be set in the lab/containers-src/route-server/config/bgpd.conf file to make it persistent -- requires route server Docker image rebuilding. For temporary effect (until closing GN3) configuration may be set using CLI.

```
ip as-path access-list RSiX-as-path permit ^_ASN__
!
router bgp 26162
!
 neighbor xxx.xxx.xxx.xxx remote-as _ASN_
 neighbor xxx.xxx.xxx.xxx description === NAME ===
 neighbor xxx.xxx.xxx.xxx soft-reconfiguration inbound
 neighbor xxx.xxx.xxx.xxx maximum-prefix 500 restart 10
 neighbor xxx.xxx.xxx.xxx prefix-list RSiX-v4-prefix-limit in
 neighbor xxx.xxx.xxx.xxx filter-list RSiX-as-path out
 neighbor xxx.xxx.xxx.xxx attribute-unchanged as-path next-hop
 neighbor 2001:12f8:0:6::XX:XXXX remote-as _ASN_
 neighbor 2001:12f8:0:6::XX:XXXX description === NAME ===
 no neighbor 2001:12f8:0:6::XX:XXXX activate
 !
 address-family ipv6
  neighbor 2001:12f8:0:6::XX:XXXX activate
  neighbor 2001:12f8:0:6::XX:XXXX soft-reconfiguration inbound
  neighbor 2001:12f8:0:6::XX:XXXX maximum-prefix 100 restart 10
  neighbor 2001:12f8:0:6::XX:XXXX prefix-list RSiX-v6-prefix-limit in
  neighbor 2001:12f8:0:6::XX:XXXX filter-list RSiX-as-path out
  neighbor 2001:12f8:0:6::XX:XXXX attribute-unchanged as-path next-hop
  exit address-family
 !
  end
!
write memory
!
```

### Cisco IOS Routers

Before configure BGP, you must have IP (v4 and v6) connectivity to Route-Server

The IOS version in use requires VLANs to be created in the VLAN database. Otherwise, VLAN interfaces will not go up.

```
# vlan database
(vlan)# vlan 10 name RSiX-v4
(vlan)# vlan 20 name RSiX-v6
(vlan)# exit
```

Now, configure interfaces as follows:

```
!
conf t
!
!         
interface Vlan10
 description RSiX IPv4 interface
 ip address <IPv4 address> 255.255.255.0
!
interface Vlan20
 description RSiX IPv6 interface
 no ip address
 ipv6 address <IPv6 address>/64
!
!
interface FastEthernet1/0
 description RSiX
 switchport trunk allowed vlan 1,10,20,1002-1005
 switchport mode trunk
 duplex full
 speed 100
!
```

Use ping to check connectivity with the Route Server (200.219.143.254) - remember the Open vSwitches won't forward packets without a controller unless they have been configured in __standalone mode__ (ovs-vsctl set-fail-mode br0 standalone).

Once there is connectivity, proceed to BGP configuration following the template below:

```
!
conf t
!
ip routing
ipv6 unicast-routing
!
!
ip route <network> <netmask> Null0 254
ipv6 route <v6_network>/<mask> Null0 254
!
!
ip prefix-list <ASN>-prefixes permit <network>/<mask> le 28
ipv6 prefix-list <ASN>-prefixes permit <v6_network>/<mask> le 56
!
!
router bgp <ASN>
 bgp router-id <IPv4 address>
 no bgp enforce-first-as
 bgp log-neighbor-changes
 neighbor 2001:12F8:0:6::2:6162 remote-as 26162
 neighbor 2001:12F8:0:6::2:6162 description === RSiX Route Server ===
 neighbor 200.219.143.254 remote-as 26162
 neighbor 200.219.143.254 description === RSiX Route Server ===
 !
 address-family ipv4
  redistribute connected
  no neighbor 2001:12F8:0:6::2:6162 activate
  neighbor 200.219.143.254 activate
  neighbor 200.219.143.254 next-hop-self
  neighbor 200.219.143.254 soft-reconfiguration inbound
  neighbor 200.219.143.254 prefix-list <ASN>-prefixes out
  no auto-summary
  no synchronization
  !
  network <network> mask <netmask>
  !
  exit-address-family
 !
 address-family ipv6
  neighbor 2001:12F8:0:6::2:6162 activate
  neighbor 2001:12F8:0:6::2:6162 next-hop-self
  neighbor 2001:12F8:0:6::2:6162 soft-reconfiguration inbound
  neighbor 2001:12F8:0:6::2:6162 prefix-list <ASN>-prefixes out
  redistribute connected
  !
  network <v6_network>/<mask>
  !
  exit-address-family
 !
 exit
!
exit
!
write memory
!
```

### Quagga Routers
