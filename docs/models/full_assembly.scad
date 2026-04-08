include <master_dims.scad>
use <parts.scad>
use <front_fork.scad>
use <steering_head.scad>
use <frame.scad>

// ---------------------------------------------------------
// FULL ASSEMBLY - Rooted at FRONT TIRE CENTER (0,0,0)
// ---------------------------------------------------------

module full_bicycle_assembly() {

    // 1. THE ROOT ANCHOR: Front Tire & Hub
    car_tire_13in();
    front_hub_motor();

    // 2. FORK: Connected to Hub Axle (0,0,0)
    // Tilted back to set the steering axis angle.
    rotate([0, -(90-head_angle), 0])
    front_fork_assy();

    // 3. STEERING HEAD: Mounted on Fork Steering Shaft
    // Shaft starts at Fork local [fork_rake, 0, fork_length + 40]
    // HT center is at z=0 in steering_head local space.

    rotate([0, -(90-head_angle), 0])
    translate([fork_rake, 0, fork_length + 40 + head_tube_length/2])
    steering_head_assy();

    // 4. FRAME: Connected to Steering Head Gusset
    // We are at the HT center. Rotate back to level.
    // The HT gusset face is at - (head_tube_od/2 + 20) in steering_head X.
    // Since we rotate the bike to point BACKWARDS, we flip the frame.

    rotate([0, -(90-head_angle), 0])
    translate([fork_rake, 0, fork_length + 40 + head_tube_length/2])
    rotate([0, (90-head_angle), 0])
    // The gusset face is roughly 40mm from HT center.
    translate([-41, 0, - (fork_length + 40 + head_tube_length/2) + ground_clearance])
    rotate([0, 0, 180])
    frame_assy();

    // 5. REAR WHEEL
    // Relative to the front axle center (0,0,0).
    translate([-wheelbase, 0, (rear_wheel_dia/2 - front_tire_od/2)])
    rotate([90, 0, 0])
    color("black", 0.8)
    cylinder(d=rear_wheel_dia, h=40, center=true);
}

// Global Ground Alignment
translate([0, 0, front_tire_od/2])
full_bicycle_assembly();

// Ground Plane
%translate([-wheelbase/2, 0, -0.5])
cube([wheelbase + 1000, 2000, 1], center=true);
