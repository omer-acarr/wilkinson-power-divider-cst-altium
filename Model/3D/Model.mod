'# MWS Version: Version 2025.0 - Aug 30 2024 - ACIS 34.0.1 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 4 fmax = 5
'# created = '[VERSION]2025.0|34.0.1|20240830[/VERSION]


'@ use template: wilkinson power divider.cfg

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
'set the units
With Units
    .SetUnit "Length", "mm"
    .SetUnit "Frequency", "GHz"
    .SetUnit "Voltage", "V"
    .SetUnit "Resistance", "Ohm"
    .SetUnit "Inductance", "nH"
    .SetUnit "Temperature",  "degC"
    .SetUnit "Time", "ns"
    .SetUnit "Current", "A"
    .SetUnit "Conductance", "S"
    .SetUnit "Capacitance", "pF"
End With

ThermalSolver.AmbientTemperature "0"

'----------------------------------------------------------------------------

'set the frequency range
Solver.FrequencyRange "4", "5"

'----------------------------------------------------------------------------

With Background
     .Type "pec"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With

' set boundary conditions to electric

With Boundary
     .Xmin "electric"
     .Xmax "electric"
     .Ymin "electric"
     .Ymax "electric"
     .Zmin "electric"
     .Zmax "electric"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With

Mesh.MinimumCurvatureRefinement "150"

With MeshSettings
     .SetMeshType "HexTLM"
     .Set "StepsPerWaveNear", "20"
     .Set "StepsPerBoxNear", "10"
     .Set "StepsPerWaveFar", "20"
     .Set "StepsPerBoxFar", "10"
     .Set "RatioLimitGeometry", "15"
End With

'----------------------------------------------------------------------------

Dim sDefineAt As String
sDefineAt = "4;4.5;5"
Dim sDefineAtName As String
sDefineAtName = "4;4.5;5"
Dim sDefineAtToken As String
sDefineAtToken = "f="
Dim aFreq() As String
aFreq = Split(sDefineAt, ";")
Dim aNames() As String
aNames = Split(sDefineAtName, ";")

Dim nIndex As Integer
For nIndex = LBound(aFreq) To UBound(aFreq)

Dim zz_val As String
zz_val = aFreq (nIndex)
Dim zz_name As String
zz_name = sDefineAtToken & aNames (nIndex)

' Define E-Field Monitors
With Monitor
    .Reset
    .Name "e-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Efield"
    .MonitorValue  zz_val
    .Create
End With

' Define H-Field Monitors
With Monitor
    .Reset
    .Name "h-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Hfield"
    .MonitorValue  zz_val
    .Create
End With

' Define Power flow Monitors
With Monitor
    .Reset
    .Name "power ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Powerflow"
    .MonitorValue  zz_val
    .Create
End With

' Define Power loss Monitors
With Monitor
    .Reset
    .Name "loss ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Powerloss"
    .MonitorValue  zz_val
    .Create
End With

' Define Farfield Monitors
With Monitor
    .Reset
    .Name "farfield ("& zz_name &")"
    .Domain "Frequency"
    .FieldType "Farfield"
    .MonitorValue  zz_val
    .ExportFarfieldSource "False"
    .Create
End With

Next

'----------------------------------------------------------------------------

With MeshSettings
     .SetMeshType "Hex"
     .Set "Version", 1%
End With

With Mesh
     .MeshType "PBA"
End With

'set the solver type
ChangeSolverType("HF Time Domain")

'----------------------------------------------------------------------------

'@ define material: Rogers RO4350B (lossy)

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Material
     .Reset
     .Name "Rogers RO4350B (lossy)"
     .Folder ""
     .FrqType "all"
     .Type "Normal"
     .SetMaterialUnit "GHz", "mm"
     .Epsilon "3.66"
     .Mu "1.0"
     .Kappa "0.0"
     .TanD "0.0037"
     .TanDFreq "10.0"
     .TanDGiven "True"
     .TanDModel "ConstTanD"
     .KappaM "0.0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstKappa"
     .DispModelEps "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "General 1st"
     .DispersiveFittingSchemeMu "General 1st"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0.69"
     .SetActiveMaterial "all"
     .Colour "0.94", "0.82", "0.76"
     .Wireframe "False"
     .Transparency "0"
     .Create
