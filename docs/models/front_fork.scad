include <master_dims.scad>
include <parts.scad>

// FORK ASSEMBLY
// Origin = FRONT AXLE CENTER (0,0,0)
module front_fork_assy() {

    // 1. DROPOUT PLATES (Mated to Axle ends)
    for(s=[-1, 1]) {
        translate([0, s * (front_hub_dropout/2 + 5), 0])
        color(color_fastener)
        difference() {
            cube([60, 10, 100], center=true);
            translate([0, 0, -25]) cube([10.2, 20, 50], center=true);
            if (s == 1) { // Right side torque arm
                translate([20, 0, 30]) rotate([90, 0, 0]) cylinder(d=6.2, h=20, center=true);
            }
            if (s == -1) { // Left side brake mount
                translate([0, 0, brake_mount_height]) {
                    translate([0, 0, -25.5]) rotate([0, 90, 0]) cylinder(d=10, h=10, center=true);
                    translate([0, 0, 25.5]) rotate([0, 90, 0]) cylinder(d=10, h=10, center=true);
                }
            }
        }
    }

    // 2. FORK BLADES
    for(s=[-1, 1]) {
        color(color_frame)
        hull() {
            translate([0, s * (front_hub_dropout/2 + 5), 50]) sphere(d=30);
            translate([fork_rake, s * (fork_inner_spacing/2 + 15), fork_length - 10]) sphere(d=40);
        }
    }

    // 3. FORK CROWN
    translate([fork_rake, 0, fork_length])
    color(color_subframe)
    union() {
        rotate([0, 90, 0]) rect_tube(40, 60, fork_crown_width);
        hull() {
            for(s=[-1, 1]) translate([0, s * (fork_inner_spacing/2 + 15), -15]) sphere(d=40);
        }
    }

    // 4. STEERING SHAFT
    translate([fork_rake, 0, fork_length + 20])
    color(color_fastener)
    cylinder(d=steering_shaft_dia, h=head_tube_length + 100);

    translate([fork_rake, 0, fork_length + 25])
    color(color_fixed)
    pipe(30, 15.1, 10);

    // 5. STEERING BELL CRANK (Lower Pivot)
    translate([fork_rake, 0, fork_length + 15])
    rotate([0, 0, 90])
    steering_arm(steering_arm_len);
}
