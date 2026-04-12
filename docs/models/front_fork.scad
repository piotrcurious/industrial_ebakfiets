include <master_dims.scad>
include <parts.scad>

// FORK ASSEMBLY
// Origin = FRONT AXLE CENTER (0,0,0)
module front_fork_assy() {

    // 1. DROPOUT PLATES (Mated to Axle ends)
    // Hub dropout is 175mm. Dropout centers are at +/- 87.5mm.
    for(s=[-1, 1]) {
        translate([0, s * (front_hub_dropout/2 + 5), 0])
        color(color_fastener)
        difference() {
            // 8mm laser cut plate
            cube([60, 10, 100], center=true);

            // Axle Slot (10.2mm wide for M14 axle flats)
            // Open bottom for easy installation
            translate([0, 0, -25])
            cube([10.2, 20, 50], center=true);

            // Torque Arm Mounting Point (M6 hole)
            if (s == 1) { // Right side torque arm
                translate([20, 0, 30])
                rotate([90, 0, 0]) cylinder(d=6.2, h=20, center=true);
            }

            // IS Disc Brake Caliper Tabs (Left side)
            if (s == -1) {
                translate([0, 0, brake_mount_height]) {
                    // Lower Tab
                    translate([0, 0, -25.5]) rotate([0, 90, 0]) cylinder(d=10, h=10, center=true);
                    // Upper Tab
                    translate([0, 0, 25.5]) rotate([0, 90, 0]) cylinder(d=10, h=10, center=true);
                }
            }
        }
    }

    // 2. FORK BLADES (From Dropout TOP SURFACE to CROWN BOTTOM SURFACE)
    // Optimized for welding: Tapered profile using hull() between spheres for smoother transitions
    for(s=[-1, 1]) {
        color(color_frame)
        hull() {
            // Lower joint at dropout (wide base)
            translate([0, s * (front_hub_dropout/2 + 5), 50])
            sphere(d=30);

            // Upper joint at crown (reinforced transition)
            translate([fork_rake, s * (fork_inner_spacing/2 + 15), fork_length - 10])
            sphere(d=40);
        }
    }

    // 3. FORK CROWN (Connecting Blades)
    // Mating surface for the steering shaft is the TOP CENTER.
    translate([fork_rake, 0, fork_length])
    color(color_subframe)
    union() {
        // Main crossbar
        rotate([0, 90, 0]) rect_tube(40, 60, fork_crown_width);

        // Reinforcing Gussets / Plate (Structural bridge)
        hull() {
            for(s=[-1, 1]) translate([0, s * (fork_inner_spacing/2 + 15), -15])
            sphere(d=40);
        }
    }

    // 4. STEERING SHAFT (Mates to Crown Top Center)
    // 15mm Shaft for 7202 bearings.
    translate([fork_rake, 0, fork_length + 20])
    color(color_fastener)
    cylinder(d=steering_shaft_dia, h=head_tube_length + 100);

    // Shaft Collar (Locking the bearing stack)
    translate([fork_rake, 0, fork_length + 25])
    color(color_fixed)
    pipe(30, 15.1, 10);

    // 5. STEERING BELL CRANK (Lower Pivot)
    translate([fork_rake, 0, fork_length + 15])
    rotate([0, 0, 0])
    steering_arm();
}

front_fork_assy();
