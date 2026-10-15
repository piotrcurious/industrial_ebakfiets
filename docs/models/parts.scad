include <master_dims.scad>

$fn = 32;

// ── Color Palette ─────────────────────────────────────────────────────────────
color_frame    = [0.1, 0.2, 0.4];
color_subframe = [0.05, 0.1, 0.2];
color_moving   = [0.2, 0.4, 0.8];
color_fixed    = [0.3, 0.3, 0.3];
color_critical = [0.7, 0.1, 0.1];
color_fastener = [0.8, 0.8, 0.8];
color_tire     = [0.12, 0.12, 0.12];
color_brass    = [0.8, 0.6, 0.2];
color_wood     = [0.6, 0.4, 0.2];

// ── Piaggio Split-Rim Parameters ──────────────────────────────────────────────
// Outer Piaggio clamp bolt PCD (rim-half joining) located inside the 330mm rim bead
rim_clamp_pcd = 290;
rim_clamp_n   = 12;                      // Clamp bolt count (12× for even clamping load)


// ── Utility: Rounded Box ──────────────────────────────────────────────────────
module rounded_box(size, r, center=true) {
    if (r <= 0) {
        cube(size, center=center);
    } else {
        x = size[0]; y = size[1]; z = size[2];
        translate(center ? [0,0,0] : [x/2, y/2, z/2])
        hull() {
            for (ix=[-1,1], iy=[-1,1], iz=[-1,1])
                translate([ix*(x/2-r), iy*(y/2-r), iz*(z/2-r)])
                sphere(r=r, $fn=16);
        }
    }
}


// ── RIDER MANNEQUIN & LEG MOTION SCOPE ────────────────────────────────────────
// 50th percentile adult rider seated on saddle with feet on pedals.
// Origin = Saddle Top / Seating Reference Point (0,0,0)
// Handlebars are located at [bb_x_rel + 100, 0, 300] relative to saddle SRP
module rider_mannequin(pedal_angle=30, hb_offset=[-200, 0, 300]) {
    color([0.8, 0.6, 0.4, 0.85]) // Semi-transparent skin tone
    union() {
        // Torso & Pelvis
        translate([10, 0, 220])
        rotate([0, 10, 0]) { // Seated forward lean angle
            // Torso
            rounded_box([160, 320, 420], r=20, center=true);
            // Neck & Head
            translate([0, 0, 260]) {
                cylinder(d=100, h=70, center=true); // Neck
                translate([0, 0, 110]) sphere(d=180); // Head
            }
            // Shoulders & Arms to Handlebars (Grip target relative to shoulder)
            for(s=[-1,1]) translate([0, s*160, 160]) {
                sphere(d=75); // Shoulder
                target_grip = [hb_offset[0] - 10, s*200 - s*160, hb_offset[2] - 380];
                elbow_p = [target_grip[0]/2 - 80, s*40, target_grip[2]/2 - 100];

                hull() { // Upper arm
                    sphere(d=70);
                    translate(elbow_p) sphere(d=55); // Elbow
                }
                hull() { // Forearm
                    translate(elbow_p) sphere(d=55);
                    translate(target_grip) sphere(d=45); // Hand gripping handlebar
                }
            }
        }

        // Hips / Pelvis Base
        translate([0, 0, 20]) rounded_box([200, 260, 80], r=15, center=true);

        // Legs (Pivoting from hip to crank position)
        // BB is at [-100, 0, -265] relative to saddle top
        bb_rel_x = -100;
        bb_rel_z = -265;

