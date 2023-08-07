bed_radius = 1.2
outlet_pressure = 5.5e6
T_fluid = 300
density = 8.62
pebble_diameter = 0.06

mass_flow_rate = 60.0
flow_area = ${fparse pi * bed_radius * bed_radius}
flow_vel = ${fparse mass_flow_rate / flow_area / density}
            

[Mesh]
  type = MeshGeneratorMesh
  block_id = '1 2 3 4 5 6 7'
  block_name = 'pebble_bed
                cavity
                bottom_reflector
                side_reflector
                upper_plenum
                bottom_plenum
                riser'
  uniform_refine = 1
 
 [cartesian_mesh]
  type = CartesianMeshGenerator
  dim = 2

  dx = ' 0.20 0.20 0.20 0.20 0.20 0.20       
         0.010 0.055
         0.13
         0.102 0.102 0.102
         0.17
         0.120'

  ix = ' 1 1 1 1 1 1
         1 1
         1
         1 1 1
         2
         1
         '

  dy = ' 0.100 0.100
         0.967
         0.1709 0.1709 0.1709 0.1709 0.1709
         0.4465 0.4465 0.4465 0.4465 0.4465 0.4465 0.4465 0.4465 0.4465 0.4465
         0.4465 0.4465 0.4465 0.4465 0.4465 0.4465 0.4465 0.4465 0.4465 0.4465
         0.458 0.712'

  iy = ' 1 2
         2
         2 2 1 1 1
         4 1 1 1 1 1 1 1 1 1
         1 1 1 1 1 1 1 1 1 4
         4 2'

  subdomain_id =  '4 4 4 4 4 4  4 4  4  4 4 4  4  4
                   4 4 4 4 4 4  4 4  4  4 4 4  4  4
                   6 6 6 6 6 6  6 6  6  4 4 4  7  4
                   3 3 3 3 3 3  4 4  4  4 4 4  7  4
                   3 3 3 3 3 3  4 4  4  4 4 4  7  4
                   3 3 3 3 3 3  4 4  4  4 4 4  7  4
                   3 3 3 3 3 3  4 4  4  4 4 4  7  4
                   3 3 3 3 3 3  4 4  4  4 4 4  7  4
                   1 1 1 1 1 1  4 4  4  4 4 4  7  4
                   1 1 1 1 1 1  4 4  4  4 4 4  7  4
                   1 1 1 1 1 1  4 4  4  4 4 4  7  4
                   1 1 1 1 1 1  4 4  4  4 4 4  7  4
                   1 1 1 1 1 1  4 4  4  4 4 4  7  4
                   1 1 1 1 1 1  4 4  4  4 4 4  7  4
                   1 1 1 1 1 1  4 4  4  4 4 4  7  4
                   1 1 1 1 1 1  4 4  4  4 4 4  7  4
                   1 1 1 1 1 1  4 4  4  4 4 4  7  4
                   1 1 1 1 1 1  4 4  4  4 4 4  7  4
                   1 1 1 1 1 1  4 4  4  4 4 4  7  4
                   1 1 1 1 1 1  4 4  4  4 4 4  7  4
                   1 1 1 1 1 1  4 4  4  4 4 4  7  4
                   1 1 1 1 1 1  4 4  4  4 4 4  7  4
                   1 1 1 1 1 1  4 4  4  4 4 4  7  4
                   1 1 1 1 1 1  4 4  4  4 4 4  7  4
                   1 1 1 1 1 1  4 4  4  4 4 4  7  4
                   1 1 1 1 1 1  4 4  4  4 4 4  7  4
                   1 1 1 1 1 1  4 4  4  4 4 4  7  4
                   1 1 1 1 1 1  4 4  4  4 4 4  7  4
                   2 2 2 2 2 2  5 5  5  5 5 5  7  4
                   4 4 4 4 4 4  4 4  4  4 4 4  4  4'
 []

 [inlet]
  type = SideSetsAroundSubdomainGenerator
  input = cartesian_mesh
  block = 7
  new_boundary = inlet
  normal = '0 -1 0'
 []

