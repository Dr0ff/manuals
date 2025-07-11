#!/bin/bash
sudo systemctl stop chihuahuad.service
SNAP_RPC="https://rpc.cosmos.directory:443/chihuahua"
BACK_TO_BLOCKS=2000
echo -e "\e[33mRPC NODE:\e[32m $SNAP_RPC\e[0m"
echo -e "\e[33mBack to blocks:\e[32m $BACK_TO_BLOCKS\e[0m"

chihuahuad tendermint unsafe-reset-all --home $HOME/.chihuahuad --keep-addr-book

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$((LATEST_HEIGHT - $BACK_TO_BLOCKS));
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash) 
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH && sleep 2
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ;
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ;
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ;
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ;
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.chihuahuad/config/config.toml
sudo systemctl start chihuahuad.service
sudo journalctl -u chihuahuad -f --output cat
