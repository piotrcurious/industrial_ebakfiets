include <master_dims.scad>
include <parts.scad>
use <front_fork.scad>
use <steering_head.scad>
use <frame.scad>
use <front_wheel_assy.scad>

// Internal constants for positioning
riser_length = 400;
riser_drop = 500;

// ---------------------------------------------------------
// FULL ASSEMBLY - NESTED SERIAL TRANSFORMATION CHAIN
// ROOT = FRONT TIRE CENTER (0,0,0)
// ---------------------------------------------------------

module full_bicycle_assembly() {

    // 1. ROOT: Front Wheel (Includes Hub & Axle)
    front_wheel_assy();

    // Torque Arm (Installed on axle)
    translate([0, front_hub_dropout/2 + 12, 0])
    rotate([90, 0, 180])
    torque_arm();

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
            rotate([0, (90-head_angle), 0])
            translate([-(head_tube_od/2 + 10), 0, 0])
            rotate([0, 0, 180])
            union() {
                frame_assy();

                // 7. DRIVETRAIN (At Bottom Bracket)
                // BB is at [bed_length - 150, 0, 85] relative to bed start
                // Bed start is riser_length from header
                translate([riser_length + bed_length - 150, 0, -riser_drop + 85])
                drivetrain_assy();

                // 8. SADDLE (At Seat Post Mast)
                translate([riser_length + bed_length + 200 - 300, 0, -riser_drop + 350])
                saddle();

                // 9. HANDLEBARS (At Steering Column Post)
                // Positioned on the frame riser/bridge
                translate([riser_length/2, 0, 0])
                handlebars();
            }
        }
    }

    // 5. REAR WHEEL ASSEMBLY
    // Placed at wheelbase distance. Z adjusted for tire radius difference.
    translate([-wheelbase, 0, (rear_wheel_dia/2 - front_tire_od/2)]) {
        rear_hub_motor_geared();
        rotate([90, 0, 0])
        color("black", 0.7)
        cylinder(d=rear_wheel_dia, h=40, center=true);
    }

    // 6. STEERING LINKAGE (Connecting Handlebars to Fork)
    // We model the steering rod connecting the two columns.
    color("dimgray")
    translate([fork_rake - 50, 40, fork_length + 20]) // Lower pivot on fork
    rotate([0, atan2(500, 1300), 0])
    cylinder(d=15, h=1400);
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
