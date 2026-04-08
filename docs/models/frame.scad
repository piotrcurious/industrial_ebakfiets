include <parts.scad>

module frame() {
    // 1. MAIN SPARS (40x20mm)
    // Internal Spacing 810mm -> Center-to-Center 830mm
    color("gray") {
        translate([900, 415, 0]) rect_tube(20, 40, 1800, 2.5);
        translate([900, -415, 0]) rect_tube(20, 40, 1800, 2.5);
    }

    // 2. CROSS MEMBERS
    color("darkgray") {
        translate([900, 0, 0]) rect_tube(810, 40, 20, 2.5);
        translate([1500, 0, 0]) rect_tube(810, 40, 20, 2.5);
        translate([2100, 0, 0]) rect_tube(810, 40, 20, 2.5);
    }

    // 3. HEAD TUBE (1-1/4" pipe, 68 degree angle)
    translate([2100, 0, 100])
    rotate([0, -22, 0])
    pipe(42.16, 35.05, 180);

    // 4. REAR TRIANGLE TAPER (Conceptual)
    color("black") {
        translate([250, 200, 0]) rotate([0,0,10]) rect_tube(20, 40, 500, 2.5);
        translate([250, -200, 0]) rotate([0,0,-10]) rect_tube(20, 40, 500, 2.5);
    }
}

frame();
