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

```
ip as-path access-list 1 permit ^ANS_

router bgp 26162
 address-family ipv4
  neighbor 200.219.143.XXX remote-as ASN
  neighbor 200.219.143.XXX description === <AS Name> ===
  neighbor 200.219.143.XXX peer-group RSiX-v4
  exit
 address-family ipv6
  neighbor 2001:12F8:0:6::<AS Number as Interface ID> remote-as ASN
  neighbor 2001:12F8:0:6::<AS Number as Interface ID> description === <AS Name> ===
  neighbor 2001:12F8:0:6::<AS Number as Interface ID> peer-group RSiX-v6
  end
!
write memory
!
```

## Peering in ASes Routers

### Cisco IOS Routers

```
!
conf t
!
ip routing
ipv6 unicast-routing
!

```
