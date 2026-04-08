include <parts.scad>

module frame() {
    // Origin is at Rear Axle center

    // Main Rails (40x20)
    color("gray") {
        translate([900, 405, 0]) rect_tube(20, 40, 1800);
        translate([900, -405, 0]) rect_tube(20, 40, 1800);
    }

    // Cargo Bed Floor (1210x810 internal)
    color("green", 0.3)
    translate([1505, 0, 20]) cube([1210, 810, 5], center=true);

    // Head Tube (1-1/4" Sch 40)
    // Placed at X=1800 relative to spars, angled 68 deg
    translate([2100, 0, 150])
    rotate([0, 22, 0]) // Tilt forward
    pipe(42.16, 35.05, 200);
}

frame();