        for(s=[-1, 1]) {
            side_angle = (s == 1) ? pedal_angle : pedal_angle + 180;
            p_x = bb_rel_x + crank_length * cos(side_angle);
            p_z = bb_rel_z + crank_length * sin(side_angle);

            hip_p = [0, s*100, -20];
            pedal_p = [p_x, s*110, p_z];

            // Knee placement via 2D IK (Thigh L=420, Calf L=400)
            dx = pedal_p[0] - hip_p[0];
            dz = pedal_p[2] - hip_p[2];
            dist = sqrt(dx*dx + dz*dz);
            // Knee bend forward and upward offset
            knee_x = hip_p[0] + dx/2 + 180 * (1 - dist/800);
            knee_z = hip_p[2] + dz/2 + 80 * (1 - dist/800);

            translate(hip_p) {
                sphere(d=85);
                hull() { // Thigh
                    sphere(d=80);
                    translate([knee_x - hip_p[0], 0, knee_z - hip_p[2]]) sphere(d=70);
                }
                hull() { // Calf
                    translate([knee_x - hip_p[0], 0, knee_z - hip_p[2]]) sphere(d=70);
                    translate([p_x - hip_p[0], s*10, p_z - hip_p[2] + 30]) sphere(d=60);
                }
                // Foot on pedal
                translate([p_x - hip_p[0] + 30, s*10, p_z - hip_p[2] + 15])
                rotate([0, -10, 0])
                rounded_box([160, 85, 35], r=5, center=true);
            }
        }
    }
}

// Full 360-degree leg pedaling motion envelope (Swept volume around bottom bracket)
module leg_motion_scope() {
    color([1.0, 0.2, 0.2, 0.25]) // Translucent red clearance zone
    rotate([90, 0, 0])
    union() {
        // Leg motion sweep disc around crank circle (Crank R = 170mm + leg/knee sweep)
        cylinder(r=crank_length + 180, h=360, center=true);

        // Thigh / Knee clearance cone from saddle to BB
        hull() {
            translate([0, 300, 0]) cylinder(r=150, h=300, center=true);
            cylinder(r=280, h=360, center=true);
        }
    }
}


// ── TYRE ──────────────────────────────────────────────────────────────────────
module car_tire_13in(alpha=1.0) {
    color(color_tire, alpha)
    rotate([90, 0, 0])
    union() {
        // Main carcass
        rotate_extrude($fn=64)
        translate([front_rim_dia/2, 0, 0])
        union() {
            // Bead positions at rim bead flanges Y = ±50mm
            bead_y = 50;
            for(s=[-1,1]) translate([0, s*bead_y, 0]) circle(d=22);

            hull() {
                for(s=[-1,1]) translate([0, s*bead_y, 0]) circle(d=22);
                translate([(front_tire_od - front_rim_dia)/2 - 20, 0, 0])
                    square([40, front_tire_width - 22], center=true);
            }
        }

        // Tread blocks
        for(a=[0:10:359]) rotate([0, 0, a])
            translate([front_tire_od/2, 0, 0])
            rounded_box([8, 14, front_tire_width - 20], r=3, center=true);
    }
}

// ── INNER TUBE ────────────────────────────────────────────────────────────────
module car_tube_13in(alpha=1.0) {
    color("red", alpha)
    rotate([90, 0, 0])
    rotate_extrude($fn=64)
    translate([front_rim_dia/2 + 30, 0, 0])
    circle(d=80);
}


// ── PIAGGIO SPLIT RIM ─────────────────────────────────────────────────────────
// Architecture:
//   ①  OUTER bolt circle (rim_clamp_pcd, rim_clamp_n bolts) — joins the two
//       rim halves at their mating flanges.  Undo ONLY these to split the rim
//       and remove the tyre/tube without a tyre machine.
//   ②  INNER bolt circle (rim_bolt_pcd, 6 bolts) — attaches the motor adapter
//       to the rim.  These are NOT disturbed during tyre service.
//
// Mated outboard of motor adapter plates at Y = ±(hub_width/2 + motor_flange_t)

