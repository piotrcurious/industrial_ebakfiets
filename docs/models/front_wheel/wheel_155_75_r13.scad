// ════════════════════════════════════════════════════════════════
//  wheel_155_75_r13.scad
//  155/75 R13 · Piaggio-style split rim · 250 W BLDC hub motor
//
//  Tyre:   155/75 R13  (section width 155 mm, aspect ratio 0.75,
//                       13" bead-seat ø = 330.2 mm)
//  Rim:    4.5 J 13, two-piece split rim (Piaggio / classic Vespa
//          style) allowing tube access without removing the wheel.
//  Motor:  250 W BLDC hub motor, scooter-class 13" fitment
//          (dimensions representative of QS Motor / Kunray
//           brushless units — 102 mm shell ø, 76 mm axial width,
//           12 mm axle, 84 mm stator ø, 24T/28P).
//
//  All dimensions in mm.
//  Coordinate system: axle along Z, wheel mid-plane at z = 0,
//                     +Z = non-motor (outer / free) side.
// ════════════════════════════════════════════════════════════════
//
//  ── INCLUDE USAGE ────────────────────────────────────────────
//  include <wheel_155_75_r13.scad>
//
//  ── SCENE MODULES ────────────────────────────────────────────
//  wheel_assembly()           Full assembled wheel
//  wheel_exploded([gap=80])   Exploded view (halves pull apart on Z)
//  wheel_xray()               Ghost outer shells, solid internals
//  wheel_section()            Quarter cut-away cross-section
//
//  ── PART MODULES ─────────────────────────────────────────────
//  tire_body()                155/75 R13 tyre (elliptical torus)
//  inner_tube()               Inner tube
//  rim_half(side)             side = "outer" | "inner"
//  split_bolts()              M7 split-joint fasteners (×12)
//  valve_stem()               Schräder valve on outer half
//  hub_motor()                BLDC assembly incl. stator/magnets
//  axle()                     Shaft with locknuts & flats
//
//  ── PRIVATE MODULES ──────────────────────────────────────────
//  Modules prefixed with _ are intentionally accessible after
//  include so that wheel_xray() can isolate motor internals for
//  the transparent-shell x-ray effect.
// ════════════════════════════════════════════════════════════════


// ╔══════════════════════════════════════════════════════════════╗
// ║  P A R A M E T E R S                                        ║
// ╚══════════════════════════════════════════════════════════════╝

// ── Tyre: 155 / 75 R13 ─────────────────────────────────────────
TW          = 155;              // section width              [mm]
TAR         = 0.75;             // aspect ratio
SWH         = TW * TAR;         // sidewall height = 116.25   [mm]
RIM_D       = 13 * 25.4;        // bead-seat Ø    = 330.20   [mm]
RIM_R       = RIM_D / 2;        // bead-seat radius= 165.10  [mm]
TIRE_OR     = RIM_R + SWH;      // tyre outer radius= 281.35 [mm]

// ── Split rim: 4.5 J 13 (Piaggio / Vespa style) ────────────────
RW          = 4.5 * 25.4;       // bead-to-bead width ≈ 114.3 [mm]
RIM_DROP    = 12;               // drop-centre depth          [mm]
RIM_WALL    = 4;                // rim-ring wall thickness    [mm]
RFL_H       = 15;               // flange height above seat   [mm]
RFL_T       = 5;                // flange wall thickness      [mm]
R_HUMP      = 3;                // bead-retaining hump height [mm]
R_SPLIT_T   = 7;                // split-flange thickness / half [mm]
R_SPLIT_N   = 12;               // split-joint bolt count
R_SPLIT_BD  = 7;                // split bolt shank Ø         [mm]
// Split bolt PCD (diameter): bolts sit at RIM_R − 28 mm radius
R_SPLIT_PCD = (RIM_R - 28) * 2; // ≈ 274.2 mm  (bolt-circle ⌀)
R_DISC_T    = 8;                // spoke disc thickness       [mm]
R_HOLE_N    = 6;                // lightening holes per disc
R_HOLE_D    = 34;               // lightening hole Ø          [mm]

