include <master_dims.scad>
use <parts.scad>
use <frame.scad>
use <front_fork.scad>
use <steering_head.scad>

module full_assembly() {
    // 1. FRAME (Rear axle at 0,0,0)
    frame_assy();

    // 2. STEERING HEAD
    translate([spar_length, 0, 150])
    rotate([0, 90-head_angle, 0])
    steering_head_assy();

    // 3. FORK (Mated to steering head shaft)
    translate([spar_length, 0, 150])
    rotate([0, 90-head_angle, 0])
    translate([0, 0, -100]) // Match crown to HT base
    front_fork_assy();

    // 4. FRONT WHEEL
    // Axle is at (rake, 0, -fork_length) relative to crown
    translate([spar_length, 0, 150])
    rotate([0, 90-head_angle, 0])
    translate([fork_rake, 0, -100 - fork_length])
    rotate([0, -(90-head_angle), 0]) // Vertical wheel
    car_tire_13in();

    // 5. REAR WHEEL
    translate([0, 0, 0])
    rotate([90,0,0])
    color("black", 0.5)
    cylinder(d=rear_wheel_dia, h=50, center=true);
}

full_assembly();
