# Step-by-Step Tutorial for a Generic Pebble Bed HTGR Model in Pronghorn

## Setting up your environment

Navigate to the right virtual test bed directory

!listing
cd /path/to/VTB/htgr/generic-pbr-tutorial

and create a link to your pronghorn executable:

!listing
ln -s /path/to/projects/pronghorn/pronghorn-opt

As an INL hpc user you may load the Pronghorn module and then
execute all commands in this tutorial except for swapping

!listing
./pronghorn-opt -> pronghorn-opt

[Step 1: An axisymmetric flow channel with porosity](generic-pbr-tutorial/step1.md)

[Step 2: Adding pressure drop](generic-pbr-tutorial/step2.md)

[Step 3: Adding a cavity above the bed](generic-pbr-tutorial/step3.md)
