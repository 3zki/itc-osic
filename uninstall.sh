#!/bin/sh
# ========================================================================
# IIC Open-Source EDA Environment for Ubuntu WSL2
# This script will delete some stuffs in your home directory
# to change the PDK. 
# ========================================================================
rm -f $HOME/.magicrc
rm -f $HOME/.spiceinit
rm -rf $HOME/.klayout
rm -rf $HOME/.xschem
rm -rf $HOME/.gaw
python3.9 -m pip uninstall -y gdsfactory==6.116.0
sed -i -e '/export PDK_ROOT=/d' $HOME/.bashrc
sed -i -e '/export PDK=/d' $HOME/.bashrc
sed -i -e '/export STD_CELL_LIBRARY=/d' $HOME/.bashrc
sed -i -e '/iic-osic-20230222/d' $HOME/.bashrc
echo ">> All done."