// ── Hub motor: 250 W BLDC (QS-class scooter unit, 13″) ─────────
M_OD        = 102;              // hub-shell outer Ø          [mm]
M_W         = 76;               // hub-shell axial width      [mm]
M_FLANGE_D  = 88;               // spoke-flange Ø             [mm]
M_CASE_T    = 3.5;              // shell wall thickness       [mm]
M_AXLE_D    = 12;               // axle Ø                     [mm]
M_AXLE_L    = 148;              // total axle length          [mm]
M_AXLE_FL   = 10;               // axle flat-to-flat          [mm]
M_STAT_D    = 84;               // stator OD                  [mm]
M_STAT_W    = 22;               // stator stack width         [mm]
M_TEETH     = 24;               // stator slot count (cosmetic)
M_POLES     = 28;               // rotor pole count (cosmetic)
M_BRG_OD    = 32;               // bearing outer Ø            [mm]
M_BRG_W     = 9;                // bearing width              [mm]
M_PHASE_D   = 9;                // phase-cable exit hole Ø   [mm]

// ── Motor colour palette (RGBA) ─────────────────────────────────
MC_SHELL    = [0.72, 0.72, 0.78, 1];
MC_STATOR   = [0.22, 0.30, 0.72, 1];
MC_MAGNETS  = [0.85, 0.15, 0.10, 1];
MC_BEARINGS = [0.55, 0.55, 0.55, 1];
MC_AXLE     = [0.38, 0.38, 0.38, 1];
MC_RIM      = [0.80, 0.80, 0.85, 1];
MC_BOLT     = [0.60, 0.60, 0.62, 1];
MC_VALVE    = [0.22, 0.22, 0.22, 1];
MC_TUBE     = [0.10, 0.10, 0.10, 0.85];
MC_TIRE     = [0.12, 0.12, 0.12, 0.92];

// ── Rendering ───────────────────────────────────────────────────
$fn     = ($preview) ? 64 : 128;   // circle facets
_E      = 0.02;                    // Boolean-cut epsilon


// ╔══════════════════════════════════════════════════════════════╗
// ║  U T I L I T Y                                              ║
// ╚══════════════════════════════════════════════════════════════╝

// Circular bolt/hole pattern in XY plane, centred on Z.
// n   = hole count
// pcd = pitch-circle DIAMETER  (holes at pcd/2 radius)
// h   = height of hole cylinder (centered)
// d   = hole Ø
module bolt_ring(n, pcd, h, d) {
    for (i = [0 : n-1])
        rotate([0, 0, i * 360/n])
        translate([pcd/2, 0, 0])
        cylinder(h=h, d=d, center=true);
}


// ╔══════════════════════════════════════════════════════════════╗
// ║  A X L E                                                    ║
// ╚══════════════════════════════════════════════════════════════╝

module axle() {
    flat_cut = (M_AXLE_D - M_AXLE_FL) / 2;   // depth of each flat

    color(MC_AXLE) {
        // Shaft with anti-rotation flats
        difference() {
            cylinder(h=M_AXLE_L, d=M_AXLE_D, center=true);
            for (s = [-1, 1])
                translate([0, s * (M_AXLE_D - flat_cut), 0])
                cube([M_AXLE_D + 2, M_AXLE_D, M_AXLE_L + 2], center=true);
        }
        // Locknuts (hex, cosmetic)
        for (zp = [M_AXLE_L/2 - 4,  -M_AXLE_L/2 + 4])
            translate([0, 0, zp])
            cylinder(h=8, d=22, $fn=6, center=true);
    }
}


// ╔══════════════════════════════════════════════════════════════╗
// ║  H U B   M O T O R                                          ║
// ╚══════════════════════════════════════════════════════════════╝