module car_rim_half(thickness=10) {
    rotate([90, 0, 0])
    difference() {
        rotate_extrude($fn=64)
        union() {
            // Bead seat (flat surface extending from Y = 0 to Y = 40mm)
            translate([front_rim_dia/2 - 15, 0, 0]) square([20, 40]);

            // Bead flange (outer lip preventing bead walkoff at Y = 0 to 5mm)
            translate([front_rim_dia/2 + 5, 0, 0]) square([8, 5]);

            // ① Piaggio mating flange — outer disc clamping face-to-face
            translate([rim_clamp_pcd/2 - 25, 0, 0])
                square([front_rim_dia/2 + 8 - (rim_clamp_pcd/2 - 25), thickness]);

            // Transition web — slopes from mating flange to bead seat
            hull() {
                translate([front_rim_dia/2 - 25, thickness, 0]) square([15, 1]);
                translate([rim_clamp_pcd/2 - 22, 0, 0]) square([15, 1]);
            }

            // ② Hub adapter web — inner disc for motor-adapter bolt circle
            translate([rim_bolt_pcd/2 - 20, 0, 0])
                square([rim_clamp_pcd/2 - 26 - (rim_bolt_pcd/2 - 20), thickness]);
            // Thickened boss around hub bolt holes
            translate([rim_bolt_pcd/2 - 20, 0, 0])
                square([38, thickness + 4]);
        }

        // ① Outer Piaggio clamp holes — remove these 12 bolts to split the rim
        for(a=[0 : 360/rim_clamp_n : 359])
            rotate([0, 0, a]) translate([rim_clamp_pcd/2, 0, 0])
            cylinder(d=8.5, h=thickness * 3 + 2, center=true);

        // ② Inner hub adapter holes — 6× M8, NOT removed for tyre service
        for(a=[0:60:359])
            rotate([0, 0, a]) translate([rim_bolt_pcd/2, 0, 0])
            cylinder(d=8.5, h=100, center=true);
    }
}

module car_rim_13in_split() {
    adapter_offset = 76/2 + motor_flange_t; // Y = 38 + 12 = 50mm
    color(color_fastener) {
        translate([0, adapter_offset, 0]) car_rim_half(rim_flange_t);
        translate([0, -adapter_offset, 0]) mirror([0, 1, 0]) car_rim_half(rim_flange_t);
    }
}


// ── FASTENERS ─────────────────────────────────────────────────────────────────
module socket_head_bolt(d=8, l=50) {
    head_d = d * 1.5;
    head_h = d;
    color(color_fastener) {
        translate([0, 0, l/2]) {
            difference() {
                cylinder(d=head_d, h=head_h);
                translate([0, 0, head_h - d/2]) cylinder(d=d*0.8, h=d, $fn=6);
            }
        }
        cylinder(d=d, h=l, center=true);
        translate([0, 0, -l/2 - 6]) cylinder(d=d*1.6, h=6, $fn=6);
    }
}

// FIX: Two distinct bolt patterns matching the split rim architecture.
//   Clamp bolts (outer) — short, through rim flanges only.
//   Hub bolts  (inner) — long, through rim flanges + motor adapter flanges.
module rim_fastener_pattern(exploded=0) {
    clamp_bolt_len = 2 * rim_flange_t + 20;
    hub_bolt_len   = 2 * (rim_flange_t + motor_flange_t) + 30;

    // ① Piaggio clamp bolts (outer ring)
    for(a=[0 : 360/rim_clamp_n : 359])
        rotate([0, a, 0]) translate([rim_clamp_pcd/2, 0, 0]) rotate([90, 0, 0])
        translate([0, 0, exploded * 40])
        socket_head_bolt(8, clamp_bolt_len);

    // ② Hub adapter bolts (inner ring)
    for(a=[0:60:359])
        rotate([0, a, 0]) translate([rim_bolt_pcd/2, 0, 0]) rotate([90, 0, 0])
        translate([0, 0, exploded * 70])
        socket_head_bolt(8, hub_bolt_len);
}


// ── HUB MOTOR (DD, front) ────────────────────────────────────────────────────
module hub_motor_dd() {
    hub_width = 76; // Distance between spoke flanges (Magic Pie 5 Fatbike)

    color(color_fixed)
    rotate([90, 0, 0])
    union() {
        // Main stator housing
        cylinder(d=210, h=hub_width, center=true);
        // Spoke flange rings at hub ends
        for(s=[-1,1]) translate([0, 0, s*hub_width/2])
            cylinder(d=front_hub_flange_dia, h=4, center=true);
        // External Cooling Fins/Ribs on housing
        for(a=[0:15:359]) rotate([0, 0, a])
            translate([105, 0, 0])
            cube([8, 3, hub_width - 10], center=true);
    }

