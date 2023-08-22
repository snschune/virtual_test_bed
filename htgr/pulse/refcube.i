[Debug]
  #  show_actions = true          #True prints out actions
  #  show_material_props = true   #True prints material properties
  #  show_parser = true
  #  show_top_residuals = 3        #Number to print
  #  check_boundary_coverage = true
  #  print_block_volume = true
  #  show_neutronics_material_coverage = true
  #  show_petsc_options = true
  show_var_residual_norms = true
[]
[Mesh]
  # Simple Reflected Cube Reactor
  # Start at zero, half core length reflector thickness; 1/8th symmetric
  # Element size: reflector 5.08 cm and core 4.827616834 cm
  # 14 in half-core, 12 in reflector
  dim = 3
  dx = '67.58663568 60.96'
  dy = '67.58663568 60.96'
  dz = '67.58663568 60.96'
  ix = '14 12'
  iy = '14 12'
  iz = '14 12'
  type = CartesianMesh
  uniform_refine = 0
[]
[MeshModifiers]
  [./set_core_id]
    block_id =  10 
    bottom_left = '0.0 0.0 0.0'
    top_right = '67.58663568 67.58663568 67.58663568'
    type = SubdomainBoundingBox
  [../]
[]
[MultiApps]
  [./initial_solve]
    app_type = MammothApp
    execute_on = initial
    input_files = 'init_refcube.i'
    positions = '0 0 0'
    type = FullSolveMultiApp
  [../]
  [./init_adj]
    app_type = MammothApp
    execute_on = initial
    input_files = 'adj_refcube.i'
    positions = '0 0 0'
    type = FullSolveMultiApp
  [../]
  [./micro]
    app_type = MammothApp
    execute_on = timestep_end
    input_files = 'ht_20r_leu_fl.i'
    max_procs_per_app = 1
    positions_file = 'refcube_sub_micro.txt'
    type = TransientMultiApp
  [../]
[]
[Transfers]
  #Below are communication for adjoint IQS for PKE
  #Below are communication for Multiscale with micro-subs
  [./copy_flux]
    direction = from_multiapp
    execute_on = initial
    from_transport_system = diffing
    multi_app = initial_solve
    scale_with_keff = false
    to_transport_system = diffing
    type = TransportSystemVariableTransfer
  [../]
  [./copy_pp]
    # Scales everything to the initial power.
    direction = from_multiapp
    execute_on = initial
    from_postprocessor = UnscaledTotalPower
    multi_app = initial_solve
    reduction_type = maximum
    to_postprocessor = UnscaledTotalPower
    type = MultiAppPostprocessorTransfer
  [../]
  [./copy_sf]
    # Scales factor
    direction = from_multiapp
    execute_on = initial
    from_postprocessor = PowerScaling
    multi_app = initial_solve
    reduction_type = maximum
    to_postprocessor = PowerScaling
    type = MultiAppPostprocessorTransfer
  [../]
  [./copy_adjoint_vars]
    direction = from_multiapp
    execute_on = initial
    from_variables = 'sflux_g0 sflux_g1 sflux_g2 sflux_g3 sflux_g4 sflux_g5'
    multi_app = init_adj
    to_variables = 'adjoint_flux_g0 adjoint_flux_g1 adjoint_flux_g2 adjoint_flux_g3 adjoint_flux_g4 adjoint_flux_g5'
    type = MultiAppVariableTransfer
  [../]
  [./powden_down]
    direction = to_multiapp
    multi_app = micro
    postprocessor = local_power_density
    source_variable = PowerDensity
    type = MultiAppVariableValueSamplePostprocessorTransfer
  [../]
  [./modtemp_up]
    direction = from_multiapp
    multi_app = micro
    num_points = 6
    postprocessor = avg_graphtemp
    power = 2
    type = MultiAppPostprocessorInterpolationTransfer
    variable = temp_ms
  [../]
  [./graintemp_up]
    direction = from_multiapp
    multi_app = micro
    num_points = 6
    postprocessor = avg_graintemp
    power = 2
    type = MultiAppPostprocessorInterpolationTransfer
    variable = temp_fg
  [../]