// Public entry point: complete hub-motor assembly with colour.
module hub_motor() {
    color(MC_SHELL)    _motor_shell();
    color(MC_STATOR)   _motor_stator();
    color(MC_MAGNETS)  _motor_magnets();
    color(MC_BEARINGS) _motor_bearings();
    axle();
}

// Rotor housing + end caps with spoke-flange rings.
module _motor_shell() {
    difference() {
        union() {
            // Main cylindrical shell
            cylinder(h=M_W, d=M_OD, center=true);
            // Spoke-flange rings on each end-cap
            for (s = [-1, 1])
                translate([0, 0, s * (M_W/2 - M_CASE_T)])
                cylinder(h=M_CASE_T*2 + 2, d=M_FLANGE_D, center=true);
        }
        // Interior cavity
        cylinder(h=M_W - 2*M_CASE_T,    d=M_OD - 2*M_CASE_T, center=true);
        // Axle bore
        cylinder(h=M_W + 2,              d=M_AXLE_D + 0.5,    center=true);
        // Bearing recesses at each end
        for (s = [-1, 1])
            translate([0, 0, s * (M_W/2)])
            cylinder(h=M_BRG_W + 1, d=M_BRG_OD + 0.5, center=true);
        // Phase-cable exit hole (inner / motor side)
        translate([M_OD/2 - M_CASE_T/2, 0, -M_W/2 + M_CASE_T/2])
        cylinder(h=M_CASE_T + 2, d=M_PHASE_D, center=true);
        // Disc-attachment bolt holes through flange rings
        bolt_ring(8, M_FLANGE_D - 12, M_CASE_T*3 + 2, 5.2);
    }
}

// Stator: laminated iron core with salient teeth (cosmetic detail).
module _motor_stator() {
    TOOTH_L = 9;
    TOOTH_W = 5;
    difference() {
        union() {
            cylinder(h=M_STAT_W, d=M_STAT_D, center=true);
            for (i = [0 : M_TEETH-1])
                rotate([0, 0, i * 360/M_TEETH])
                translate([M_STAT_D/2 + TOOTH_L/2 - 1, 0, 0])
                cube([TOOTH_L, TOOTH_W, M_STAT_W], center=true);
        }
        // Winding bore (simplified)
        cylinder(h=M_STAT_W + 2, d=M_STAT_D - 20, center=true);
        // Axle / press-fit bore
        cylinder(h=M_STAT_W + 2, d=M_AXLE_D + 1,  center=true);
    }
}

// Rotor: permanent-magnet tile ring bonded inside shell.
module _motor_magnets() {
    r     = M_OD/2 - M_CASE_T - 2;
    segw  = (3.14159 * 2 * r) / M_POLES;   // arc width per magnet
    for (i = [0 : M_POLES-1])
        rotate([0, 0, i * 360/M_POLES])
        translate([r, 0, 0])
        cube([5, segw - 1.2, M_STAT_W - 3], center=true);
}

// Ball bearings (simplified as solid annular rings).
module _motor_bearings() {
    for (s = [-1, 1])
        translate([0, 0, s * (M_W/2 - M_BRG_W/2)])
        difference() {
            cylinder(h=M_BRG_W, d=M_BRG_OD,       center=true);
            cylinder(h=M_BRG_W + 1, d=M_AXLE_D + 0.2, center=true);
        }
}


// ╔══════════════════════════════════════════════════════════════╗
// ║  R I M   H A L F                                            ║
// ╚══════════════════════════════════════════════════════════════╝
//
//  rim_half("outer")  →  +Z half  (free / non-motor side)
//  rim_half("inner")  →  −Z half  (motor side, geometrically mirrored)
//
//  Each half consists of:
//    _rim_ring()        tyre-bearing channel  (rotate_extrude)
//    _rim_split_ring()  annular bolt-flange boss at z=0
//    _rim_disc()        flat spider disc connecting hub to rim ring

module rim_half(side = "outer") {
    if (side == "inner")
        mirror([0, 0, 1]) _rim_half_geom(valve = false);
    else
        _rim_half_geom(valve = true);
}