End With

'@ new component: component1

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Component.New "component1"

'@ define brick: component1:substrate

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Brick
     .Reset 
     .Name "substrate" 
     .Component "component1" 
     .Material "Rogers RO4350B (lossy)" 
     .Xrange "-width/2", "width/2" 
     .Yrange "-length/2", "length/2" 
     .Zrange "0", "h_sub" 
     .Create
End With

'@ define material: Copper (pure)

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Material
     .Reset
     .Name "Copper (pure)"
     .Folder ""
     .FrqType "all"
     .Type "Lossy metal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .MaterialUnit "Temperature", "Kelvin"
     .Mu "1.0"
     .Sigma "5.96e+007"
     .Rho "8930.0"
     .ThermalType "Normal"
     .ThermalConductivity "401.0"
     .SpecificHeat "390", "J/K/kg"
     .MetabolicRate "0"
     .BloodFlow "0"
     .VoxelConvection "0"
     .MechanicsType "Isotropic"
     .YoungsModulus "120"
     .PoissonsRatio "0.33"
     .ThermalExpansionRate "17"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .FrqType "static"
     .Type "Normal"
     .SetMaterialUnit "Hz", "mm"
     .Epsilon "1"
     .Mu "1.0"
     .Kappa "5.96e+007"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .KappaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .DispModelEps "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .DispersiveFittingSchemeMu "Nth Order"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .Colour "1", "1", "0"
     .Wireframe "False"
     .Reflection "False"
     .Allowoutline "True"
     .Transparentoutline "False"
     .Transparency "0"
     .Create
End With

'@ define brick: component1:copper

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Brick
     .Reset 
     .Name "copper" 
     .Component "component1" 
     .Material "Copper (pure)" 
     .Xrange "-width/2", "width/2" 
     .Yrange "-length/2", "length/2" 
     .Zrange "0", "-h_copper" 
     .Create
End With

'@ pick face

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Pick.PickFaceFromId "component1:substrate", "1"

'@ align wcs with face

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
WCS.AlignWCSWithSelected "Face"

'@ define cylinder: component1:solid1

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Cylinder 
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "Copper (pure)" 
     .OuterRadius "Out_rad" 
     .InnerRadius "In_rad" 
     .Axis "z" 
     .Zrange "0", "h_copper" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ pick end point

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Pick.PickExtraCirclepointFromId "component1:solid1", "4", "4", "2"

'@ align wcs with point

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ rotate wcs

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
WCS.RotateWCS "w", "270.00"

'@ define brick: component1:ram1

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Brick
     .Reset 
     .Name "ram1" 
     .Component "component1" 
     .Material "Copper (pure)" 
     .Xrange "0", "length/2-in_rad" 
     .Yrange "-h_ram1/2", "h_ram1/2" 
     .Zrange "0", "-h_copper" 
     .Create
End With

'@ pick end point

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Pick.PickExtraCirclepointFromId "component1:solid1", "4", "4", "0"

'@ align wcs with point

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ define brick: component1:delete

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Brick
     .Reset 
     .Name "delete" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "5", "-5" 
     .Yrange "-mezera/2", "mezera/2" 
     .Zrange "0", "-h_copper" 
     .Create
End With

'@ boolean subtract shapes: component1:solid1, component1:delete

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Solid.Subtract "component1:solid1", "component1:delete"

'@ pick mid point

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Pick.PickMidpointFromId "component1:solid1", "2"

'@ align wcs with point

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ rotate wcs

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
WCS.RotateWCS "w", "180.00"

'@ rotate wcs

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
WCS.RotateWCS "w", "45.00"

'@ pick end point

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Pick.PickEndpointFromId "component1:solid1", "1"

'@ align wcs with point

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ define brick: component1:ram2

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Brick
     .Reset 
     .Name "ram2" 
     .Component "component1" 
     .Material "Copper (pure)" 
     .Xrange "0", "lengthram" 
     .Yrange "0", "h_ram1" 
     .Zrange "0", "h_copper" 
     .Create
End With

'@ rotate wcs

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
WCS.RotateWCS "w", "315.00"

'@ pick end point

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Pick.PickEndpointFromId "component1:ram2", "6"

