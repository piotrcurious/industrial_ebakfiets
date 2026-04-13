include <master_dims.scad>
include <parts.scad>

// FORK ASSEMBLY
// Origin = FRONT AXLE CENTER (0,0,0)
module front_fork_assy() {

    // 1. DROPOUT PLATES (Mated to Axle ends)
    for(s=[-1, 1]) {
        translate([0, s * (front_hub_dropout/2 + 8), 0])
        color(color_fastener)
        difference() {
            rounded_box([70, 12, 120], r=5, center=true);
            // Axle Slot
            translate([0, 0, -35]) cube([10.2, 20, 60], center=true);
            // Lightening holes
            translate([20, 0, 30]) rotate([90, 0, 0]) cylinder(d=15, h=30, center=true);

            if (s == 1) { // Right side torque arm mount
                translate([0, 0, 40]) rotate([90, 0, 0]) cylinder(d=6.5, h=30, center=true);
            }
            if (s == -1) { // Left side IS brake mount
                translate([0, 0, brake_mount_height]) {
                    translate([0, 0, -25.5]) rotate([0, 90, 0]) cylinder(d=6.5, h=30, center=true);
                    translate([0, 0, 25.5]) rotate([0, 90, 0]) cylinder(d=6.5, h=30, center=true);
                }
            }
        }
    }

    // 2. FORK BLADES (Tapered)
    for(s=[-1, 1]) {
        color(color_frame)
        hull() {
            translate([0, s * (front_hub_dropout/2 + 8), 50]) sphere(d=35);
            translate([fork_rake, s * (fork_inner_spacing/2 + 20), fork_length - 20]) sphere(d=45);
        }
    }

    // 3. FORK CROWN (Heavy Duty)
    translate([fork_rake, 0, fork_length])
    color(color_subframe)
    union() {
        // Main transverse member
        rotate([0, 90, 0]) rect_tube(50, 70, fork_crown_width);
        // Gusseting
        hull() {
            for(s=[-1, 1]) translate([0, s * (fork_inner_spacing/2 + 20), -20]) sphere(d=45);
            translate([0, 0, 10]) sphere(d=60);
        }
    }

    // 4. STEERING SHAFT & COLLARS
    translate([fork_rake, 0, fork_length + 30]) {
        color(color_fastener) cylinder(d=steering_shaft_dia, h=head_tube_length + 120);
        // Lower Bearing Seat
        color(color_fixed) pipe(30, 15.1, 15);
        // Shaft Collar
        translate([0, 0, 20]) color(color_fastener) pipe(32, 15.1, 12);
    }

    // 5. LOWER STEERING BELL CRANK
    translate([fork_rake, 0, fork_length + 15])
    rotate([0, 0, 90])
    steering_arm(steering_arm_len);
}
