include <master_dims.scad>
include <parts.scad>

module front_fork() {
    // Steerer
    color("gray")
    translate([0, 0, 150]) cylinder(d=steering_shaft_dia, h=300, center=true);

    // Crown
    color("black")
    translate([0, 0, 0]) cube([40, fork_crown_width, 10], center=true);

    // Legs with Rake (X-offset)
    color("gray") {
        translate([fork_rake, fork_inner_spacing/2 + 10, -fork_length/2]) rect_tube(20, 40, fork_length);
        translate([fork_rake, -fork_inner_spacing/2 - 10, -fork_length/2]) rect_tube(20, 40, fork_length);
    }
}

front_fork();