'@ align wcs with point

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ define brick: component1:ram22

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Brick
     .Reset 
     .Name "ram22" 
     .Component "component1" 
     .Material "Copper (pure)" 
     .Xrange "-3", "length/2-out_rad-lengthram*0.70710678811" 
     .Yrange "0", "h_ram1" 
     .Zrange "0", "h_copper" 
     .Create
End With

'@ pick end point

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Pick.PickEndpointFromId "component1:ram2", "7"

'@ align wcs with point

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ pick end point

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Pick.PickEndpointFromId "component1:ram2", "4"

'@ define curve line: curve1:line1

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Line
     .Reset 
     .Name "line1" 
     .Curve "curve1" 
     .X1 "0.0" 
     .Y1 "-mezera" 
     .X2 "0.0" 
     .Y2 "0.0" 
     .Create
End With

'@ pick mid point

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Pick.PickCurveMidpointFromId "curve1:line1", "1"

'@ align wcs with point

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ clear picks

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Pick.ClearAllPicks

'@ transform: mirror component1:ram2

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Transform 
     .Reset 
     .Name "component1:ram2" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .PlaneNormal "0", "1", "0" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Mirror" 
End With

'@ transform: mirror component1:ram22

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Transform 
     .Reset 
     .Name "component1:ram22" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .PlaneNormal "0", "1", "0" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Mirror" 
End With

'@ boolean add shapes: component1:ram2_1, component1:ram22_1

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Solid.Add "component1:ram2_1", "component1:ram22_1"

'@ boolean add shapes: component1:ram2, component1:ram22

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Solid.Add "component1:ram2", "component1:ram22"

'@ boolean add shapes: component1:solid1, component1:ram2

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Solid.Add "component1:solid1", "component1:ram2"

'@ boolean add shapes: component1:ram2_1, component1:solid1

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Solid.Add "component1:ram2_1", "component1:solid1"

'@ boolean add shapes: component1:ram2_1, component1:ram1

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Solid.Add "component1:ram2_1", "component1:ram1"

'@ delete curve item: curve1:line1

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Curve.DeleteCurveItem "curve1", "line1"

'@ pick end point

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Pick.PickEndpointFromId "component1:ram2_1", "26"

'@ align wcs with point

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ rotate wcs

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
WCS.RotateWCS "w", "45.00"

'@ define brick: component1:del

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Brick
     .Reset 
     .Name "del" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "-2", "5" 
     .Yrange "0", "2" 
     .Zrange "0", "-h_copper" 
     .Create
End With

'@ boolean subtract shapes: component1:ram2_1, component1:del

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Solid.Subtract "component1:ram2_1", "component1:del"

'@ pick end point

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Pick.PickEndpointFromId "component1:ram2_1", "61"

'@ align wcs with point

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ rotate wcs

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
WCS.RotateWCS "w", "180.00"

'@ define brick: component1:del

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Brick
     .Reset 
     .Name "del" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "0", "3" 
     .Yrange "-2", "5" 
     .Zrange "0", "-h_copper" 
     .Create
End With

'@ boolean subtract shapes: component1:ram2_1, component1:del

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Solid.Subtract "component1:ram2_1", "component1:del"

'@ pick face

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Pick.PickFaceFromId "component1:ram2_1", "18"

'@ define port: 1

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Port 
     .Reset 
     .PortNumber "1" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "0"
     .Coordinates "Picks"
     .Orientation "positive"
     .PortOnBound "True"
     .ClipPickedPortToBound "False"
     .Xrange "-1", "1"
     .Yrange "-30", "-30"
     .Zrange "1.524", "1.559"
     .XrangeAdd "h_ram1*5", "h_ram1*5"
     .YrangeAdd "0.0", "0.0"
     .ZrangeAdd "h_sub", "h_ram1*5"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ pick face

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Pick.PickFaceFromId "component1:ram2_1", "52"

