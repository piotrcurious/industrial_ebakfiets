include <master_dims.scad>
use <frame.scad>
use <front_fork.scad>
use <steering_head.scad>

module wheel_assy() {
    color([0.2, 0.2, 0.2])
    rotate([90,0,0])
    rotate_extrude($fn=64)
    translate([front_wheel_dia/2 - front_tire_width/2, 0, 0])
    circle(d=front_tire_width);
}

module full_assembly() {
    // 1. Frame
    frame();

    // 2. Rear Wheel (16")
    translate([0, 0, 0])
    color("black", 0.5)
    rotate([90,0,0])
    cylinder(d=rear_wheel_dia, h=50, center=true);

    // 3. Steering Head (In Frame)
    translate([spar_length, 0, 150])
    rotate([0, 90-head_angle, 0])
    steering_head();

    // 4. Fork (Mated)
    // Pivot at Head Tube center
    translate([spar_length, 0, 150])
    rotate([0, 90-head_angle, 0])
    translate([0, 0, -100]) // Position crown at bottom of HT
    front_fork();

    // 5. Front Wheel
    // Position at fork axle (rake + length)
    translate([spar_length, 0, 150])
    rotate([0, 90-head_angle, 0])
    translate([fork_rake, 0, -fork_length-100])
    rotate([0, -(90-head_angle), 0]) // Keep wheel vertical
    wheel_assy();
}

full_assembly();
