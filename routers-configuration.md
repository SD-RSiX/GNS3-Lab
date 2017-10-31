
# VLAN

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
 ip address 200.219.143.254 255.255.255.0
!
interface Vlan20
 description RSiX IPv6 interface
 no ip address
 ipv6 address 2001:12F8:0:6::2:6162/64
!
interface FastEthernet1/0
 description RSiX
 switchport
 switchport trunk allowed vlan 1,10,20,1002-1005
 switchport mode trunk
 duplex full
 speed 100
 no shutdown
 end
!
write memory
!

# BGP

```
ip routing
ipv6 unicast-routing
```


# Route server - Adding a new AS

router bgp 26162
 no synchronization
 bgp router-id 200.219.143.254
 bgp log-neighbor-changes
 neighbor RSiX-v4 peer-group
 neighbor RSiX-v4 soft-reconfiguration inbound
 neighbor RSiX-v4 prefix-list ATM-prefix-limit in
 neighbor RSiX-v4 maximum-prefix 500 restart 10
 neighbor RSiX-v4 filter-list 1 out
 neighbor RSiX-v4 next-hop-unchanged
 neighbor RSiX-v6 peer-group
 neighbor RSiX-v6 soft-reconfiguration inbound
 neighbor RSiX-v6 prefix-list ATM-prefix-limit in
 neighbor RSiX-v6 maximum-prefix 500 restart 10
 neighbor RSiX-v6 filter-list 1 out
 neighbor RSiX-v6 next-hop-unchanged
 no auto-summary
!
ip as-path access-list 1 permit ^2716_
ip as-path access-list 1 permit ^1916_
!
ip prefix-list ATM-prefix-limit seq 10 deny 0.0.0.0/0
ip prefix-list ATM-prefix-limit seq 20 deny 200.219.143.0/24
ip prefix-list ATM-prefix-limit seq 30 permit 0.0.0.0/0 le 29
!
ipv6 prefix-list ATM-6-prefix-limit seq 10 deny ::0/0
ipv6 prefix-list ATM-6-prefix-limit seq 20 deny  2001:12F8:0:6::/64
ipv6 prefix-list ATM-6-prefix-limit seq 30 permit ::0/0 le 
!


ip as-path access-list 1 permit ^2716_

router bgp 26162
 address-family ipv4
  neighbor 200.219.143.1 remote-as 2716
  neighbor 200.219.143.1 description === Rede Tche ===
  neighbor 200.219.143.1 peer-group RSiX-v4
  exit
 address-family ipv6
  neighbor 2001:12F8:0:6::2716 remote-as 2716
  neighbor 2001:12F8:0:6::2716 description === Rede Tche ===
  neighbor 2001:12F8:0:6::2716 peer-group RSiX-v6
  end
!




 neighbor 200.219.143.1 attribute-unchanged as-path next-hop

 neighbor 2001:12f8:0:6::2716 remote-as 2716
 no neighbor 2001:12f8:0:6::2716 activate
!
 address-family ipv6
 neighbor 2001:12f8:0:6::2716 activate
 neighbor 2001:12f8:0:6::2716 soft-reconfiguration inbound
 neighbor 2001:12f8:0:6::2716 maximum-prefix 500 restart 10
 neighbor 2001:12f8:0:6::2716 attribute-unchanged as-path next-hop
  exit-address-family
!
ip prefix-list ATM-prefix-limit description ====Limita prefixos menores ou igual a /29====
ip prefix-list ATM-prefix-limit seq 10 deny 0.0.0.0/0
ip prefix-list ATM-prefix-limit seq 20 deny 200.219.143.0/24
ip prefix-list ATM-prefix-limit seq 25 deny 200.236.32.0/21
ip prefix-list ATM-prefix-limit seq 30 permit 200.236.32.0/19 ge 29
ip prefix-list ATM-prefix-limit seq 40 permit 0.0.0.0/0 le 29
!
ip as-path access-list 32 permit .*
ip as-path access-list 69 deny .*
ip as-path access-list ATM permit ^2716_
!