[riser_top]
  type = SideSetsAroundSubdomainGenerator
  input = inlet
  block = 7
  new_boundary = riser_top
  normal = '0 1 0'
[]

 [riser_right]
  type = SideSetsAroundSubdomainGenerator
  input = riser_top
  block = 7
  new_boundary = riser_right
  normal = '1 0 0'
 []

 [riser_left]
  type = ParsedGenerateSideset
  input = riser_right
  combinatorial_geometry = 'abs(x-1.701) < 1e-3'
  included_subdomains = 7
  included_neighbors = 4
  new_sideset_name = riser_left
[]

[upper_plenum_top]
  type = SideSetsAroundSubdomainGenerator
  input = riser_left
  block = 5
  new_boundary = upper_plenum_top
  normal = '0 1 0'
[]

[upper_plenum_bottom]
  type = SideSetsAroundSubdomainGenerator
  input = upper_plenum_top
  block = 5
  new_boundary = upper_plenum_bottom
  normal = '0 -1 0'
[]

[cavity_top]
  type = SideSetsAroundSubdomainGenerator
  input = upper_plenum_bottom
  block = 2
  new_boundary = cavity_top
  normal = '0 1 0'
[]

[cavity_left]
  type = SideSetsAroundSubdomainGenerator
  input = cavity_top
  block = 2
  new_boundary = cavity_left
  normal = '-1 0 0'
[]

[bed_left]
  type = SideSetsAroundSubdomainGenerator
  input = cavity_left
  block = 1
  new_boundary = bed_left
  normal = '-1 0 0'
[]

[bed_right]
  type = SideSetsAroundSubdomainGenerator
  input = bed_left
  block = 1
  new_boundary = bed_right
  normal = '1 0 0'
[]

[bottom_reflector_left]
  type = SideSetsAroundSubdomainGenerator
  input = bed_right
  block = 3
  new_boundary = bottom_reflector_left
  normal = '-1 0 0'
[]

[bottom_reflector_right]
  type = SideSetsAroundSubdomainGenerator
  input = bottom_reflector_left
  block = 3
  new_boundary = bottom_reflector_right
  normal = '1 0 0'
[]

[bottom_plenum_left]
  type = SideSetsAroundSubdomainGenerator
  input = bottom_reflector_right
  block = 6
  new_boundary = bottom_plenum_left
  normal = '-1 0 0'
[]

[bottom_plenum_bottom]
  type = SideSetsAroundSubdomainGenerator
  input = bottom_plenum_left
  block = 6
  new_boundary = bottom_plenum_bottom
  normal = '0 -1 0'
[]

[bottom_plenum_top]
 type = ParsedGenerateSideset
 input = bottom_plenum_bottom
 combinatorial_geometry = 'abs(y-1.167) < 1e-3'
 included_subdomains = 6
 included_neighbors = 4
 new_sideset_name = bottom_plenum_top
[]

 [outlet]
  type = SideSetsAroundSubdomainGenerator
  input = bottom_plenum_top
  block = 6
  new_boundary = outlet
  normal = '1 0 0'
 []

 [rename_boundaries]
  type = RenameBoundaryGenerator
  input = outlet
  old_boundary = 'riser_right riser_top upper_plenum_top cavity_top cavity_left bed_left bottom_reflector_left bottom_plenum_left bottom_plenum_bottom riser_left upper_plenum_bottom bed_right bottom_reflector_right bottom_plenum_top'
  new_boundary = 'ex ex ex ex ex ex ex ex ex in in in in in'
 []

 coord_type = RZ

[]

[FluidProperties]

  [fluid_properties_obj]
    type = HeliumFluidProperties
  []

[]