    // Motor adapter flanges (Mated outboard of hub motor flanges at Y = ±(38 + 6) = ±44mm)
    for(s=[-1,1]) translate([0, s*(hub_width/2 + motor_flange_t/2), 0])
        rotate([90, 0, 0]) color(color_brass) {
            difference() {
                cylinder(d=motor_flange_od, h=motor_flange_t, center=true);
                cylinder(d=105, h=motor_flange_t+1, center=true);
                for(a=[0:60:359])
                    rotate([0, 0, a]) translate([rim_bolt_pcd/2, 0, 0])
                    cylinder(d=8.5, h=30, center=true);
                for(a=[0:30:359])
                    rotate([0, 0, a]) translate([front_hub_flange_dia/2 - 10, 0, 0])
                    cylinder(d=5.5, h=30, center=true);
            }
        }

    // Axle with flats
    color("gray") rotate([90, 0, 0]) difference() {
        union() {
            cylinder(d=front_axle_dia, h=front_hub_dropout + 60, center=true);
            translate([0, 0, -front_hub_dropout/2 - 15]) cylinder(d=25, h=20, center=true);
        }
        for(s=[-1,1]) translate([0, 0, s*(front_hub_dropout/2 + 10)])
            for(side=[-1,1]) translate([side*10, 0, 0]) cube([10, 30, 30], center=true);
    }

    // Front Disc Rotor (LEFT side Y = -(front_hub_dropout/2 + 6), aligned with ISO caliper)
    translate([0, -(front_hub_dropout/2 + 6), 0])
    rotate([90, 0, 0]) color("silver") difference() {
        cylinder(d=203, h=2, center=true);
        for(a=[0:60:359])
            rotate([0, 0, a]) translate([22, 0, 0]) cylinder(d=5.5, h=10, center=true);
        cylinder(d=44, h=10, center=true);
    }
}


// ── TORQUE ARM ────────────────────────────────────────────────────────────────
module torque_arm(l=40) {
    color(color_fixed)
    difference() {
        hull() {
            cylinder(d=45, h=torque_arm_t);
            translate([l, 0, 0]) cylinder(d=25, h=torque_arm_t);
        }
        cube([10.2, 14.2, 20], center=true);
        translate([l, 0, 0]) cylinder(d=6.5, h=20, center=true);
    }
}


// ── DISC CALIPER ──────────────────────────────────────────────────────────────
module disc_caliper() {
    color(color_critical)
    difference() {
        union() {
            rounded_box([70, 45, 40], r=5, center=true);
            translate([0, 0, 25]) rounded_box([90, 15, 12], r=3, center=true);
        }
        translate([0, 0, -10]) cube([12, 50, 60], center=true);
        // ISO tab mounting holes (51mm spacing along Z, matching fork ISO tabs)
        for(s=[-1,1]) translate([0, 0, 25 + s*25.5]) rotate([0, 90, 0])
            cylinder(d=6.2, h=30, center=true);
    }
}


// ── STEERING ARM ─────────────────────────────────────────────────────────────
module steering_arm(l=steering_arm_len) {
    color(color_fixed)
    difference() {
        hull() {
            cylinder(d=40, h=10);
            translate([l, 0, 0]) cylinder(d=25, h=10);
        }
        cylinder(d=15.1, h=30, center=true);
        translate([l, 0, 0]) cylinder(d=10.2, h=30, center=true);
    }
}


// ── ROD END (M8 Heim joint) ───────────────────────────────────────────────────
module rod_end_m8() {
    color(color_fastener)
    union() {
        difference() {
            sphere(d=22, $fn=16);
            // Bore for the pivot pin
            rotate([0, 90, 0]) cylinder(d=14, h=30, center=true);
            // FIX: flattening cuts were at z=±12 but sphere radius=11 — they
            // fell entirely outside the geometry and removed nothing.
            // Moved to z=±8 so each cut removes a 6 mm cap, creating proper flats.
            translate([0, 0,  8]) cube([30, 30, 20], center=true);
            translate([0, 0, -8]) cube([30, 30, 20], center=true);
        }
        // Inner race / shank thread section
        color(color_brass) rotate([0, 90, 0]) difference() {
            cylinder(d=13.8, h=10, center=true);
            cylinder(d=8.1,  h=25, center=true);
        }
        translate([0, 0, -20]) cylinder(d=10, h=20);
    }
}


// ── BATTERY PACK ──────────────────────────────────────────────────────────────
module battery_pack() {
    color("darkslategray")
    rounded_box([battery_box_l, battery_box_w, battery_box_h], r=5, center=true);
    for(x=[-100,100]) translate([x, 0, 0]) color("black")
        difference() {
            cube([20, battery_box_w+5, battery_box_h+5], center=true);
            cube([battery_box_l+1, battery_box_w-2, battery_box_h-2], center=true);
        }
}


