wheel_assembly()          ← default render
wheel_exploded(gap=80)    ← rim halves pull apart on ±Z; tube visible in cavity
wheel_xray()              ← % modifier ghosts shells; internals solid in colour
wheel_section()           ← cube removes the +X/+Y quadrant

  hub_motor()
    _motor_shell()        ← rotor housing + flange rings + bearing recesses
    _motor_stator()       ← laminated core with 24 salient teeth
    _motor_magnets()      ← 28-pole tile ring inside shell
    _motor_bearings()     ← two annular rings
    axle()                ← flat-sided shaft + locknuts

  rim_half("outer"|"inner")
    _rim_ring()           ← rotate_extrude of 12-point profile
                             (hump → bead seat → well → split shoulder)
    _rim_split_ring()     ← annular bolt-flange boss at z = 0
    _rim_disc()           ← annular spider: hub clearance + 6 lightening holes
                             + 12 split-bolt holes

  split_bolts()           ← 12× M7 with hex head and hex nut
  valve_stem()            ← Schrader valve in outer half well
  inner_tube()            ← torus, CL at r ≈ 214 mm
  tire_body()             ← elliptical torus (radial × axial axes differ)
