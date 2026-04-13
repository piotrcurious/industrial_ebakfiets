// master_dims.scad - Central dimensions for Industrial E-Bakfiets

// Standard Units: mm

// 1. FRONT TIRE (The Anchor)
front_tire_od = 548;
front_tire_width = 155;
front_rim_dia = 330;

// 2. FRONT HUB / MOTOR
front_hub_dropout = 175;
front_hub_flange_dia = 180;
front_axle_dia = 14;

// 3. FRONT FORK
fork_inner_spacing = 185;
fork_blade_width = 30;
fork_crown_width = 250;
fork_length = 360;
fork_rake = 45;

// 4. STEERING HEAD
head_angle = 68;
steering_shaft_dia = 15;
bearing_od = 35;
bearing_h = 11;
head_tube_od = 42.16;
head_tube_id = 35.05;
head_tube_length = 200;

// 5. FRAME
box_wall_t = 12; // Moved up to satisfy dependencies
bed_internal_width = 810;
bed_internal_length = 1350; // Slightly longer for stability
bed_width = bed_internal_width + 2 * box_wall_t;  // Total width
bed_length = bed_internal_length + 2 * box_wall_t; // Total length
main_spar_size = 40;
ground_clearance = 150;
wheelbase = 1950;

// 6. REAR END
rear_wheel_dia = 410;
rear_dropout_spacing = 135;
bb_height = 285;
bb_offset_x = 450;

// 7. CARGO BOX
box_height = 600;
etrack_width = 50;
steel_angle_size = 25;

// 8. STABILIZERS
stab_size = 35;
stab_deploy_len = 250;

// 9. FRAME RISER (Gooseneck)
riser_drop = 500;
riser_length = 450;

// 10. COMPONENTS & HARDWARE
torque_arm_t = 6;
rim_bolt_pcd = 270; // PCD for rim to motor bolts
rim_sandwich_t = 16; // 8mm + 8mm flanges
motor_flange_t = 10;
rim_flange_t = 8;
motor_flange_od = 290;
tube_wall_t = 2.5;

// 11. BRAKES & STEERING LINKAGE
brake_rotor_dia = 203;
brake_caliper_offset = 51; // IS standard offset
brake_mount_height = 80;
steering_arm_len = 120;
steering_rod_dia = 15;

// 12. DRIVETRAIN & COMFORT
crank_length = 170;
seat_post_dia = 31.6;
handlebar_dia = 22.2;
stem_dia = 28.6;

// 13. ELECTRONICS
battery_box_w = 200;
battery_box_h = 100;
battery_box_l = 300;
controller_box_size = 120;

// 14. UTILITY & ACCESSORIES
kickstand_leg_len = 350;
kickstand_width = 400;
mudguard_clearance = 20; // Distance from tire
mudguard_width_front = 170;
mudguard_width_rear = 60;

// 15. ASSEMBLY SPECIFIC (Offsets and Extensions)
rear_extension = 150;
dropout_z_offset = -50;
steering_arm_y_offset = 120;
