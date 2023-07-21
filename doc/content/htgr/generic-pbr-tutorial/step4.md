## Step 4

In this step, heat was added wihtin the pebble bed reactor.
The heat source comes from the interaction between the fuel or "pebbles" and the He fluid only in the pebble bed block. The He fluid heats up through conviction from the pebbles.

### Added Inputs
First we added [Function] - type = ParsedFunction. The expression allows a heat source function to be made. The functions in place describes the pebble bed to be operational at 200 MW. The function as follow:

expression = [(1.001150322)*(-386.03*(y-2.40538)^5 - 921.11*(y-2.40538)^4 + 70874*(y-2.40538)^3 - 270123*(y-2.40538)^2 + 803073*(y-2.40538) + 389259)]

The heat source is blocked resticted to just the pebble bed block due to heat being generate only in that block.

Next, the intial tempurature of the reactor of 300 was stated by using [Variable]. The inital temperature is blocked restricted to only blocks with solids or known as T_solid. ex. Reflectors and Pebble Bed. Cavity is the only region in which initial temperature isn't applied due to being empty space or gas is consitently moving through it.

[FVKernals] were added to create energy storage (cp and rho) and energy diffusion core (Introduces the diffusivity coefficient of Alpha) in the T_solid. Force (applies the heat source function in the pebble bed region) and the convection of the pebble bed fluid was also added (applies convection between the fluid and solid coexist in certain regions)

Convection through heat transfer was added to the [NavierStokesFV] under [Modules] in forms of:

ambient_convection_blocks = <--------- Applies to all regions with flow besides cavity

ambient_convection_alpha = <---------- Alpha (Diffusivity Coefficient)

ambient_temperature = <--------------- Initial Temperature of T_Solid (300)

Properties of the solid material are address under [Materials], We added drag and porosity under [Material] in step 2 previously to create Friction factor. Now using type = ADGenericVectorFunctorMaterial (Effective Thermal Conductivity) and ADGenericFunctorMaterial to create material properties (rho, cp, and alpha). Note: Most of the system is made up of graphite material. Only the last step is there 2 different materials added.

With these added, In [Postprocessor], we were able to add the inlet and outlet enthalpy and the heat source to calculate.

## Results
