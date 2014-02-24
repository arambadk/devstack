#!/bin/bash

eval $(grep ^Q_PLUGIN= ./localrc)
eval $(grep '^declare -a Q_CISCO_PLUGIN_SUBPLUGINS=' ./localrc)
if [[ "$Q_PLUGIN" != "cisco" || "${Q_CISCO_PLUGIN_SUBPLUGINS[0]}" != "n1kv" ]]; then
   echo "Not using the Cisco N1kv plugin. Exiting!"
   exit
fi

localrc=$PWD/localrc
eval $(grep ^DEST= ./localrc)
eval $(grep ^DEST= ./stackrc)
eval $(grep NEUTRON_DIR= ./lib/neutron)

cd $NEUTRON_DIR
script_dir=$(dirname $(find $NEUTRON_DIR -name csr1kv_install_all.sh)) 
cd $script_dir
./install_all neutron n1kv $localrc