[Functions]

  [heat_source_fn]
    type = ParsedFunction
    expression = '(1.17611637)*(-386.03*(y-2.40538)^5 - 921.11*(y-2.40538)^4 + 70874*(y-2.40538)^3 - 270123*(y-2.40538)^2 + 803073*(y-2.40538) + 389259)'
  []

[]

[Variables]
    [T_solid]
      type = INSFVEnergyVariable
      initial_condition = 300
        block = 'pebble_bed
                 bottom_reflector
                 side_reflector
                 riser
                 upper_plenum
                 bottom_plenum'
    []
[]

[FVKernels]
  [energy_storage]
    type = PINSFVEnergyTimeDerivative
    variable = T_solid
    rho = 2000
    cp = 300
    is_solid = true
    scaling = 1
    porosity = 0
  []

  [solid_energy_diffusion_core]
    type = PINSFVEnergyAnisotropicDiffusion
    variable = T_solid
    kappa = 'effective_thermal_conductivity'
    effective_diffusivity = true
    porosity = 1
  []

  [heating]
    type = FVBodyForce
    variable = T_solid
    function = heat_source_fn
    block = 'pebble_bed'
  []

  [convection_pebble_bed_fluid]
    type = PINSFVEnergyAmbientConvection
    variable = T_solid
    T_fluid = T_fluid
    T_solid = T_solid
    is_solid = true
    h_solid_fluid = 'alpha'
    block = 'pebble_bed bottom_reflector'
  []
[]

[Modules]
  [NavierStokesFV]
    compressibility = 'weakly-compressible'
    porous_medium_treatment = true
    density = rho
    dynamic_viscosity = mu
    porosity = porosity
    porosity_interface_pressure_treatment = 'bernoulli'
    initial_velocity = '0 0 0'
    initial_pressure = 5.4e6
    inlet_boundaries = inlet
    momentum_inlet_types = fixed-velocity
    momentum_inlet_function = '0 ${flow_vel}'
    wall_boundaries = 'ex in'
    momentum_wall_types = 'slip slip'
    outlet_boundaries = outlet
    momentum_outlet_types = fixed-pressure
    pressure_function = ${outlet_pressure}
    friction_types = 'darcy forchheimer'
    friction_coeffs = 'Darcy_coefficient Forchheimer_coefficient'
    add_energy_equation = true
    energy_inlet_types = fixed-temperature
    energy_inlet_function = '300'
    energy_wall_types = 'heatflux heatflux'
    energy_wall_function = '0 0'
    ambient_convection_blocks = 'pebble_bed bottom_reflector'
    ambient_convection_alpha = 'alpha'
    ambient_temperature = 'T_solid'
    block = 'pebble_bed cavity bottom_reflector upper_plenum bottom_plenum riser'
  []
[]

[Materials]
  [fluid_props_to_mat_props]
    type = GeneralFunctorFluidProps
    fp = fluid_properties_obj
    porosity = porosity
    pressure = pressure
    T_fluid = ${T_fluid}
    speed = speed
    characteristic_length = ${pebble_diameter}
    block = 'pebble_bed
             bottom_reflector
             cavity
             upper_plenum
             bottom_plenum
             riser'
  []

  [graphite_rho_and_cp]
    type = ADGenericFunctorMaterial
    prop_names =  'rho_s  cp_s k_s'
    prop_values = '1780.0 1697 26'
    block = 'pebble_bed 
             side_reflector
             bottom_reflector'
  []

  [drag_pebble_bed]
    type = FunctorKTADragCoefficients
    fp = fluid_properties_obj
    pebble_diameter =  ${pebble_diameter}
    porosity = porosity
    T_fluid = ${T_fluid}
    T_solid = ${T_fluid}
    block = 'pebble_bed'
  []

  [drag_cavity]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'Darcy_coefficient Forchheimer_coefficient'
    prop_values = '0 0 0 0 0 0'
    block = 'cavity side_reflector bottom_reflector bottom_plenum upper_plenum riser'
  []

  [porosity_material]
    type = ADPiecewiseByBlockFunctorMaterial
    prop_name = porosity
    subdomain_to_prop_value = 'pebble_bed       0.39
                               cavity           1
                               bottom_reflector 0.3
                               side_reflector   0
                               riser            0.32
                               upper_plenum     0.2
                               bottom_plenum    0.2'
  []

  [effective_solid_thermal_conductivity_pb]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'effective_thermal_conductivity'
    prop_values = '20 20 20'
    block = 'pebble_bed'
  []

  [effective_solid_thermal_conductivity]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'effective_thermal_conductivity'
    prop_values = '20 20 20'
    block = 'bottom_reflector
             side_reflector
             upper_plenum
             bottom_plenum
             riser'
  []

  [alpha_mat]
  type = ADGenericFunctorMaterial
  prop_names = 'alpha'
  prop_values = '2e4'
  block = 'pebble_bed bottom_reflector'
  []

