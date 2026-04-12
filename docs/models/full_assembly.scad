include <master_dims.scad>
include <parts.scad>
include <front_fork.scad>
include <steering_head.scad>
include <frame.scad>
include <front_wheel_assy.scad>

// ---------------------------------------------------------
// FULL ASSEMBLY - NESTED SERIAL TRANSFORMATION CHAIN
// ROOT = FRONT TIRE CENTER (0,0,0)
// ---------------------------------------------------------

module full_bicycle_assembly() {

    // 1. ROOT: Front Wheel (Includes Hub & Axle)
    front_wheel_assy();

    // Front Mudguard
    rotate([0, 0, 0])
    mudguard(front_tire_od, mudguard_width_front, 20, 160);

    // Torque Arm (Installed on axle)
    translate([0, front_hub_dropout/2 + 12, 0])
    rotate([90, 0, 180])
    torque_arm();

    // 2. FORK (Mated to Hub Axle center)
    // Transformation: Tilted back by (90 - head_angle) to define steering axis
    rotate([0, -(90-head_angle), 0]) {
        front_fork_assy();

        // Disc Caliper (Mated to Fork Tabs)
        translate([0, -front_hub_dropout/2 - 20, brake_mount_height])
        rotate([0, 0, 0])
        disc_caliper();

        // 3. STEERING HEAD (Mated to Fork Steering Shaft)
        translate([fork_rake, 0, fork_length + 40 + head_tube_length/2]) {
            steering_head_assy();

            // 4. FRAME (Mated to Steering Head Gusset Plate)
            rotate([0, (90-head_angle), 0])
            translate([-(head_tube_od/2 + 10), 0, 0])
            rotate([0, 0, 180])
            union() {
                frame_assy();

                // 12. CARGO BOX
                translate([riser_length, 0, -riser_drop])
                cargo_box_assy();

                // 7. DRIVETRAIN (At Bottom Bracket)
                translate([riser_length + bed_length - 150, 0, -riser_drop + 85])
                drivetrain_assy();

                // 8. SADDLE (At Seat Post Mast)
                translate([riser_length + bed_length + 200 - 300, 0, -riser_drop + 350])
                saddle();

                // 9. HANDLEBARS (At Steering Column Post)
                translate([riser_length/2, 0, 0]) {
                    handlebars();
                    // Upper Steering Bell Crank (Pointed to Left side)
                    // Frame is rotated 180, so -90 in frame coords = +90 globally
                    translate([0, 0, -50])
                    rotate([0, 0, -90])
                    steering_arm();
                }

                // 10. KICKSTAND (Under Bed)
                translate([riser_length + 100, 0, -riser_drop + 10])
                bipod_kickstand(deployed=true);

                // 11. ELECTRONICS (Mounted to Riser/Frame Junction)
                // Battery Packs (Dual)
                for(s=[-1, 1]) translate([riser_length + 200, s * 150, -riser_drop + 60])
                battery_pack();

                // Controllers
                translate([riser_length + 100, 0, -riser_drop + 100])
                motor_controller();
            }
        }
    }

    // 5. REAR WHEEL ASSEMBLY
    translate([-wheelbase, 0, (rear_wheel_dia/2 - front_tire_od/2)]) {
        rear_hub_motor_geared();
        rotate([90, 0, 0])
        color("black", 0.7)
        cylinder(d=rear_wheel_dia, h=40, center=true);

        // Rear Mudguard
        rotate([0, 0, 180])
        mudguard(rear_wheel_dia, mudguard_width_rear, 30, 180);
    }

    // 6. STEERING LINKAGE (Dual Bell Crank System)
    // Connecting Lower (Fork) arm to Upper (Handlebar) arm

    // Coordinates relative to Root (Front Tire Center)

    // Point A: Lower Bell Crank Tip (Fork-mounted)
    // Fork is rotated by -alpha = -(90-head_angle).
    alpha = 90 - head_angle;

    // Exact kinematic mapping for p_a:
    p_a_fork_local_origin = [fork_rake, 0, fork_length + 15];
    p_a_fork_local_tip = [fork_rake, steering_arm_len, fork_length + 15 + 5];

    p_a = [
        p_a_fork_local_tip[0] * cos(alpha) - p_a_fork_local_tip[2] * sin(alpha),
        p_a_fork_local_tip[1],
        p_a_fork_local_tip[0] * sin(alpha) + p_a_fork_local_tip[2] * cos(alpha)
    ];

    // Point B: Upper Bell Crank Tip (Handlebar-mounted)
    // Path: Axle -> rotate(-alpha) -> translate(p_ht_rel_axle) -> rotate(alpha)
    //            -> translate(-(head_tube_od/2+10)) -> rotate_z(180) -> Frame

    p_ht_rel_axle = [fork_rake, 0, fork_length + 40 + head_tube_length/2];

    // Point B in Frame coords:
    p_b_frame = [riser_length/2, steering_arm_len, -45]; // After rotate_z(-90) in frame

    // 1. rotate_z(180):
    p_b_1 = [-p_b_frame[0], -p_b_frame[1], p_b_frame[2]];
    // 2. translate(-(head_tube_od/2 + 10)):
    p_b_2 = [p_b_1[0] - (head_tube_od/2 + 10), p_b_1[1], p_b_1[2]];
    // 3. rotate_y(alpha):
    p_b_3 = [
        p_b_2[0] * cos(alpha) + p_b_2[2] * sin(alpha),
        p_b_2[1],
        -p_b_2[0] * sin(alpha) + p_b_2[2] * cos(alpha)
    ];
    // 4. translate(p_ht_rel_axle):
    p_b_4 = [p_b_3[0] + p_ht_rel_axle[0], p_b_3[1], p_b_3[2] + p_ht_rel_axle[2]];
    // 5. rotate_y(-alpha):
    p_b = [
        p_b_4[0] * cos(alpha) - p_b_4[2] * sin(alpha),
        p_b_4[1],
        p_b_4[0] * sin(alpha) + p_b_4[2] * cos(alpha)
    ];

    // Draw the rod connecting p_a and p_b
    color("dimgray") {
        translate(p_a) rod_end_m8();

        // Use hull between two spheres for perfect visual alignment of the rod
        hull() {
            translate(p_a) sphere(d=steering_rod_dia);
            translate(p_b) sphere(d=steering_rod_dia);
        }

        translate(p_b) rotate([0, 180, 0]) rod_end_m8();
    }
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