module _rim_half_geom(valve = false) {
    bolt_h = R_DISC_T * 2 + 4;   // bolt-hole depth (spans both discs)

    color(MC_RIM)
    difference() {
        union() {
            _rim_ring();
            _rim_split_ring();
            _rim_disc();
        }
        // ── Split-joint bolt holes (penetrate all sub-parts) ──
        bolt_ring(R_SPLIT_N, R_SPLIT_PCD, bolt_h, R_SPLIT_BD);
        // ── Valve-stem hole (outer half only) ─────────────────
        if (valve) {
            vr = RIM_R - RIM_DROP;      // drop-centre radius
            vz = RW/2 - 8;              // axial position in well
            translate([vr - 2, 0, vz])
            rotate([0, 90, 0])
            cylinder(h = RIM_DROP + 8, d = 8);
        }
    }
}

// ── Rim ring ─────────────────────────────────────────────────────
//  2-D profile (r, z) rotated 360° around the wheel axis.
//  z = 0  at split-joint plane;  z > 0  toward the outer side.
//
//  Profile landmarks:
//   A-B  inner wall (structural rib behind flange)
//   B-C  shelf connecting inner wall to flange
//   C-D  flange outer face
//   D-E  flange tip → bead-seat outer edge
//   E-F  bead seat
//   F-G  bead-retaining hump
//   G-H  drop-centre taper
//   H-I  drop-centre inner wall (above split flange)
//   I-J  split-flange shoulder
//   J-A  split face (z = 0 base)
module _rim_ring() {
    dr  = RIM_R - RIM_DROP;            // drop-centre radius  ≈ 153.1
    ri  = dr - RIM_WALL - 1;           // inner bore radius   ≈ 148.1
    bz  = RW / 2;                      // bead-seat inner z   ≈  57.15
    fz  = bz + RFL_T + 2;              // flange-base z       ≈  64.15
    ftz = fz + RFL_H - RFL_T;          // flange-tip z        ≈  74.15

    rotate_extrude(angle = 360, $fn = $fn)
    polygon([
        [ ri,              0             ],   // A  inner wall, split face
        [ ri,              ftz + 3       ],   // B  inner wall top
        [ RIM_R - 3,       ftz + 3       ],   // C  horizontal shelf
        [ RIM_R + RFL_H,   ftz           ],   // D  flange tip (outer top)
        [ RIM_R + RFL_H,   fz            ],   // E  flange outer face base
        [ RIM_R,           fz - 1        ],   // F  bead-seat outer edge
        [ RIM_R,           bz + 1        ],   // G  bead-seat
        [ RIM_R + R_HUMP,  bz - 2        ],   // H  bead-retaining hump
        [ dr + RIM_WALL,   bz - 20       ],   // I  drop-centre taper
        [ dr + RIM_WALL,   R_SPLIT_T + 1 ],   // J  inner wall above split
        [ dr,              R_SPLIT_T     ],   // K  split-flange shoulder
        [ dr,              0             ]    // L  split face (outer wall)
    ]);
}

// ── Split-flange annular boss ─────────────────────────────────────
//  Provides clamping area for the bolt heads / nuts at z = 0.
module _rim_split_ring() {
    pcd_r = R_SPLIT_PCD / 2;   // bolt-circle radius ≈ 137.1 mm
    ro    = pcd_r + 16;        // ring outer radius  ≈ 153.1 mm
    ri    = pcd_r - 16;        // ring inner radius  ≈ 121.1 mm
    difference() {
        cylinder(h = R_SPLIT_T, d = ro * 2);
        translate([0, 0, -_E])
        cylinder(h = R_SPLIT_T + 2*_E, d = ri * 2);
    }
}