[]

[Executioner]
  type = Transient
  end_time = 100
  [TimeStepper]
    type = IterationAdaptiveDT
    iteration_window = 2
    optimal_iterations = 8
    cutback_factor = 0.8
    growth_factor = 1.1
    dt = 1e-3
  []
  dtmax = 5
  line_search = l2
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_shift_type'
  petsc_options_value = 'lu NONZERO'
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-5
  nl_max_its = 15
  automatic_scaling = true
[]

[Postprocessors]
  [inlet_mfr]
   type = VolumetricFlowRate
   advected_quantity = rho
   vel_x = 'superficial_vel_x'
   vel_y = 'superficial_vel_y'
   boundary = 'inlet'
   rhie_chow_user_object = pins_rhie_chow_interpolator
[]

 [outlet_mfr]
   type = VolumetricFlowRate
   advected_quantity = rho
   vel_x = 'superficial_vel_x'
   vel_y = 'superficial_vel_y'
   boundary = 'outlet'
   rhie_chow_user_object = pins_rhie_chow_interpolator
 []

 [inlet_pressure]
  type = SideAverageValue
  variable = pressure
  boundary = inlet
  outputs = none
 []

 [outlet_pressure]
  type = SideAverageValue
  variable = pressure
  boundary = outlet
  outputs = none
 []

 [pressure_drop]
  type = ParsedPostprocessor
  pp_names = 'inlet_pressure outlet_pressure'
  function = 'inlet_pressure - outlet_pressure'
 []

 [integral_density]
  type = ADElementIntegralFunctorPostprocessor
  functor = rho
  outputs = none
  block = '1 2 3 5 6 7'
 []

 [average_density]
  type = ParsedPostprocessor
  pp_names = 'volume integral_density'
  function = 'integral_density / volume'
 []

 [integral_mu]
  type = ADElementIntegralFunctorPostprocessor
    functor = mu
    outputs = none
    block = '1 2 3 5 6 7'
  []

  [average_mu]
    type = ParsedPostprocessor
    pp_names = 'volume integral_mu'
   function = 'integral_mu / volume'
  []

  [area]
   type = AreaPostprocessor
   boundary = outlet
   outputs = none
  []

 [volume]
  type = VolumePostprocessor
 []

 [Enthalpy_inlet]
  type = VolumetricFlowRate
   boundary = inlet
   vel_x = superficial_vel_x
   vel_y = superficial_vel_y
   rhie_chow_user_object = 'pins_rhie_chow_interpolator'
   advected_quantity = 'rho_cp_temp'
   advected_interp_method = 'upwind'
  []

  [Enthalpy_outlet]
   type = VolumetricFlowRate
   boundary = outlet
   vel_x = superficial_vel_x
   vel_y = superficial_vel_y
   rhie_chow_user_object = 'pins_rhie_chow_interpolator'
   advected_quantity = 'rho_cp_temp'
   advected_interp_method = 'upwind'
  []

  [total_power]
   type = ElementIntegralFunctorPostprocessor
   functor = heat_source_fn
   block = pebble_bed
  []

[]

[Outputs]
  exodus = true
[]