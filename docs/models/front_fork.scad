include <master_dims.scad>
use <parts.scad>

// FORK ASSEMBLY
// Origin = FRONT AXLE CENTER (0,0,0)
module front_fork_assy() {

    // 1. DROPOUT PLATES (Mated to Axle ends)
    // Hub dropout is 175mm. Dropout centers are at +/- 87.5mm.
    for(s=[-1, 1]) {
        translate([0, s * (front_hub_dropout/2 + 5), 0])
        color("silver")
        difference() {
            // 8mm laser cut plate
            cube([60, 10, 100], center=true);
            // Axle hole (M14)
            rotate([90, 0, 0]) cylinder(d=front_axle_dia+1, h=20, center=true);
        }
    }

    // 2. FORK BLADES (From Dropout TOP SURFACE to CROWN BOTTOM SURFACE)
    // Dropout top is at Z = 50. Crown bottom is at Z = fork_length.
    for(s=[-1, 1]) {
        hull() {
            // Mating to Dropout
            translate([0, s * (front_hub_dropout/2 + 15), 45])
            cube([30, 30, 10], center=true);

            // Mating to Crown
            translate([fork_rake, s * (fork_inner_spacing/2 + 15), fork_length - 20])
            cube([30, 30, 10], center=true);
        }
    }

    // 3. FORK CROWN (Connecting Blades)
    // Mating surface for the steering shaft is the TOP CENTER.
    translate([fork_rake, 0, fork_length])
    color("darkslategray")
    rect_tube(fork_crown_width, 40, 60);

    // 4. STEERING SHAFT (Mates to Crown Top Center)
    // 15mm Shaft for 7202 bearings.
    translate([fork_rake, 0, fork_length + 20])
    color("silver")
    cylinder(d=steering_shaft_dia, h=head_tube_length + 100);

    // Shaft Collar (Locking the bearing stack)
    translate([fork_rake, 0, fork_length + 25])
    color("dimgray")
    pipe(30, 15.1, 10);
}

front_fork_assy();
