
TCHE_2716#conf t
TCHE_2716(config)#vlan 10
TCHE_2716(config-vlan)#name RSiX-v4
TCHE_2716(config-vlan)#exit
TCHE_2716(config)#vlan 20
TCHE_2716(config-vlan)#name RSiX-v6
TCHE_2716(config-vlan)#exit
TCHE_2716(config)#interface vlan 10
TCHE_2716(config-if)#description RSiX IPv4 interface
TCHE_2716(config-if)#ip address 200.219.143.1 255.255.255.0
TCHE_2716(config-if)#exit
TCHE_2716(config)#interface vlan 20
TCHE_2716(config-if)#description RSiX IPv6 interface
TCHE_2716(config-if)#ipv6 address 2001:12f8:0:6::2716/64
TCHE_2716(config-if)#exit

TCHE_2716(config)#interface fastEthernet 1/0
TCHE_2716(config-if)#description RSiX    
TCHE_2716(config-if)#switchport
TCHE_2716(config-if)#switchport mode trunk
TCHE_2716(config-if)#switchport trunk allowed vlan 1,10,20,1002-1005
TCHE_2716(config-if)#no shutdown
TCHE_2716(config-if)#end

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
 ip address 200.219.143.3 255.255.255.0
!
interface Vlan20
 description RSiX IPv6 interface
 no ip address
 ipv6 address 2001:12F8:0:6::1916/64
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