// ── MOTOR CONTROLLER ─────────────────────────────────────────────────────────
module motor_controller() {
    color("silver")
    difference() {
        rounded_box([controller_box_size, controller_box_size, controller_box_size/3], r=3, center=true);
        for(x=[-50:10:50])
            translate([x, 0, controller_box_size/6])
            cube([2, controller_box_size-10, 5], center=true);
    }
}


// ── PRIMITIVES ────────────────────────────────────────────────────────────────
module rect_tube(w, h, l, t=2.5) {
    difference() {
        cube([l, w, h], center=true);
        cube([l+1, w-2*t, h-2*t], center=true);
    }
}

module pipe(od, id, h) {
    difference() {
        cylinder(d=od, h=h, center=true);
        cylinder(d=id, h=h+0.1, center=true);
    }
}

module cable_guide() {
    color("black") rotate([0, 90, 0]) difference() {
        union() {
            cylinder(d=10, h=4, center=true);
            translate([0, -5, 0]) cube([4, 10, 4], center=true);
        }
        cylinder(d=6, h=6, center=true);
    }
}


// ── SADDLE ────────────────────────────────────────────────────────────────────
module saddle() {
    color(color_fastener) cylinder(d=seat_post_dia, h=300);
    translate([0, 0, 300]) {
        color(color_fixed)
        for(s=[-1,1]) translate([0, s*20, -10]) rotate([0, 90, 0])
            cylinder(d=6, h=200, center=true);
        color([0.15, 0.15, 0.15])
        hull() {
            translate([-100, 0,   5]) sphere(d=50, $fn=16);
            translate([   0, 0,  15]) sphere(d=80, $fn=16);
            translate([ 150, 0,   5]) sphere(d=25, $fn=16);
        }
    }
}


// ── HANDLEBARS ────────────────────────────────────────────────────────────────
module handlebars() {
    color(color_fixed) {
        cylinder(d=stem_dia+5, h=40);
        translate([30, 0, 50]) rotate([0, 60, 0]) cylinder(d=35, h=80, center=true);
    }
    translate([65, 0, 75]) {
        color("black") rotate([90, 0, 0]) {
            cylinder(d=31.8, h=120, center=true);
            for(s=[-1,1]) rotate([s*5, 0, 0]) translate([0, 0, s*180]) {
                cylinder(d=22.2, h=350, center=true);
                translate([0, 0, s*250]) color([0.1,0.1,0.1]) cylinder(d=30, h=120, center=true);
            }
        }
    }
}


// ── DRIVETRAIN (front chainring + cranks + pedals) ───────────────────────────
module drivetrain_assy() {
    // Chainring
    color("silver") rotate([90, 0, 0]) cylinder(d=180, h=2, center=true);

    // FIX: crank arm axial offset was in Z (vertical) — it must be in Y
    // (the axle / lateral direction) to place each arm on the correct side of
    // the bottom-bracket shell.
    for(a=[0, 180]) rotate([0, a, 0])
        translate([crank_length/2, (a==0 ? 10 : -10), 0]) {
            color(color_fixed)
                rounded_box([crank_length + 20, 12, 30], r=3, center=true);
            translate([crank_length/2, 0, 0])
                color([0.2, 0.2, 0.2])
                rounded_box([80, 90, 20], r=4, center=true);
        }
}


// ── REAR GEARED HUB MOTOR ────────────────────────────────────────────────────
module rear_hub_motor_geared() {
    color(color_fixed) rotate([90, 0, 0]) cylinder(d=150, h=135, center=true);
    color("black")    rotate([90, 0, 0]) cylinder(d=14,  h=200, center=true);

    // Rear Disc Rotor (LEFT side Y = -(rear_dropout_spacing/2 + 6))
    translate([0, -(rear_dropout_spacing/2 + 6), 0])
    rotate([90, 0, 0]) color("silver") difference() {
        cylinder(d=203, h=2, center=true);
        for(a=[0:60:359])
            rotate([0, 0, a]) translate([22, 0, 0]) cylinder(d=5.5, h=10, center=true);
        cylinder(d=44, h=10, center=true);
    }
}


