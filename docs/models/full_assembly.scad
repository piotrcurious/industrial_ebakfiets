include <master_dims.scad>
use <parts.scad>
use <front_fork.scad>
use <steering_head.scad>
use <frame.scad>
use <front_wheel_assy.scad>

// ---------------------------------------------------------
// FULL ASSEMBLY - NESTED SERIAL TRANSFORMATION CHAIN
// ROOT = FRONT TIRE CENTER (0,0,0)
// ---------------------------------------------------------

module full_bicycle_assembly() {

    // 1. ROOT: Front Wheel (Includes Hub & Axle)
    front_wheel_assy();

    // 2. FORK (Mated to Hub Axle center)
    // Transformation: Tilted back by (90 - head_angle) to define steering axis
    rotate([0, -(90-head_angle), 0]) {
        front_fork_assy();

        // 3. STEERING HEAD (Mated to Fork Steering Shaft)
        // The Fork Crown top is at Z = fork_length.
        // The Head Tube is centered on the shaft, starting 40mm above crown
        // (20mm crown thickness + 20mm clearance for lower bearing stack)
        translate([fork_rake, 0, fork_length + 40 + head_tube_length/2]) {
            steering_head_assy();

            // 4. FRAME (Mated to Steering Head Gusset Plate)
            // a) Re-orient back to horizontal (reverse head angle)
            // b) Move to the face of the Head Tube Gusset
            // c) Flip 180 around Z because frame module grows in +X but we want it to go BACKWARDS
            rotate([0, (90-head_angle), 0])
            translate([-(head_tube_od/2 + 10), 0, 0])
            rotate([0, 0, 180])
            frame_assy();
        }
    }

    // 5. REAR WHEEL (Standalone Reference)
    // Placed at wheelbase distance. Z adjusted for tire radius difference.
    translate([-wheelbase, 0, (rear_wheel_dia/2 - front_tire_od/2)])
    rotate([90, 0, 0])
    color("black", 0.7)
    cylinder(d=rear_wheel_dia, h=40, center=true);
}

// ---------------------------------------------------------
// GLOBAL POSITIONING
// ---------------------------------------------------------

// Move assembly so the front tire's contact patch is at Z=0
translate([0, 0, front_tire_od/2])
full_bicycle_assembly();

// GROUND PLANE (Preview only)
%translate([-wheelbase/2, 0, -0.5])
cube([wheelbase + 1000, 2500, 1], center=true);
