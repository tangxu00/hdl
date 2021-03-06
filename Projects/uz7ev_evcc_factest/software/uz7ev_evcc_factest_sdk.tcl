# ----------------------------------------------------------------------------
#       _____
#      *     *
#     *____   *____
#    * *===*   *==*
#   *___*===*___**  AVNET
#        *======*
#         *====*
# ----------------------------------------------------------------------------
# 
#  This design is the property of Avnet.  Publication of this
#  design is not authorized without written consent from Avnet.
# 
#  Please direct any questions or issues to the UltraZed Community Forums:
#      http://www.ultrazed.org
# 
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2016 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         Nov 13, 2017
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     UltraZed-EV SOM
# 
#  Tool versions:       Vivado 2017.2
# 
#  Description:         SDK Build Script for UltraZed-EV SOM hardware platform
# 
#  Dependencies:        To be called from a configured make script call
#
#  Revision:            Nov 13, 2017: 1.00 Initial version
# 
# ----------------------------------------------------------------------------

#!/usr/bin/tclsh
set project  "uz7ev_evcc_factest"
set hw_name  "uz7ev_evcc_factest_hw"
set bsp_name "uz7ev_evcc_factest_bsp"

# Set workspace and import hardware platform
sdk setws ${project}.sdk
puts "\n#\n#\n# Importing hardware definition ${hw_name} from impl_1 folder ...\n#\n#\n"
file copy -force ${project}.runs/impl_1/${project}_wrapper.sysdef ${project}.sdk/${hw_name}.hdf
puts "\n#\n#\n# Create hardware definition project ...\n#\n#\n"
sdk createhw -name ${hw_name} -hwspec ${project}.sdk/${hw_name}.hdf

# Generate BSP
puts "\n#\n#\n# Creating ${bsp_name} ...\n#\n#\n"
sdk createbsp -name ${bsp_name} -proc psu_cortexa53_0 -hwproject ${hw_name} -os standalone
sdk projects -build -type bsp -name ${bsp_name}

# Create Zynq MP FSBL application
puts "\n#\n#\n# Creating zynqmp_fsbl ...\n#\n#\n"
sdk createapp -name zynqmp_fsbl_app -hwproject ${hw_name} -proc psu_cortexa53_0 -os standalone -lang C -app {Zynq MP FSBL} -bsp zynqmp_fsbl_bsp

# Set the build type to release
configapp -app zynqmp_fsbl_app build-config release

# Build FSBL application
puts "\n#\n#\n Building zynqmp_fsbl ...\n#\n#\n"
sdk projects -build -type bsp -name zynqmp_fsbl_bsp
sdk projects -build -type app -name zynqmp_fsbl_app

# done
exit
