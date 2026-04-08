include <master_dims.scad>
include <parts.scad>

module front_fork_assy() {
    // Steerer Connection
    color("gray")
    translate([0, 0, 150]) cylinder(d=steering_shaft_dia, h=300, center=true);

    // Fork Crown (10mm thick)
    color("black")
    translate([0, 0, 0]) cube([40, fork_crown_width, 10], center=true);

    // Fork Legs with Rake (35mm)
    // Wider spacing: Inner 200mm -> Center to center 220mm (Legs are 20mm wide)
    color("gray") {
        translate([fork_rake, 110, -fork_length/2]) rect_tube(20, 40, fork_length);
        translate([fork_rake, -110, -fork_length/2]) rect_tube(20, 40, fork_length);
    }

    // Dropout Plates (8mm)
    color("silver") {
        translate([fork_rake, 110, -fork_length]) cube([40, 8, 50], center=true);
        translate([fork_rake, -110, -fork_length]) cube([40, 8, 50], center=true);
    }
}

front_fork_assy();
