include <master_dims.scad>
use <parts.scad>

// The Fork connects the FRONT AXLE to the STEERING SHAFT.
// Origin = Front Axle Center (0,0,0)
module front_fork_assy() {
    // 1. Dropouts (Mated to Axle ends)
    // Axle is at (0, 0, 0)
    for(s=[-1, 1]) {
        translate([0, s * (fork_inner_spacing/2 + 5), 0])
        color("silver")
        difference() {
            cube([60, 10, 80], center=true);
            rotate([90, 0, 0]) cylinder(d=front_axle_dia+1, h=20, center=true);
        }
    }

    // 2. Fork Blades (From Dropout top to Crown)
    // Offset by rake to move from axle center to steering axis
    for(s=[-1, 1]) {
        // Blade starts at dropout (0, s*offset, 40)
        // Reaches crown at (fork_rake, s*offset, fork_length)
        // We use a hull or a rotated tube to bridge
        hull() {
            translate([0, s * (fork_inner_spacing/2 + 15), 35])
            cube([30, 30, 10], center=true);

            translate([fork_rake, s * (fork_inner_spacing/2 + 15), fork_length])
            cube([30, 30, 10], center=true);
        }
    }

    // 3. Fork Crown (Connecting Blades at the top)
    translate([fork_rake, 0, fork_length])
    color("darkslategray")
    rect_tube(fork_crown_width, 40, 60);

    // 4. Steering Shaft (Mates to Head Tube)
    // Starts exactly at Crown center surface
    translate([fork_rake, 0, fork_length + 20])
    color("silver")
    cylinder(d=steering_shaft_dia, h=head_tube_length + 100);
}

front_fork_assy();
