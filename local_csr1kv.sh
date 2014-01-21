#!/bin/bash

devstack_dir=$(find -L $HOME -name devstack -type d)
cd $devstack_dir
eval $(grep ^Q_PLUGIN= ./localrc)
eval $(grep '^declare -a Q_CISCO_PLUGIN_SUBPLUGINS=' ./localrc)
if [[ "$Q_PLUGIN" == "csr1kv_openvswitch" ]]; then
   plugin=ovs
elif [[ "$Q_PLUGIN" != "cisco" || "${Q_CISCO_PLUGIN_SUBPLUGINS[0]}" != "n1kv" ]]; then
   plugin=n1kv
else
   echo "Not a deployment with CSR1kv. Exiting!"
   exit
fi

localrc=$PWD/localrc
eval $(grep ^DEST= ./localrc)
eval $(grep ^DEST= ./stackrc)
eval $(grep NEUTRON_DIR= ./lib/neutron)

script_dir=$(dirname $(find $NEUTRON_DIR -name csr1kv_install_all.sh))
cd $script_dir
./csr1kv_install_all.sh neutron $plugin $localrc

