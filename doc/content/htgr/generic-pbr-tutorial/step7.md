## Step 7

The last few steps have been expanding the reactor system. In step 7, some of the side reflector between the riser and pebble bed is going to be replaced by a block known as control rod. In the mesh, some of the numbers that represents the side reflector is replaced by numbers representing the new block of control rods. 

The control rod block is where the control rods are inserted in the actual reactor. The block creates a narrow bypass for the fluid flow to go between the upper plenum to the bottom plenum. The fluid flow through the narrow bypass helps keeps the control rods cool during operation. In this step, the control rods aren't inserted, so no heat is being generated in the control rod bypass block. 

## Inputs

Adding the control rod bypass created a problem with the simulation. The simulation would would oscillate failure to converge to succeeding in converging. To fix this issue, an initial condition `IC` was setup for the `superficial_vel_x` and `superficial_vel_y` for each individaul block. This would help flow be better established at time 0.

To find what values to input in each of the blocks initial `superficial_vel_x` and `superficial_vel_y`. A simulation was ran without bernoulli. Bernoulli can be commented under the `NavierStokesFV`. The `superficial_vel_x` and `superficial_vel_y` values can be found in paraview. The values found without berounlli for each individaul block was used for the initial condition value. Bernoulli was used again and the simulaton was able to run without any issues.

In `Materials` control rod has a porsity of 0.32 and is under the material graphite. Most important is the difference in the drag coefficient. The difference in the drag coefficient also allows the system to be able to run without error.



## Executable

!listing
./pronghorn-opt -i step7.i

## Results

!media generic-pbr-tutorial/MeshP7.png
        style=width:30%
        id=step7mesh
        caption= Mesh for Step 7.

!media generic-pbr-tutorial/T_fluidP7.png
        style=width:30%
        id=step7T_fluid
        caption= Tempurature of the fluid for Step 7.

!media generic-pbr-tutorial/T_solidP7.png
        style=width:30%
        id=step7T_solid
        caption= Tempurature of the solid for Step 7.
        
!media generic-pbr-tutorial/PressureP7.png
        style=width:30%
        id=step7Pressure
        caption= Pressure of the system for Step 7.

!media generic-pbr-tutorial/VelocityP7.png
        style=width:30%
        id=step7Velocity
        caption= Velocity of the system for Step 7.