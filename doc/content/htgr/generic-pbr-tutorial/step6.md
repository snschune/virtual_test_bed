## Step 6

We build upon for the previous step, by adding the upper/bottom plenum and the riser. The mesh will expand and new numbers represent the new blocks added to the reactor.  The inlet boundary has changed from the top of the cavity to the bottom of the riser and the outlet changed from the bottom of the bottom reflector to the right side of the bottom plenum.

So far, the fluid flow starts from the inlet up into the riser, then across the upper plenum and cavity. Next, the flow goes into the bed followed by the bottom reflector and bottom plenum. Finally, the flow will go through the outlet.

The porsities of the upper plenum, bottom plenum and riser are 0.4, 0.4 and 0.6. These blocks have porosity due to these blocks having components inside them in actual reactors.

## Input

Not much will change in terms of putting in new inputs. The only need to put the three blocks in their respected inputs that were already created in previous steps. Assume the material of the plenums and riser is graphite.


## Executable

!listing
./pronghorn-opt -i step6.i

## Results

!media generic-pbr-tutorial/MeshP6.png
        style=width:30%
        id=step6mesh
        caption= Mesh for Step 6.

!media generic-pbr-tutorial/T_fluidP6.png
        style=width:30%
        id=step6T_fluid
        caption= Tempurature of the fluid for Step 6.

!media generic-pbr-tutorial/T_solidP6.png
        style=width:30%
        id=step6T_solid
        caption= Tempurature of the solid for Step 6.
        
!media generic-pbr-tutorial/PressureP6.png
        style=width:30%
        id=step6Pressure
        caption= Pressure of the system for Step 6.

!media generic-pbr-tutorial/VelocityP6.png
        style=width:30%
        id=step6Velocity
        caption= Velocity of the system for Step 6.
