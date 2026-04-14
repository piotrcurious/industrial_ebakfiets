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
    mudguard(front_tire_od, mudguard_width_front, 20, 160);

    // Torque Arm (Installed on axle)
    translate([0, front_hub_dropout/2 + 12, 0])
    rotate([90, 0, 180])
    torque_arm();

    // 2. FORK (Mated to Hub Axle center)
    alpha = 90 - head_angle;
    rotate([0, -alpha, 0]) {
        front_fork_assy();

        // Disc Caliper (Mated to Fork Tabs)
        translate([0, -front_hub_dropout/2 - 20, brake_mount_height])
        rotate([0, 0, 0])
        disc_caliper();

        // 3. STEERING HEAD (Mated to Fork Steering Shaft)
        translate([fork_rake, 0, fork_length + 40 + head_tube_length/2]) {
            steering_head_assy();

            // 4. FRAME (Mated to Steering Head Gusset Plate)
            rotate([0, alpha, 0])
            translate([-(head_tube_od/2 + 10), 0, 0])
            rotate([0, 0, 180])
            union() {
                frame_assy();

                // CARGO BOX (Mounted on top of spars)
                translate([riser_length, 0, -riser_drop + main_spar_size/2])
                cargo_box_assy();

                // DRIVETRAIN (At Bottom Bracket)
                translate([riser_length + bed_length - 200, 0, -riser_drop + 85])
                drivetrain_assy();

                // SADDLE (At Seat Post Mast)
                translate([riser_length + bed_length + 150 - 400, 0, -riser_drop + 350])
                saddle();

                // HANDLEBARS (At Steering Column Post)
                translate([riser_length/2, 0, 0]) {
                    handlebars();
                    // Upper Steering Bell Crank
                    translate([0, 0, -50])
                    rotate([0, 0, -90])
                    steering_arm(120);
                }

                // KICKSTAND (Under Bed)
                translate([riser_length + 100, 0, -riser_drop + 10])
                bipod_kickstand(deployed=true);

                // ELECTRONICS (Integrated under cargo bed)
                for(s=[-1, 1]) translate([riser_length + 500, s * (bed_width/2 - 100), -riser_drop - 50])
                battery_pack();

                translate([riser_length + 150, 0, -riser_drop - 30])
                motor_controller();
            }
        }
    }

    // 5. REAR WHEEL ASSEMBLY
    // Calculation of Global Coordinates for the Rear Axle
    p_ht_global_x = fork_rake * cos(alpha) - (fork_length + 40 + head_tube_length/2) * sin(alpha);
    p_ht_global_z = fork_rake * sin(alpha) + (fork_length + 40 + head_tube_length/2) * cos(alpha);

    frame_origin_x = p_ht_global_x - (head_tube_od/2 + 10);
    frame_origin_z = p_ht_global_z;

    rear_extension = 150;
    dropout_z_offset = -50;

    rear_x = frame_origin_x - (riser_length + bed_length + rear_extension);
    rear_z = frame_origin_z - riser_drop + dropout_z_offset;

    translate([rear_x, 0, rear_z]) {
        rear_hub_motor_geared();
        rotate([90, 0, 0])
        color("black", 0.7)
        cylinder(d=rear_wheel_dia, h=40, center=true);

        // Rear Mudguard
        rotate([0, 0, 180])
        mudguard(rear_wheel_dia, mudguard_width_rear, 30, 180);
    }

    // 6. STEERING LINKAGE (Dual Bell Crank System)
    steering_arm_y_offset = 120;

    // Point A: Lower Bell Crank Tip (Fork-mounted)
    p_a_fork_local_tip = [fork_rake, steering_arm_y_offset, fork_length + 15 + 5];
    p_a = [
        p_a_fork_local_tip[0] * cos(alpha) - p_a_fork_local_tip[2] * sin(alpha),
        p_a_fork_local_tip[1],
        p_a_fork_local_tip[0] * sin(alpha) + p_a_fork_local_tip[2] * cos(alpha)
    ];

    // Point B: Upper Bell Crank Tip (Handlebar-mounted)
    p_b_frame = [riser_length/2, steering_arm_y_offset, -45];

    // Transform p_b from frame to global
    p_b_1 = [-p_b_frame[0], -p_b_frame[1], p_b_frame[2]];
    p_b_2 = [p_b_1[0] - (head_tube_od/2 + 10), p_b_1[1], p_b_1[2]];
    p_b_3 = [
        p_b_2[0] * cos(alpha) + p_b_2[2] * sin(alpha),
        p_b_2[1],
        -p_b_2[0] * sin(alpha) + p_b_2[2] * cos(alpha)
    ];
    p_b_4 = [p_b_3[0] + fork_rake, p_b_3[1], p_b_3[2] + (fork_length + 40 + head_tube_length/2)];
    p_b = [
        p_b_4[0] * cos(alpha) - p_b_4[2] * sin(alpha),
        p_b_4[1],
        p_b_4[0] * sin(alpha) + p_b_4[2] * cos(alpha)
    ];

    // Draw the rod connecting p_a and p_b
    color("dimgray") {
        translate(p_a) rod_end_m8();
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

// GROUND PLANE
%translate([-750, 0, -0.5])
cube([3000, 1500, 1], center=true);
