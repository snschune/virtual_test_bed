## Step 8

The final step is adding the outer parts of the reactor. This would include carbon bricks, He gaps, core barrel and the reactor pressure vessel (rpv). Each again has their own respected number representative. There are 2 different He gaps, one between the carbon bricks and the core barrel and the other being between the core barrel and the rpv. 

Carbon Bricks are similiar to that of reflectors, but are replacable. The 2 He gaps were made to insulate heat within the reactor. There's no flow in these gaps, assume the gaps are solid. The core barrel and the reactor pressure vessel (rpv) is structural steel. Both are made up of 2 different steels. 

## Inputs

The new blocks are placed into their respected inputs that were already made from previous steps. The only new inputs that are made in this step are under `Material`. The properties for the 2 different steels and the helium gaps inputs were too be made.

## Executable

!listing
./pronghorn-opt -i step8.i

## Result

!media generic-pbr-tutorial/MeshP8.png
        style=width:30%
        id=step8mesh
        caption= Mesh for Step 8.

!media generic-pbr-tutorial/T_fluidP8.png
        style=width:30%
        id=step8T_fluid
        caption= Tempurature of the fluid for Step 8.

!media generic-pbr-tutorial/T_solidP8.png
        style=width:30%
        id=step8T_solid
        caption= Tempurature of the solid for Step 8.
        
!media generic-pbr-tutorial/PressureP8.png
        style=width:30%
        id=step8Pressure
        caption= Pressure of the system for Step 8.

!media generic-pbr-tutorial/VelocityP8.png
        style=width:30%
        id=step8Velocity
        caption= Velocity of the system for Step 8.