// ── Spoke disc (spider) ───────────────────────────────────────────
//  Annular flat plate from hub shell OD to rim drop-centre.
//  Sits at z = 0 → z = R_DISC_T (against the split plane).
module _rim_disc() {
    disc_ro = RIM_R - RIM_DROP - 2;    // outer radius ≈ 151.1 mm
    disc_ri = M_OD / 2 + 1;           // inner radius ≈  52.0 mm (clears hub)
    lh_r    = (disc_ri + disc_ro) / 2; // lightening-hole radius ≈ 101.5 mm

    difference() {
        // Solid annular disc (z = 0 → R_DISC_T)
        difference() {
            cylinder(h = R_DISC_T, d = disc_ro * 2);
            translate([0, 0, -_E])
            cylinder(h = R_DISC_T + 2*_E, d = disc_ri * 2);
        }
        // Lightening holes
        for (i = [0 : R_HOLE_N-1])
            rotate([0, 0, i * 360/R_HOLE_N + (180/R_HOLE_N)])
            translate([lh_r, 0, -_E])
            cylinder(h = R_DISC_T + 2*_E, d = R_HOLE_D);
        // Split-bolt holes at rim PCD
        translate([0, 0, -_E])
        bolt_ring(R_SPLIT_N, R_SPLIT_PCD, R_DISC_T + 2*_E, R_SPLIT_BD + 0.5);
    }
}


// ╔══════════════════════════════════════════════════════════════╗
// ║  S P L I T   B O L T S                                      ║
// ╚══════════════════════════════════════════════════════════════╝

module split_bolts() {
    // Bolt shank spans both discs (one per half) meeting at z = 0
    shank_h = R_DISC_T * 2 + 4;    // = 20 mm
    head_d  = R_SPLIT_BD + 5;

    color(MC_BOLT)
    for (i = [0 : R_SPLIT_N-1]) {
        rotate([0, 0, i * 360/R_SPLIT_N])
        translate([R_SPLIT_PCD/2, 0, 0]) {
            // Shank (centred on z=0)
            cylinder(h = shank_h, d = R_SPLIT_BD - 1, center = true);
            // Bolt head (hex, +Z side)
            translate([0, 0,  shank_h/2 + 4])
            cylinder(h = 5, d = head_d, $fn = 6, center = true);
            // Nut (hex, −Z side)
            translate([0, 0, -shank_h/2 - 4])
            cylinder(h = 4, d = head_d, $fn = 6, center = true);
        }
    }
}


// ╔══════════════════════════════════════════════════════════════╗
// ║  V A L V E   S T E M                                        ║
// ╚══════════════════════════════════════════════════════════════╝

module valve_stem() {
    vr = RIM_R - RIM_DROP;         // drop-centre radius ≈ 153 mm
    vz = RW/2 - 8;                 // axial position in well

    // Stem points radially outward (rotate so +Z → +X, then translate)
    translate([vr - 2, 0, vz])
    rotate([0, 90, 0])
    color(MC_VALVE) {
        difference() {
            union() {
                cylinder(h = 30, d = 8);
                translate([0, 0, 28]) cylinder(h = 8, d = 7);  // cap
            }
            cylinder(h = 36, d = 4);   // bore
        }
        // Valve core pin (cosmetic)
        translate([0, 0, 8]) cylinder(h = 16, d = 2.5);
    }
}


// ╔══════════════════════════════════════════════════════════════╗
// ║  I N N E R   T U B E                                        ║
// ╚══════════════════════════════════════════════════════════════╝

module inner_tube() {
    CL_R  = RIM_R + SWH * 0.42;    // centreline radius ≈ 213.9 mm
    SEC_R = 30;                     // section radius      = 30   mm

    color(MC_TUBE)
    rotate_extrude($fn = $fn)
    translate([CL_R, 0, 0])
    circle(r = SEC_R, $fn = 36);
}


// ╔══════════════════════════════════════════════════════════════╗
// ║  T Y R E                                                    ║
// ╚══════════════════════════════════════════════════════════════╝
//  Elliptical torus profile: radial semi-axis = SWH/2 (= 58 mm),
//  axial semi-axis = TW × 0.47 (= 73 mm).
//  Centre at r = RIM_R + SWH/2 → outer radius = TIRE_OR exactly.

