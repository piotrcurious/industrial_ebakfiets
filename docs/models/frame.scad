include <parts.scad>

// Main Frame Assembly
module frame() {
    // Left Spar
    translate([900, 405, 0]) rect_tube(20, 40, 1800, 2.5);
    // Right Spar
    translate([900, -405, 0]) rect_tube(20, 40, 1800, 2.5);

    // Cargo Bed Area (810mm width)
    color("green", 0.3)
    translate([1505, 0, 20]) cube([1210, 810, 2], center=true);

    // Head Tube
    translate([1800, 0, 100])
    rotate([0, -22, 0]) // 68 degree head angle
    pipe(42.16, 35.05, 180);
}

frame();