[]
[TransportSystems]
  # In 3D, back = 0, bottom = 1, right = 2, top = 3, left = 4, front = 5
  # back is -z, bottom is -y, right is +x
  #Boundary Conditions#
  G =  6     
  ReflectingBoundary = '0 1 4'
  VacuumBoundary = '2 3 5'
  equation_type = transient
  for_adjoint = false
  particle = neutron
  [./diffing]
    family = LAGRANGE
    fission_source_as_material = true
    n_delay_groups =  6  
    order = FIRST
    scheme = CFEM-Diffusion
  [../]
[]
[Variables]
  [./temperature]
    family = LAGRANGE
    initial_condition =  300.0 
    order = FIRST
    scaling = 1e-8
  [../]
[]
[Kernels]
  [./HeatConduction]
    type = HeatConduction
    variable = temperature
  [../]
  [./HeatStorage]
    type = HeatCapacityConductionTimeDerivative
    variable = temperature
  [../]
  [./HeatSource]
    block = 10
    type = CoupledForce
    v = PowerDensity
    variable = temperature
  [../]
[]
[Functions]
  [./boron_state]
    type = PiecewiseLinear
    x = '0.0 0.005 30'
    y = '1.89489259748 2.0 2.0'
  [../]
[]
[AuxVariables]
  [./Boron_Conc]
    family = MONOMIAL
    initial_condition = 1.89489259748
    order = CONSTANT
  [../]
  [./PowerDensity]
    block = '10'
    family = MONOMIAL
    order = CONSTANT
  [../]
  [./IntegralPower]
    block = 10
    family = MONOMIAL
    initial_condition = 0.0
    order = CONSTANT
  [../]
  [./avg_coretemp]
    block = 0
    family = LAGRANGE
    initial_condition =  300.0 
    order = FIRST
  [../]
  [./temp_fg]
    #Fuel Grain
    block = 10
    family = LAGRANGE
    initial_condition =  300.0 
    order = FIRST
  [../]
  [./temp_ms]
    #Moderator Shell
    block = 10
    family = LAGRANGE
    initial_condition =  300.0 
    order = FIRST
  [../]
[]
[AuxKernels]
  [./pulse_boron]
    execute_on = timestep_end
    function = boron_state
    type = FunctionAux
    variable = Boron_Conc
  [../]
  [./PowerDensityCalc]
    block = '10'
    cross_section = kappa_sigma_fission
    dummies = UnscaledTotalPower
    execute_on = 'initial linear'
    scalar_flux =  'sflux_g0 sflux_g1 sflux_g2 sflux_g3 sflux_g4 sflux_g5' 
    scale_factor = PowerScaling
    type = VectorReactionRate
    variable = PowerDensity
  [../]
  [./Powerintegrator]
    block = 10
    execute_on = timestep_end
    type = VariableTimeIntegrationAux
    variable =  IntegralPower 
    variable_to_integrate = PowerDensity
  [../]
  [./Set_coreT]
    block = 0
    execute_on = 'linear timestep_end'
    postproc_value = avg_coretemp
    type = SetAuxByPostprocessor
    variable = avg_coretemp
  [../]