'@ define port: 2

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Port 
     .Reset 
     .PortNumber "2" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "0"
     .Coordinates "Picks"
     .Orientation "positive"
     .PortOnBound "False"
     .ClipPickedPortToBound "False"
     .Xrange "5.5997474683058", "7.5997474683058"
     .Yrange "29.976497041158", "29.976497041158"
     .Zrange "1.524", "1.559"
     .XrangeAdd "h_ram1*2.5", "h_ram1*2.5"
     .YrangeAdd "0.0", "0.0"
     .ZrangeAdd "h_sub", "h_ram1*2.5"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ modify port: 2

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Port 
     .Reset 
     .LoadContentForModify "2" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "0"
     .Coordinates "Picks"
     .Orientation "positive"
     .PortOnBound "False"
     .ClipPickedPortToBound "False"
     .Xrange "5.599747", "7.599747"
     .Yrange "29.976497", "29.976497"
     .Zrange "1.524", "1.559"
     .XrangeAdd "h_ram1*2.5", "h_ram1*2.5"
     .YrangeAdd "0.0", "0.0"
     .ZrangeAdd "h_sub", "h_ram1*5"
     .SingleEnded "False"
     .Shield "none"
     .WaveguideMonitor "False"
     .Modify 
End With

'@ pick face

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Pick.PickFaceFromId "component1:ram2_1", "24"

'@ define port: 3

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Port 
     .Reset 
     .PortNumber "3" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "0"
     .Coordinates "Picks"
     .Orientation "positive"
     .PortOnBound "False"
     .ClipPickedPortToBound "False"
     .Xrange "-7.5997474683058", "-5.5997474683058"
     .Yrange "29.976497041158", "29.976497041158"
     .Zrange "1.524", "1.559"
     .XrangeAdd "h_ram1*2.5", "h_ram1*2.5"
     .YrangeAdd "0.0", "0.0"
     .ZrangeAdd "h_sub", "h_ram1*5"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ activate global coordinates

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
WCS.ActivateWCS "global"

'@ define time domain solver parameters

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Mesh.SetCreator "High Frequency" 

With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-40"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .RunDiscretizerOnly "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

'@ define background

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Background 
     .ResetBackground 
     .XminSpace "0.0" 
     .XmaxSpace "0.0" 
     .YminSpace "0.0" 
     .YmaxSpace "0.0" 
     .ZminSpace "0.0" 
     .ZmaxSpace "0.0" 
     .ApplyInAllDirections "False" 
End With 

With Material 
     .Reset 
     .Rho "0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .UseEmissivity "True"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .SolarRadiationAbsorptionType "Opaque"
     .Absorptance "0.0"
     .UseSemiTransparencyCalculator "False"
     .SolarRadTransmittance "0.0"
     .SolarRadReflectance "0.0"
     .SolarRadSpecimenThickness "0.0"
     .SolarRadRefractiveIndex "1.0"
     .SolarRadAbsorptionCoefficient "0.0"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "Hz"
     .MaterialUnit "Geometry", "m"
     .MaterialUnit "Time", "s"
     .MaterialUnit "Temperature", "K"
     .Epsilon "1.0"
     .Mu "1.0"
     .Sigma "0.0"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstSigma"
     .SetConstTanDStrategyEps "AutomaticOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstSigma"
     .SetConstTanDStrategyMu "AutomaticOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps  "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .UseOnlyDataInSimFreqRangeNthModelEps "False"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseOnlyDataInSimFreqRangeNthModelMu "False"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "0.6", "0.6", "0.6" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .ChangeBackgroundMaterial
End With

'@ define boundaries

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Boundary
     .Xmin "open"
     .Xmax "open"
     .Ymin "open"
     .Ymax "open"
     .Zmin "open"
     .Zmax "open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
     .ApplyInAllDirections "False"
End With

'@ delete monitor: farfield (f=4)

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Monitor.Delete "farfield (f=4)"

'@ delete monitor: farfield (f=4.5)

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Monitor.Delete "farfield (f=4.5)"

'@ delete monitor: farfield (f=5)

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Monitor.Delete "farfield (f=5)"

'@ clear picks

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Pick.ClearAllPicks

'@ pick end point

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Pick.PickEndpointFromId "component1:ram2_1", "64"

'@ pick end point

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Pick.PickEndpointFromId "component1:ram2_1", "44"

