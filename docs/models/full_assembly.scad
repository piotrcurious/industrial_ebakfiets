use <frame.scad>
use <front_fork.scad>
use <front_wheel_assy.scad>
use <steering_head.scad>

// Full 3D Assembly of Industrial E-Bakfiets
module full_assembly() {
    // 1. Frame
    frame();

    // 2. Steering Head (Integrated into frame head tube)
    translate([1800, 0, 100])
    rotate([0, -22, 0])
    steering_head();

    // 3. Front Fork (Attached to steering shaft)
    translate([1800 + sin(22)*300, 0, 100 - cos(22)*300])
    rotate([0, -22, 0])
    front_fork();

    // 4. Front Wheel (In fork dropouts)
    translate([1800 + sin(22)*625, 0, 100 - cos(22)*625])
    wheel_assy();

    // 5. Rear Wheel Placeholder (16")
    translate([0, 0, 0])
    color("black", 0.5)
    rotate([90,0,0])
    cylinder(d=410, h=50, center=true);
}

full_assembly();