[]
[Postprocessors]
  [./UnscaledTotalPower]
    outputs = none
    type = Receiver
  [../]
  [./PowerScaling]
    outputs = none
    type = Receiver
  [../]
  [./avg_coretemp]
    block = 10
    execute_on = linear
    outputs = all
    type = ElementAverageValue
    variable = temp_ms
  [../]
  [./avg_refltemp]
    block = 0
    execute_on = linear
    outputs = all
    type = ElementAverageValue
    variable = temperature
  [../]
  [./max_tempms]
    block = '10'
    outputs = all
    type = ElementExtremeValue
    value_type = max
    variable = temp_ms
  [../]
  [./max_tempfg]
    block = '10'
    outputs = all
    type = ElementExtremeValue
    value_type = max
    variable = temp_fg
  [../]
  [./avg_ms_temp]
    block = 10
    outputs = all
    type = ElementAverageValue
    variable = temp_ms
  [../]
  [./avg_fg_temp]
    block = 10
    outputs = all
    type = ElementAverageValue
    variable = temp_fg
  [../]
  [./avg_powerden]
    block = 10
    execute_on = timestep_end
    outputs = all
    type = ElementAverageValue
    variable = PowerDensity
  [../]
  [./peak_avgPD]
    execute_on = timestep_end
    postprocessor = avg_powerden
    type = TimeExtremeValue
    value_type = max
  [../]
  [./powden_ratio]
    denominator = peak_avgPD
    execute_on = timestep_end
    numerator = avg_powerden
    type = PostprocessorRatio
  [../]
  [./der1_avgPD]
    block = 10
    execute_on = timestep_end
    type = ElementAverageTimeDerivative
    variable = PowerDensity
  [../]
  [./peak_der1avgPD]
    execute_on = timestep_end
    postprocessor = der1_avgPD
    type = TimeExtremeValue
    value_type = max
  [../]
  [./der1PD_ratio]
    denominator = peak_der1avgPD
    execute_on = timestep_end
    numerator = der1_avgPD
    type = PostprocessorRatio
  [../]
  [./ScaledTotalPower]
    block = 10
    execute_on = linear
    type = ElementIntegralVariablePostprocessor
    variable = PowerDensity
  [../]
  [./IntegratedPower]
    block = 10
    execute_on = timestep_end
    type = ElementIntegralVariablePostprocessor
    variable = IntegralPower
  [../]
  [./delta_time]
    type = TimestepSize
  [../]
  [./nl_steps]
    type = NumNonlinearIterations
  [../]
  [./lin_steps]
    type = NumLinearIterations
  [../]
  [./Eq_TREAT_Power]
    scaling_factor =  2469860.77609 
    type = ScalePostprocessor
    value = avg_powerden
  [../]
[]
[UserObjects]
  [./der_pulse_end]
    execute_on = timestep_end
    expression = '(powden_ratio < 0.25) & (abs(der1PD_ratio) < 0.04)'
    type = Terminator
  [../]