'@ define lumped element: Folder1:element1

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With LumpedElement
     .Reset 
     .SetName "element1" 
     .Folder "Folder1" 
     .SetType "RLCSerial"
     .SetR "resistor_R"
     .SetL "1e-9"
     .SetC "0.05e-12"
     .SetGs "0"
     .SetI0 "1e-14"
     .SetT "300"
     .SetMonitor "True"
     .SetRadius "0.0"
     .CircuitFileName ""
     .CircuitId "1"
     .UseCopyOnly "True"
     .UseRelativePath "False"
     .SetP1 "True", "0.65", "8.9764970896224", "1.559" 
     .SetP2 "True", "-0.65", "8.9764970896224", "1.559" 
     .SetInvert "False" 
     .Wire "" 
     .Position "end1" 
     .Create
End With

'@ set mesh properties (Hexahedral FIT)

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Mesh 
     .MeshType "PBA" 
     .SetCreator "High Frequency"
End With 
With MeshSettings 
     .SetMeshType "Hex" 
     .Set "Version", 1%
     'MAX CELL - WAVELENGTH REFINEMENT 
     .Set "StepsPerWaveNear", "30" 
     .Set "StepsPerWaveFar", "30" 
     .Set "WavelengthRefinementSameAsNear", "1" 
     'MAX CELL - GEOMETRY REFINEMENT 
     .Set "StepsPerBoxNear", "20" 
     .Set "StepsPerBoxFar", "1" 
     .Set "MaxStepNear", "0" 
     .Set "MaxStepFar", "0" 
     .Set "ModelBoxDescrNear", "maxedge" 
     .Set "ModelBoxDescrFar", "maxedge" 
     .Set "UseMaxStepAbsolute", "0" 
     .Set "GeometryRefinementSameAsNear", "0" 
     'MIN CELL 
     .Set "UseRatioLimitGeometry", "1" 
     .Set "RatioLimitGeometry", "30" 
     .Set "MinStepGeometryX", "0" 
     .Set "MinStepGeometryY", "0" 
     .Set "MinStepGeometryZ", "0" 
     .Set "UseSameMinStepGeometryXYZ", "1" 
End With 
With MeshSettings 
     .Set "PlaneMergeVersion", "2" 
End With 
With MeshSettings 
     .SetMeshType "Hex" 
     .Set "FaceRefinementType", "NONE" 
     .Set "FaceRefinementRatio", "2" 
     .Set "FaceRefinementStep", "0" 
     .Set "FaceRefinementNSteps", "2" 
     .Set "EllipseRefinementType", "NONE" 
     .Set "EllipseRefinementRatio", "2" 
     .Set "EllipseRefinementStep", "0" 
     .Set "EllipseRefinementNSteps", "2" 
     .Set "FaceRefinementBufferLines", "3" 
     .Set "EdgeRefinementType", "RATIO" 
     .Set "EdgeRefinementRatio", "2" 
     .Set "EdgeRefinementStep", "0" 
     .Set "EdgeRefinementBufferLines", "3" 
     .Set "RefineEdgeMaterialGlobal", "0" 
     .Set "RefineAxialEdgeGlobal", "0" 
     .Set "BufferLinesNear", "3" 
     .Set "UseDielectrics", "1" 
     .Set "EquilibrateOn", "1" 
     .Set "Equilibrate", "1.5" 
     .Set "IgnoreThinPanelMaterial", "0" 
End With
With MeshSettings 
     .SetMeshType "Hex" 
     .Set "SnapToAxialEdges", "0"
     .Set "SnapToPlanes", "1"
     .Set "SnapToSpheres", "1"
     .Set "SnapToEllipses", "0"
     .Set "SnapToCylinders", "1"
     .Set "SnapToCylinderCenters", "1"
     .Set "SnapToEllipseCenters", "1"
     .Set "SnapToTori", "1"
     .Set "SnapXYZ" , "1", "1", "1"
End With 
With Mesh 
     .ConnectivityCheck "True"
     .UsePecEdgeModel "True" 
     .PointAccEnhancement "0" 
     .TSTVersion "0"
	  .PBAVersion "2024083025" 
     .SetCADProcessingMethod "MultiThread22", "-1" 
     .SetGPUForMatrixCalculationDisabled "False" 
End With

'@ define boundaries

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Boundary
     .Xmin "open"
     .Xmax "open"
     .Ymin "open"
     .Ymax "open"
     .Zmin "electric"
     .Zmax "open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
     .ApplyInAllDirections "False"
End With

