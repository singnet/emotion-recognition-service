#!/bin/bash

snet_daemon_v=1.0.0
snet_daemon_v_2=4.0.0


# apt install tar
if [ ! -d snet-daemon-v$snet_daemon_v ] ; then
	echo "Downloading snetd-linux"
	wget https://github.com/singnet/snet-daemon/releases/download/v$snet_daemon_v/snet-daemon-v$snet_daemon_v-linux-amd64.tar.gz
	tar -xzf snet-daemon-v$snet_daemon_v-linux-amd64.tar.gz
	ln snet-daemon-v$snet_daemon_v-linux-amd64/snetd snetd-linux-amd64
	rm snet-daemon-v$snet_daemon_v-linux-amd64.tar.gz
	wget https://github.com/singnet/snet-daemon/releases/download/v$snet_daemon_v_2/snet-daemon-v$snet_daemon_v_2-linux-amd64.tar.gz
	tar -xzf snet-daemon-v$snet_daemon_v_2-linux-amd64.tar.gz
	ln snet-daemon-v$snet_daemon_v_2-linux-amd64/snetd snetd-linux-amd64-2
	rm snet-daemon-v$snet_daemon_v_2-linux-amd64.tar.gz


else
	echo "Folder seems to exist"
fi

python3.6 -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. service_spec/EmotionService.proto

python3.6 get_models.py

# Here may be add a script that does check there is not files that are added.
cp snet.config.example.mainnet snet.config.example.mainnet.json
cp snet.config.example.mainnet-2 snet.config.example.mainnet-2.json
cp snet.config.example.ropsten snet.config.example.ropsten.json