// ── BIPOD KICKSTAND ───────────────────────────────────────────────────────────
module bipod_kickstand(deployed=false) {
    angle = deployed ? 25 : -10;
    color(color_subframe)
    union() {
        rotate([90, 0, 0]) pipe(40, 12, 120);   // Cross pivot tube

        for(s=[-1,1]) translate([0, s*45, 0])
            rotate([angle, 0, s*8])
            union() {
                // FIX: rect_tube long axis is X (cube([l,w,h]) = cube([len,25,25])).
                // Legs hang in the -Z direction, so the tube must be reoriented.
                // rotate([0,90,0]) maps the X long-axis onto Z.
                translate([0, 0, -kickstand_leg_len/2])
                    rotate([0, 90, 0])
                    rect_tube(25, 25, kickstand_leg_len);

                // Foot pad
                translate([0, 0, -kickstand_leg_len])
                    rounded_box([60, 80, 12], r=4, center=true);
            }
    }
}


// ── CARGO BOX ────────────────────────────────────────────────────────────────
module cargo_box_assy() {
    // Floor
    color(color_wood)
    translate([bed_length/2, 0, box_wall_t/2])
    cube([bed_length, bed_width, box_wall_t], center=true);

    color("ghostwhite", 0.8) {
        // Front & rear walls
        for(x=[box_wall_t/2, bed_length - box_wall_t/2])
            translate([x, 0, box_height/2 + box_wall_t])
            cube([box_wall_t, bed_width, box_height], center=true);
        // Side walls
        for(s=[-1,1])
            translate([bed_length/2, s*(bed_width/2 - box_wall_t/2), box_height/2 + box_wall_t])
            cube([bed_length, box_wall_t, box_height], center=true);
    }
}


// ── MUDGUARD BLADE ────────────────────────────────────────────────────────────
module mudguard(dia, width, clearance, angle_span=180) {
    total_r = dia/2 + clearance;

    color([0.1, 0.1, 0.1])
    rotate([90, 0, 0])
    rotate([0, 0, 30])
    rotate_extrude(angle=angle_span)
    translate([total_r, 0, 0])
    difference() {
        circle(d=width,   $fn=32);
        // FIX: inner circle was (d=width-3) → wall = 1.5 mm, too thin for a
        // structural blade mudguard. Changed to (d=width-6) → 3 mm wall.
        circle(d=width-6, $fn=32);
        // Remove inner (wheel-facing) half to create open blade cross-section
        translate([-width/2, 0, 0]) square([width, width], center=true);
    }
}


// ── MUDGUARD CROWN BRACKET ────────────────────────────────────────────────────
module mudguard_crown_bracket() {
    // Offset vector from mudguard top [0,0,front_tire_od/2 + mudguard_clearance]
    // to fork crown [fork_rake, 0, fork_length]
    dz = fork_length - (front_tire_od/2 + 25);
    color(color_fixed)
    difference() {
        union() {
            translate([0, 0, -2]) rounded_box([60, 50, 4], r=5, center=true);
            hull() {
                translate([0, 0, 0])         sphere(d=10);
                translate([fork_rake, 0, dz]) sphere(d=14);
            }
            translate([fork_rake, 0, dz]) rotate([0, 90 - head_angle, 0])
            rounded_box([60, 80, 8], r=5, center=true);
        }
        for(y=[-18, 18])
            translate([10, y, -2]) cylinder(d=5.5, h=15, center=true);
        translate([fork_rake, 0, dz]) rotate([0, 90 - head_angle, 0])
        for(y=[-12, 12])
            translate([0, y, 0]) cylinder(d=6.5, h=40, center=true);
    }
}


// ── MUDGUARD STAY ─────────────────────────────────────────────────────────────
module mudguard_stay(length, angle) {
    color(color_fixed)
    union() {
        hull() {
            sphere(d=8);
            rotate([0, -angle, 0]) translate([length, 0, 0]) sphere(d=6);
        }
        // Eyelet to dropout (hole along Y axis)
        difference() {
            sphere(d=14);
            rotate([90, 0, 0]) cylinder(d=5.5, h=25, center=true);
        }
    }
}
