include <parts.scad>
use <frame.scad>
use <front_fork.scad>
use <front_wheel_assy.scad>
use <steering_head.scad>

module full_assembly() {
    // 1. Frame (Origin at rear axle)
    frame();

    // 2. Rear Wheel (16")
    rotate([90,0,0]) moped_wheel_16in();

    // 3. Steering Head (In Frame Head Tube)
    translate([2100, 0, 150])
    rotate([0, 22, 0])
    steering_head();

    // 4. Fork (Mated to Steering Shaft)
    // Shaft center to crown is matched
    translate([2100, 0, 150])
    rotate([0, 22, 0])
    translate([0, 0, -150]) // Move crown to shaft bottom
    front_fork();

    // 5. Front Wheel
    translate([2100, 0, 150])
    rotate([0, 22, 0])
    translate([0, 0, -500]) // Fork crown (0) to axle (-350) + tire rad (~150)
    wheel_assy();

    // 6. Cargo Box
    color("tan", 0.4)
    translate([1505, 0, 120]) cube([1210, 810, 200], center=true);
}

full_assembly();
