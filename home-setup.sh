#!/bin/sh
# ========================================================================
# Initialization of IIC Open-Source EDA Environment for Almalinux 8.7
# This script installs xschem, ngspice, magic, netgen and a few other tools for use with SkyWater Technology SKY130.
# ========================================================================

# Define setup environment
# ------------------------
export PDK_ROOT="/usr/keio/iic-osic-20230222/usr/local/pdk"
export MY_STDCELL=sky130_fd_sc_hd
my_path=$(realpath "$0")
my_dir=$(dirname "$my_path")
export SCRIPT_DIR="$my_dir"
export PDK=sky130A
export KL_PATH="/usr/keio/iic-osic-20230222/usr/local/klayout"

# Start
# --------
echo ""
echo ">>>> Initializing..."
echo ""

# Copy KLayout Configurations
# ----------------------------------
if [ ! -d "$HOME/.klayout" ]; then
	# cp -rf klayout $HOME/.klayout
	mkdir $HOME/.klayout
	cp -f klayoutrc $HOME/.klayout
	cp -rf macros $HOME/.klayout/macros
	cp -rf drc $HOME/.klayout/drc
	cp -rf lvs $HOME/.klayout/lvs
	mkdir $HOME/.klayout/libraries
fi

# Create .magicrc
# ---------------------------------------
cp -f $PDK_ROOT/$PDK/libs.tech/magic/$PDK.magicrc $HOME/.magicrc

# Create .spiceinit
# -----------------
{
	echo "set num_threads=4"
	echo "set ngbehavior=hsa"
	echo "set ng_nomodcheck"
} > "$HOME/.spiceinit"

# Create path in .bashrc
# ------------------
if [ ! -d "$HOME/.xschem" ]; then
	mkdir "$HOME/.xschem"
fi
{
	echo "export PDK_ROOT=$PDK_ROOT"
	echo "export PDK=$PDK"
	echo "export STD_CELL_LIBRARY=$MY_STDCELL"
	echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$KL_PATH"
	echo "export PATH=\$PATH:$KL_PATH"
} >> "$HOME/.bashrc"

export PDK_ROOT=$PDK_ROOT
export PDK=$PDK
export STD_CELL_LIBRARY=$MY_STDCELL
cp -f $PDK_ROOT/$PDK/libs.tech/xschem/xschemrc $HOME/.xschem
#cp -rf $PDK_ROOT/$PDK/libs.tech/klayout/drc $HOME/.klayout/drc
#cp -rf $PDK_ROOT/$PDK/libs.tech/klayout/lvs $HOME/.klayout/lvs
#rm -rf $HOME/.klayout/lvs/sky130.lylvs
cp -rf $PDK_ROOT/$PDK/libs.tech/klayout/pymacros $HOME/.klayout/pymacros
#cp -rf $PDK_ROOT/$PDK/libs.tech/klayout/scripts $HOME/.klayout/scripts
mkdir $HOME/.klayout/tech/
mkdir $HOME/.klayout/tech/sky130
cp -f $PDK_ROOT/$PDK/libs.tech/klayout/tech/$PDK.lyp $HOME/.klayout/tech/sky130/sky130.lyp
cp -f $PDK_ROOT/$PDK/libs.tech/klayout/tech/$PDK.lyt $HOME/.klayout/tech/sky130/sky130.lyt

cp -f $PDK_ROOT/$PDK/libs.ref/sky130_fd_pr/gds/sky130_fd_pr.gds $HOME/.klayout/libraries/
cp -f $PDK_ROOT/$PDK/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds $HOME/.klayout/libraries/
cp -f $PDK_ROOT/$PDK/libs.ref/sky130_fd_sc_hvl/gds/sky130_fd_sc_hvl.gds $HOME/.klayout/libraries/

# Finished
# --------
echo ""
echo ">>>> All done. Please restart."
echo ""
