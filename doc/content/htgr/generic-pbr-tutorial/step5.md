## Step 5

Step 5, a pair of reflectors were to be added. The bottom reflector and the side reflector. The reflectors differ in terms of porosity. The side reflector has a porosity of 0 (No Flow) and the bottom reflector has a porosity of 0.4 (has flow going through it). These two reflectors are made up of graphite (`Material` section).

## Input

A change of `Mesh` input was used to easily understand the mesh's build and design, but also it's translation to paraview. This mesh change will be used throughout the rest of the tutorial. 

The mesh is drawn up by the inputs of dy and dx. The dx and dy creates little segments that total up to the dimension of the reactor in their respected axis. This creates subdomains that need to be assigned to a blocks. `Subdomain_id` allows for the subdomains to be assigned to a number. The number represents a block the subdomain is being assigned to. For example, number 1 in the subdomain_id represents the pebble bed, while 2 represents the cavity. This will go on until we have no need for more blocks. Note: The `subdomain_id` is inversed vertically. The top is on the bottom of the `subdomain_id`.

Since adding the bottom reflector and side reflector, the heat function or `heat_source_fn` considers the reflectors as generating heat. As the pebble bed is only block in which heat is beng generated. A block was used in the `force` under `FVKernal` to restrict the heat function to only the pebble bed block.

Under `Material`, the reflectors are made up of grpahite. `ADGenericFunctorMaterial` is used to implement the materials property of rho and cp.

## Executable

!listing
./pronghorn-opt -i step5.i

## Results


!media generic-pbr-tutorial/MeshP5.png
    style=width:30%
    id=step5mesh
    caption= Mesh for Step 5.

!media generic-pbr-tutorial/T_fluidP5.png
    style=width:30%
    id=step5T_fluid
    caption= Tempurature of the fluid for Step 5.

!media generic-pbr-tutorial/T_solidP5.png
    style=width:30%
    id=step5T_solid
    caption= Tempurature of the solid for Step 5.
        
!media generic-pbr-tutorial/PressureP5.png
    style=width:30%
    id=step5Pressure
    caption= Pressure of the system for Step 5.

!media generic-pbr-tutorial/VelocityP5.png
    style=width:30%
    id=step5Velocity
    caption= Velocity of the system for Step 5.
 