module tire_body() {
    CL_R = RIM_R + SWH/2;          // ≈ 223.2 mm
    AR   = SWH * 0.50;             // radial semi-axis  ≈ 58.1 mm
    AZ   = TW  * 0.47;             // axial semi-axis   ≈ 72.9 mm

    color(MC_TIRE)
    difference() {
        rotate_extrude($fn = $fn)
        translate([CL_R, 0, 0])
        scale([AR, AZ])
        circle(r = 1, $fn = 48);

        // Trim bead region that would overlap with rim flanges
        cylinder(h = RW + 12, d = (RIM_R - 5)*2, center = true);
    }
}


// ╔══════════════════════════════════════════════════════════════╗
// ║  A S S E M B L Y   M O D E S                                ║
// ╚══════════════════════════════════════════════════════════════╝

// ── Full assembled wheel ──────────────────────────────────────────
module wheel_assembly() {
    hub_motor();
    rim_half("outer");
    rim_half("inner");
    split_bolts();
    valve_stem();
    inner_tube();
    tire_body();
}


// ── Exploded view ─────────────────────────────────────────────────
//  gap  = axial distance each rim half travels from the midplane.
//         Default 80 mm gives clear visual separation.
//  Hub motor stays centred.  Rim halves slide apart along ±Z.
//  Tyre and tube remain at assembled position — the opening between
//  the two halves reveals the tube cavity, explaining the split-rim
//  concept elegantly.
module wheel_exploded(gap = 80) {
    // ── Hub motor: stays at origin ──
    hub_motor();

    // ── Outer rim half + valve: slide in +Z ──
    translate([0, 0, gap]) {
        rim_half("outer");
        valve_stem();
    }

    // ── Inner rim half: slide in −Z ──
    translate([0, 0, -gap])
        rim_half("inner");

    // ── Split bolts: mid-position (highlight the joint) ──
    split_bolts();

    // ── Tyre + tube: assembled position (visible in the gap) ──
    inner_tube();
    tire_body();
}


// ── X-ray view ───────────────────────────────────────────────────
//  Outer shells are rendered with OpenSCAD's  %  (background)
//  modifier, making them appear as transparent grey in preview
//  mode (F5).  Motor internals are re-rendered solidly in colour,
//  producing a classic x-ray transparency effect.
//
//  In full-render mode (F6)  %  objects are suppressed entirely;
//  use  wheel_section()  instead for a rendered cross-section.
module wheel_xray() {
    // Ghost: outer shells become translucent grey in F5 preview
    % tire_body();
    % rim_half("outer");
    % rim_half("inner");
    % _motor_shell();           // shell only; internals re-drawn below

    // Solid: motor internals in full colour
    color(MC_STATOR)   _motor_stator();
    color(MC_MAGNETS)  _motor_magnets();
    color(MC_BEARINGS) _motor_bearings();
    axle();

    // Solid: remaining non-structural parts
    split_bolts();
    valve_stem();
    inner_tube();
}


// ── Cross-section (quarter removed) ──────────────────────────────
//  Removes the +X / +Y quadrant to expose the interior.
//  Valid in both preview (F5) and full render (F6).
module wheel_section() {
    R = TIRE_OR + 20;           // bounding box half-size (radial)
    H = M_AXLE_L + 30;         // bounding box height

    difference() {
        wheel_assembly();
        // Remove the +X / +Y quadrant
        translate([R/2, R/2, 0])
        cube([R, R, H], center = true);
    }
}


// ╔══════════════════════════════════════════════════════════════╗
// ║  D E F A U L T   R E N D E R                                ║
// ║  Un-comment the desired view, or call from your own file    ║
// ║  after  include <wheel_155_75_r13.scad>                     ║
// ╚══════════════════════════════════════════════════════════════╝

wheel_assembly();
// wheel_exploded(gap = 80);
// wheel_xray();
// wheel_section();
