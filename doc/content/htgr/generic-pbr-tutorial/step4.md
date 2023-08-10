## Step 4

In this step, heat was added wihtin the pebble bed reactor.

The heat source comes from the interaction between the fuel or "pebbles" and the He fluid only in the pebble bed block. The He fluid heats up through conviction from the pebbles.

## Added Inputs

First we added `Function` - type = `ParsedFunction`. The expression allows a heat source function to be made. The functions in place describes the pebble bed to be operational at 200 MW. The function as follow:

expression = `(1.001150322)*(-386.03*(y-2.40538)^5 - 921.11*(y-2.40538)^4 + 70874*(y-2.40538)^3 - 270123*(y-2.40538)^2 + 803073*(y-2.40538) + 389259)`

The heat source is blocked resticted to just the pebble bed block due to heat being generate only in that block. The heat should create a power of 200 MW in the pebble bed block. Note: the expression or total power will not initially equal 200 MW of heat energy. This is do being dependent on the y variable. In later steps, the expression or total power will come to equal 200 MW.

Next, the intial tempurature of the reactor of 300 was stated by using `Variable`. The inital temperature is blocked restricted to only blocks with solids or known as `T_solid`. ex. Reflectors and Pebble Bed. Cavity is the only block in which initial temperature isn't applied due to being empty space or gas is consitently moving through it.

`FVKernals` were added to create energy storage (cp and rho) and energy diffusion core (Introduces the diffusivity coefficient of Alpha) in the `T_solid`. `Heat` (applies the heat source function in the pebble bed blocks) and the convection of the pebble bed fluid was also added (applies convection between the fluid and solid coexist in certain blocks)

Convection through heat transfer was added to the `NavierStokesFV` under `Modules` in forms of:

ambient_convection_blocks = <--------- Applies to all regions with flow besides cavity

ambient_convection_alpha = <---------- Alpha (Diffusivity Coefficient)

ambient_temperature = <--------------- Initial Temperature of T_Solid (300)

Properties of the solid material are address under [Materials], We added drag and porosity under [Material] in step 2 previously to create Friction factor. Now using type = ADGenericVectorFunctorMaterial (Effective Thermal Conductivity) and ADGenericFunctorMaterial to create material properties (rho, cp, and alpha). Note: Most of the system is made up of graphite material. Only the last step is there 2 different materials added.

With these added, In [Postprocessor], we were able to add the inlet and outlet enthalpy and the heat source to calculate.

## Results

Properties of the solid material are address under `Materials`, We added drag and porosity under `Material` in step 2 previously to create friction factor. Now using type = `ADGenericVectorFunctorMaterial` (Effective Thermal Conductivity) and `ADGenericFunctorMaterial` to create material properties (rho, cp, and alpha). Note: Most of the system is made up of graphite material. Only the last step is there 2 different materials added.

With these added, In `Postprocessor`, we were able to add the inlet and outlet enthalpy and the heat source/total power to calculate.

## Executable

!listing
./pronghorn-opt -i step4.i

## Results

!media generic-pbr-tutorial/MeshP4.png
        style=width:30%
        id=step4mesh
        caption= Mesh for Step 4.

!media generic-pbr-tutorial/T_fluidP4.png
        style=width:30%
        id=step4T_fluid
        caption= Tempurature of the fluid for Step 4.

!media generic-pbr-tutorial/T_solidP4.png
        style=width:30%
        id=step4T_solid
        caption= Tempurature of the solid for Step 4.
        
!media generic-pbr-tutorial/PressureP4.png
        style=width:30%
        id=step4Pressure
        caption= Pressure of the system for Step 4.

!media generic-pbr-tutorial/VelocityP4.png
        style=width:30%
        id=step4Velocity
        caption= Velocity of the system for Step 4.

