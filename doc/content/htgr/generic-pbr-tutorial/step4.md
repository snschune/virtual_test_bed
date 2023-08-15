## Step 4

In this step, a heat source representing fission is added in the pebble-bed region.
Neutrons cause fission in the fuel kernels dispersed in the pebbles. The pebbles conduct the heat to the outside of the pebble where it is
transferred to the helium coolant via convection.

## Added Inputs

In this step, a heat equation for the solid temperature is added. This is done by first adding
solid temperature variable that is block-restricted to the pebble-bed:

!listing htgr/generic-pbr-tutorial/step4.i block=T_solid

The initial temperature is set to the inlet temperature `${T_inlet}` which is $300$ K.
The solid heat conduction equation contains four terms: time derivative, heat conduction, source, and
convective cooling by the helium. These terms are added using the `FVKernels` block:

!listing htgr/generic-pbr-tutorial/step4.i block=FVKernels

`energy_storage` is the time derivative term that uses two material properties, namely the solid
density `rho` and the solid specific heat `cp`. `solid_energy_diffusion` represents heat conduction
and uses the thermal conductivity property provided under `kappa`. `source` provides the heat source
and is discussed later. `convection_pebble_bed_fluid` models convective heat transfer between 
the solid pebbles and the helium coolant. It uses the volumetric heat transfer coefficient `h_solid_fluid`
as property.

In `solid_energy_diffusion` the `effective_diffusivity` parameter should be explained in detail. If set to `true`, then 
`kappa` is interpreted as effective thermal conductivity and used as is. If set to `false`, then the value of `kappa`
is modified by the porosity to take into account reduced thermal conductivity of porous regions.

For `energy_storage`, the values of density, specific heat, and porosity do not matter significantly, because we are
only interested in the steady-state solution of this problem. Therefore, we use the `scaling` parameter to drive the 
pseudo transient to a faster solution. Note, that 

The shape of the heat source is represented as a `ParsedFunction` in the input file.

!listing htgr/generic-pbr-tutorial/step4.i block=heat_source_fn

The `expression` declares the heat source as a function of the y-coordinate that is aligned with the up/down direction in this model. Note, that we omitted the dependence of the heat source on the radial dimension. The prefactor of $1.7411862$ rescales the function to yield a power of 200 MW. 

`heat_source_fn` is used in two places in the Step 4 input file. First, it is used as a source term in the solid conduction equation which has 
been shown above and second a postprocessor is used to integrate the heat source over the pebble-bed block. 

!listing htgr/generic-pbr-tutorial/step4.i block=heat_source_integral

The heat source is blocked resticted to just the pebble bed block due to heat being generate only in that block. The postprocessor named `heat_source_integral`
should return $2 \times 10^8$.

Properties used by the kernels are provided in the [Materials] block as functors. In addition to the functors defined in Step 3, we add the effective bed conductivity,
the solid/fluid volumetric heat transfer coefficient, and the density and specific heat in the bed.

We add postprocessors to compute the inlet enthalpy, outlet enthalpy, and enthalpy difference as well as the total heat source.

!listing htgr/generic-pbr-tutorial/step4.i start=enthalpy_inlet end=Outputs

Note that the `outputs = none` suppresses postprocessors from being printed, but they are nonetheless computed by the system and can be used
in other objects.

## Executable

!listing
./pronghorn-opt -i step4.i

## Results

From the screen output we find that at steady-state, the `enthalpy_balance` matches the `heat_source_integral` indicating that Pronghorn conserves
energy. More results are provided in [step4mesh] to [step4Velocity].

!media generic-pbr-tutorial/MeshP4.png
        style=width:60%
        id=step4mesh
        caption= Mesh for Step 4.

!media generic-pbr-tutorial/T_fluidP4.png
        style=width:60%
        id=step4T_fluid
        caption= Tempurature of the fluid for Step 4.

!media generic-pbr-tutorial/T_solidP4.png
        style=width:60%
        id=step4T_solid
        caption= Tempurature of the solid for Step 4.
        
!media generic-pbr-tutorial/PressureP4.png
        style=width:60%
        id=step4Pressure
        caption= Pressure of the system for Step 4.

!media generic-pbr-tutorial/VelocityP4.png
        style=width:60%
        id=step4Velocity
        caption= Velocity of the system for Step 4.