[]
[Materials]
  # Mixture Properties
  # Reflector
  [./neut_mix]
    block = 10
    densities =  '0.998448391539 0.00155160846058' 
    grid_names = 'Tfuel Tmod Rod'
    grid_variables = 'temp_fg temp_ms Boron_Conc'
    isotopes =  'pseudo1 pseudo2' 
    library_file = 'leu_20r_is_6g_d.xml'
    library_name = leu_20r_is_6g_d
    material_id = 1
    plus = true
    type = CoupledFeedbackNeutronicsMaterial
  [../]
  [./kth]
    # Volume weighted harmonic mean
    # Divided fg_kth by 100 to get it into cm
    args =  'temp_fg' 
    block = 10
    constant_expressions =  '3.35103216383e-08 1.31125888571e-07 2.14325144175e-05 0.3014 0.01046 1.0 0.05 1.5 1.0' 
    constant_names = 'vol_fg vol_fl vol_gr gr_kth fl_kth beta p_vol sigma kap3x'
    f_name =  'thermal_conductivity' 
    function =  'lt := temp_fg / 1000.0; fresh := (100.0 / (6.548 + 23.533 * lt) + 6400.0 * exp(-16.35 / lt) / pow(lt, 5.0/2.0)) / 100.0; kap1d := (1.09 / pow(beta, 3.265) + 0.0643 * sqrt(temp_fg) / sqrt(beta)) * atan(1.0 / (1.09 / pow(beta, 3.265) + sqrt(temp_fg) * 0.0643 / sqrt(beta))); kap1p := 1.0 + 0.019 * beta / ((3.0 - 0.019 * beta) * (1.0 + exp(-(temp_fg - 1200.0) / 100.0))); kap2p := (1.0 - p_vol) / (1.0 + (sigma - 1.0) * p_vol); kap4r := 1.0 - 0.2 / (1.0 + exp((temp_fg - 900.0) / 80.0)); fg_kth := fresh * kap1d * kap1p * kap2p * kap3x * kap4r; (vol_fg + vol_fl + vol_gr) / (vol_fg / fg_kth + vol_fl / fl_kth + vol_gr / gr_kth)' 
    type = ParsedMaterial
  [../]
  [./rho_cp]
    # Volume weighted arithmetic mean (Irradiation has no effect)
    args =  'temp_fg temp_ms' 
    block = 10
    constant_expressions =  '3.35103216383e-08 2.1563640306e-05 0.0018 0.010963' 
    constant_names =  'vol_fg vol_gr rho_gr rho_fg' 
    f_name =  'heat_capacity' 
    function = 'lt := temp_fg / 1000.0; gr_rhocp := rho_gr / (11.07 * pow(temp_ms, -1.644) + 0.0003688 * pow(temp_ms, 0.02191)); fink_cp := 52.1743 + 87.951 * lt - 84.2411 * pow(lt, 2) + 31.542 * pow(lt, 3) - 2.6334 * pow(lt, 4) - 0.71391 * pow(lt, -2); fg_rhocp := rho_fg * fink_cp / 267.2 * 1000.0; (vol_fg * fg_rhocp + vol_gr * gr_rhocp) / (vol_fg + vol_gr)'
    type = ParsedMaterial
  [../]
  [./neut_refl]
    block = 0
    densities = '1'
    grid_names = 'Trefl Tcore Rod'
    grid_variables = 'temperature avg_coretemp Boron_Conc'
    isotopes = 'pseudo'
    library_file = 'leu_macro_6g.xml'
    library_name = leu_macro_6g
    material_id = 2
    plus = true
    type = CoupledFeedbackNeutronicsMaterial
  [../]
  [./ref_kth]
    block = 0
    prop_names = 'thermal_conductivity'
    prop_values =  '0.3014' 
    type = GenericConstantMaterial
  [../]
  [./ref_rho_cp]
    args =  'temperature' 
    block = '0'
    constant_expressions =  '0.0018' 
    constant_names = 'rho_gr'
    f_name =  'heat_capacity' 
    function =  'rho_gr / (11.07 * pow(temperature, -1.644) + 0.0003688 * pow(temperature, 0.02191))' 
    type = ParsedMaterial
  [../]
[]
[Preconditioning]
  [./SMP_full]
    #petsc_options = '-snes_ksp_ew -snes_converged_reason -ksp_monitor_true_residual'
    full = true
    petsc_options = '-snes_ksp_ew -snes_converged_reason'
    petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -pc_hypre_boomeramg_max_iter -pc_hypre_boomeramg_tol'
    petsc_options_value = 'hypre boomeramg 101 20 1.0e-6'
    solve_type = 'PJFNK'
    type = SMP
  [../]
[]
[Executioner]
  #Kind of ominous, eh?
  # Captian Picard
  do_iqs_transient = false
  dtmin = 1e-7
  end_time =  10.0 
  l_max_its = 100
  l_tol = 1e-3
  nl_abs_tol = 1e-7
  nl_max_its = 200
  nl_rel_tol = 1e-7
  picard_abs_tol = 1e-7
  picard_max_its = 10
  picard_rel_tol = 1e-7
  pke_param_csv = '20r_pke.csv'
  start_time = 0.0
  type = IQS
  [./TimeStepper]
    dt = 0.005
    growth_factor = 1.5
    type = ConstantDT
  [../]
[]
[Outputs]
  csv = true
  file_base = out~refcube
  interval = 1
  [./console]
    output_linear = true
    output_nonlinear = true
    type = Console
  [../]
  [./exodus]
    type = Exodus
  [../]
[]
