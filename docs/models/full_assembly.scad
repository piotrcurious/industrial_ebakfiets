use <parts.scad>
use <frame.scad>
use <front_fork.scad>
use <front_wheel_assy.scad>
use <steering_head.scad>

// Full 3D Assembly of Industrial E-Bakfiets
module full_assembly() {
    // 1. MAIN FRAME
    frame();

    // 2. STEERING HEAD (Integrated into frame head tube)
    translate([2100, 0, 100])
    rotate([0, -22, 0])
    steering_head();

    // 3. FRONT FORK (Mounted on steering shaft)
    // Offset relative to head tube center
    translate([2100 + sin(22)*150, 0, 100 - cos(22)*150])
    rotate([0, -22, 0])
    front_fork();

    // 4. FRONT WHEEL ASSEMBLY (In fork dropouts)
    // Fork axle is approx 350mm from crown
    translate([2100 + sin(22)*500, 0, 100 - cos(22)*500])
    wheel_assy();

    // 5. REAR WHEEL (16-inch Moped)
    translate([0, 0, 0])
    rotate([90,0,0])
    moped_wheel_16in();

    // 6. DECENTRALIZED ESC HOUSINGS
    color("blue", 0.5) {
        translate([2100, 0, 200]) cube([250, 180, 100], center=true); // Front
        translate([800, 0, 100]) cube([250, 180, 100], center=true);  // Rear
    }

    // 7. CARGO BOX (Internal 1210x810)
    color("tan", 0.4)
    translate([1505, 0, 100])
    difference() {
        cube([1210, 810, 200], center=true);
        cube([1186, 786, 210], center=true); // 12mm walls
    }
}

full_assembly();
