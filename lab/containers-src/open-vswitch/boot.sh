#!/bin/sh
#
# Copyright (C) 2017 Lucas Arbiza.
# Copyright (C) 2015 GNS3 Technologies Inc.
#
# -----------------------------------------------------------------------------
# It is an adaptation of the GNS3 version, available at
# https://hub.docker.com/r/gns3/openvswitch/~/dockerfile/
#
# In this version, the script sets the controller as 10.10.10.254 and the fail
# mode to secure.
# -----------------------------------------------------------------------------
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


if [ ! -f "/etc/openvswitch/conf.db" ]
then
  ovsdb-tool create /etc/openvswitch/conf.db /usr/share/openvswitch/vswitch.ovsschema

  ovsdb-server --detach --remote=punix:/var/run/openvswitch/db.sock
  ovs-vswitchd --detach
  ovs-vsctl --no-wait init

  x=0
  until [ $x = "4" ]; do
    ovs-vsctl add-br br$x
    ovs-vsctl set bridge br$x datapath_type=netdev
    ovs-vsctl set-controller br$x tcp:10.10.10.254:6633
    ovs-vsctl set-fail-mode br$x secure
    x=$((x+1))
  done

  if [ $MANAGEMENT_INTERFACE == 1 ]
  then
    x=1
  else
    x=0
  fi

  until [ $x = "16" ]; do
    ovs-vsctl add-port br0 eth$x
    x=$((x+1))
  done
else
  ovsdb-server --detach --remote=punix:/var/run/openvswitch/db.sock
  ovs-vswitchd --detach
fi


x=0
until [ $x = "4" ]; do
  ip link set dev br$x up
  x=$((x+1))
done

/bin/sh
