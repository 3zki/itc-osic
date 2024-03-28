#!/bin/sh
# ========================================================================
# Initialization of IIC Open-Source EDA Environment for KIC
# PDK=SKY130
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

# --------
echo ""
echo ">>>> Initializing..."
echo ""

python3.9 -m pip install gdsfactory==6.116.0

# Copy KLayout Configurations
# ----------------------------------
if [ ! -d "$HOME/.klayout" ]; then
	# cp -rf klayout $HOME/.klayout
	mkdir $HOME/.klayout
	cp -f sky130/klayoutrc $HOME/.klayout
	cp -rf sky130/macros $HOME/.klayout/macros
	cp -rf sky130/drc $HOME/.klayout/drc
	cp -rf sky130/lvs $HOME/.klayout/lvs
	cp -rf sky130/pymacros $HOME/.klayout/pymacros
	mkdir $HOME/.klayout/libraries
fi

# Create .spiceinit
# -----------------
{
	echo "set num_threads=$(nproc)"
	echo "set ngbehavior=hsa"
	echo "set ng_nomodcheck"
} > "$HOME/.spiceinit"

# Create iic-init.sh
# ------------------
if [ ! -d "$HOME/.xschem" ]; then
	mkdir "$HOME/.xschem"
fi
{
	echo "export PDK_ROOT=$PDK_ROOT"
	echo "export PDK=$PDK"
	echo "export STD_CELL_LIBRARY=$MY_STDCELL"
	echo "export LD_LIBRARY_PATH=¥$LD_LIBRARY_PATH:$KL_PATH"
	echo "export PATH=¥$PATH:$KL_PATH"
} >> "$HOME/.bashrc"

# Copy various things
# -------------------
export PDK_ROOT=$PDK_ROOT
export PDK=$PDK
export STD_CELL_LIBRARY=$MY_STDCELL
cp -f $PDK_ROOT/$PDK/libs.tech/xschem/xschemrc $HOME/.xschem
cp -f $PDK_ROOT/$PDK/libs.tech/magic/$PDK.magicrc $HOME/.magicrc
# cp -rf $PDK_ROOT/$PDK/libs.tech/klayout/drc $HOME/.klayout/drc
# cp -rf $PDK_ROOT/$PDK/libs.tech/klayout/lvs $HOME/.klayout/lvs
# cp -rf $PDK_ROOT/$PDK/libs.tech/klayout/pymacros $HOME/.klayout/pymacros
# cp -rf $PDK_ROOT/$PDK/libs.tech/klayout/scripts $HOME/.klayout/scripts
mkdir $HOME/.klayout/tech/
mkdir $HOME/.klayout/tech/sky130
cp -f $PDK_ROOT/$PDK/libs.tech/klayout/tech/$PDK.lyp $HOME/.klayout/tech/sky130/sky130.lyp
cp -f $PDK_ROOT/$PDK/libs.tech/klayout/tech/$PDK.lyt $HOME/.klayout/tech/sky130/sky130.lyt
cp -f $PDK_ROOT/$PDK/libs.tech/klayout/tech/$PDK.map $HOME/.klayout/tech/sky130/sky130.map
# cp -f $PDK_ROOT/$PDK/libs.ref/sky130_fd_pr/gds/sky130_fd_pr.gds $HOME/.klayout/libraries/
# cp -f $PDK_ROOT/$PDK/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds $HOME/.klayout/libraries/
# cp -f $PDK_ROOT/$PDK/libs.ref/sky130_fd_sc_hvl/gds/sky130_fd_sc_hvl.gds $HOME/.klayout/libraries/

# Fix paths in xschemrc to point to correct PDK directory
# -------------------------------------------------------
# sed -i -e 's/^set SKYWATER_MODELS/# set SKYWATER_MODELS/g' "$HOME/.xschem/xschemrc"
# echo 'set SKYWATER_MODELS $env(PDK_ROOT)/$env(PDK)/libs.tech/ngspice' >> "$HOME/.xschem/xschemrc"
# sed -i -e 's/^set SKYWATER_STDCELLS/# set SKYWATER_STD_CELLS/g' "$HOME/.xschem/xschemrc"
# echo 'set SKYWATER_STDCELLS $env(PDK_ROOT)/$env(PDK)/libs.ref/sky130_fd_sc_hd/spice' >> "$HOME/.xschem/xschemrc"


# Finished
# --------
echo ""
echo ">>>> All done. Please restart"
echo ""
