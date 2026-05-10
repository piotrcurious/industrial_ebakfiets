include <master_dims.scad>

$fn = 32;
eps = 0.01;

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
rim_clamp_pcd = 290;   // Inner clamp bolt PCD (inside 330mm bead)
rim_clamp_n   = 10;


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


// ── TYRE ──────────────────────────────────────────────────────────────────────
module car_tire_13in(alpha=1.0) {
    color(color_tire, alpha)
    rotate([90, 0, 0])
    union() {
        // Main carcass
        rotate_extrude($fn=64)
        hull() {
            // Beads (resting on rim R=165)
            for(s=[-1,1]) translate([165 + 10, s*50, 0]) circle(d=20);
            // Sidewall bulge
            for(s=[-1,1]) translate([165 + 60, s*70, 0]) circle(d=30);
            // Tread area
            translate([front_tire_od/2 - 20, 0, 0])
                square([40, front_tire_width - 40], center=true);
        }

        // Tread blocks
        for(a=[0:10:359]) rotate([0, 0, a])
            translate([front_tire_od/2, 0, 0])
            rounded_box([10, 14, front_tire_width - 20], r=3, center=true);
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
module car_rim_half(thickness=10) {
    adapter_offset = motor_flange_t + 30;

    rotate([90, 0, 0])
    difference() {
        rotate_extrude($fn=64)
        union() {
            // 1. Central mating flange (joins at Y=0)
            // PCD is 290, so R=145. Flange extends from R=120 to R=160
            translate([120, 0, 0]) square([40, thickness]);

            // 2. Hub adapter interface (at Y=adapter_offset)
            // PCD is 260, so R=130.
            translate([110, adapter_offset, 0]) square([40, thickness]);

            // 3. Connecting web
            hull() {
                translate([120, thickness, 0]) square([10, eps]);
                translate([120, adapter_offset, 0]) square([10, eps]);
            }

            // 4. Rim Barrel and Bead Seat
            // Transition from mating flange to bead seat (R=165)
            hull() {
                translate([150, 0, 0]) square([5, thickness]);
                translate([165, 40, 0]) square([5, thickness]);
            }
            // Bead Seat Flat (starts at Y=40, goes to Y=70)
            translate([165, 40, 0]) square([5, 30]);
            // Rim Outer Lip (at R=165 to R=185)
            translate([165, 70, 0]) square([20, 5]);
        }

        // ① Outer Piaggio clamp holes
        for(a=[0 : 360/rim_clamp_n : 359])
            rotate([0, 0, a]) translate([rim_clamp_pcd/2, 0, 0])
            cylinder(d=8.5, h=100, center=true);

        // ② Inner hub adapter holes
        for(a=[0:60:359])
            rotate([0, 0, a]) translate([rim_bolt_pcd/2, 0, 0])
            cylinder(d=8.5, h=100, center=true);
    }
}

module car_rim_13in_split() {
    color(color_fastener) {
        // Offset slightly to prevent Z-fighting at Y=0 if they weren't same color
        translate([0, eps, 0]) car_rim_half(rim_flange_t);
        mirror([0, 1, 0]) translate([0, eps, 0]) car_rim_half(rim_flange_t);
    }
}


// ── FASTENERS ─────────────────────────────────────────────────────────────────
module socket_head_bolt(d=8, l=50) {
    head_d = d * 1.5;
    head_h = d;
    color(color_fastener) {
        translate([0, 0, l/2 - eps]) {
            difference() {
                cylinder(d=head_d, h=head_h + eps);
                translate([0, 0, head_h - d/2 + eps]) cylinder(d=d*0.8, h=d, $fn=6);
            }
        }
        cylinder(d=d, h=l + eps, center=true);
        translate([0, 0, -l/2 - 6]) cylinder(d=d*1.6, h=6, $fn=6);
    }
}

module rim_fastener_pattern(exploded=0) {
    clamp_bolt_len = 2 * rim_flange_t + 15;
    hub_bolt_len   = 140; // Documentation standard M8x140mm
    adapter_offset = motor_flange_t + 30;

    // ① Piaggio clamp bolts (outer ring) - join halves at Y=0
    for(a=[0 : 360/rim_clamp_n : 359])
        rotate([0, a, 0]) translate([rim_clamp_pcd/2, 0, 0]) rotate([90, 0, 0])
        translate([0, 0, exploded * 80])
        socket_head_bolt(8, clamp_bolt_len);

    // ② Hub adapter bolts (inner ring) - join rim to adapter
    for(a=[0:60:359])
        rotate([0, a, 0]) translate([rim_bolt_pcd/2, 0, 0]) rotate([90, 0, 0])
        translate([0, 0, exploded * 120])
        socket_head_bolt(8, hub_bolt_len);
}


// ── HUB MOTOR (DD, front) ────────────────────────────────────────────────────
module hub_motor_dd() {
    hub_width = 80; // Internal hub body width
    hub_flange_y = 30; // Flange position from center

    color(color_fixed)
    rotate([90, 0, 0])
    union() {
        cylinder(d=310, h=hub_width, center=true);
        // Cooling fins
        for(a=[0:15:359]) rotate([0, 0, a])
            translate([155, 0, 0])
            cube([10, 4, hub_width - 5], center=true);
    }

    // Motor adapter flanges (brass)
    // Sits on hub flanges and provides rim mounting points
    for(s=[-1,1]) translate([0, s*(hub_flange_y + motor_flange_t/2 + eps), 0])
        rotate([90, 0, 0]) color(color_brass) {
            difference() {
                cylinder(d=motor_flange_od, h=motor_flange_t, center=true);
                cylinder(d=100, h=motor_flange_t+2, center=true);
                // Bolt holes for rim (rim_bolt_pcd)
                for(a=[0:60:359])
                    rotate([0, 0, a]) translate([rim_bolt_pcd/2, 0, 0])
                    cylinder(d=8.5, h=motor_flange_t+2, center=true);
                // Bolt holes for hub (spoke holes)
                for(a=[0:30:359])
                    rotate([0, 0, a]) translate([front_hub_flange_dia/2 - 10, 0, 0])
                    cylinder(d=5.5, h=motor_flange_t+2, center=true);
            }
        }

    // Axle
    color("gray") rotate([90, 0, 0]) difference() {
        union() {
            cylinder(d=front_axle_dia, h=front_hub_dropout + 60, center=true);
            translate([0, 0, -front_hub_dropout/2 - 15]) cylinder(d=25, h=20, center=true);
        }
        for(s=[-1,1]) translate([0, 0, s*(front_hub_dropout/2 + 10)])
            for(side=[-1,1]) translate([side*10, 0, 0]) cube([10, 30, 30], center=true);
    }

    // Disc rotor
    translate([0, front_hub_dropout/2 + 15, 0])
    rotate([90, 0, 0]) color("silver") difference() {
        cylinder(d=203, h=2, center=true);
        for(a=[0:60:359])
            rotate([0, 0, a]) translate([22, 0, 0]) cylinder(d=5.5, h=10, center=true);
        cylinder(d=44, h=10, center=true);
    }
}


// ── TORQUE ARM ────────────────────────────────────────────────────────────────
module torque_arm() {
    color(color_fixed)
    difference() {
        hull() {
            cylinder(d=45, h=torque_arm_t);
            translate([70, 0, 0]) cylinder(d=25, h=torque_arm_t);
        }
        cube([10.2, 14.2, 20], center=true);
        translate([70, 0, 0]) cylinder(d=6.5, h=20, center=true);
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
        for(s=[-1,1]) translate([s*25.5, 0, 25]) rotate([90, 0, 0])
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
            rotate([0, 90, 0]) cylinder(d=14, h=30, center=true);
            translate([0, 0,  8]) cube([30, 30, 20], center=true);
            translate([0, 0, -8]) cube([30, 30, 20], center=true);
        }
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


// ── DRIVETRAIN ─────────────────────────────────────────────────────────────
module drivetrain_assy() {
    color("silver") rotate([90, 0, 0]) cylinder(d=180, h=2, center=true);
    for(a=[0, 180]) rotate([0, a, 0])
        translate([crank_length/2, (a==0 ? 10 : -10), 0]) {
            color(color_fixed)
                rounded_box([crank_length + 20, 12, 30], r=3, center=true);
            translate([crank_length/2, 0, 0])
                color([0.2, 0.2, 0.2])
                rounded_box([80, 90, 20], r=4, center=true);
        }
}


// ── REAR HUB MOTOR ────────────────────────────────────────────────────────────
module rear_hub_motor_geared() {
    color(color_fixed) rotate([90, 0, 0]) cylinder(d=150, h=135, center=true);
    color("black")    rotate([90, 0, 0]) cylinder(d=14,  h=200, center=true);
}


// ── BIPOD KICKSTAND ───────────────────────────────────────────────────────────
module bipod_kickstand(deployed=false) {
    angle = deployed ? 25 : -10;
    color(color_subframe)
    union() {
        rotate([90, 0, 0]) pipe(40, 12, 120);
        for(s=[-1,1]) translate([0, s*45, 0])
            rotate([angle, 0, s*8])
            union() {
                translate([0, 0, -kickstand_leg_len/2])
                    rotate([0, 90, 0])
                    rect_tube(25, 25, kickstand_leg_len);
                translate([0, 0, -kickstand_leg_len])
                    rounded_box([60, 80, 12], r=4, center=true);
            }
    }
}


// ── CARGO BOX ────────────────────────────────────────────────────────────────
module cargo_box_assy() {
    color(color_wood)
    translate([bed_length/2, 0, box_wall_t/2])
    cube([bed_length, bed_width, box_wall_t], center=true);

    color("ghostwhite", 0.8) {
        for(x=[box_wall_t/2, bed_length - box_wall_t/2])
            translate([x, 0, box_height/2 + box_wall_t])
            cube([box_wall_t, bed_width, box_height], center=true);
        for(s=[-1,1])
            translate([bed_length/2, s*(bed_width/2 - box_wall_t/2), box_height/2 + box_wall_t])
            cube([bed_length, box_wall_t, box_height], center=true);
    }
}


// ── MUDGUARD ─────────────────────────────────────────────────────────────────
module mudguard(dia, width, clearance, angle_span=180) {
    total_r = dia/2 + clearance;
    color([0.1, 0.1, 0.1])
    rotate([90, 0, 0])
    rotate([0, 0, 30])
    rotate_extrude(angle=angle_span)
    translate([total_r, 0, 0])
    difference() {
        circle(d=width,   $fn=32);
        circle(d=width-6, $fn=32);
        translate([-width/2, 0, 0]) square([width, width], center=true);
    }
}


// ── MUDGUARD CROWN BRACKET ────────────────────────────────────────────────────
module mudguard_crown_bracket() {
    color(color_fixed)
    difference() {
        union() {
            translate([0, 0, -2]) rounded_box([60, 50, 4], r=5, center=true);
            hull() {
                translate([0, 0, 0])         sphere(d=10);
                translate([-93.3, 0, 51.5])  sphere(d=14);
            }
            translate([-93.3, 0, 51.5]) rotate([0, 22, 0])
            rounded_box([60, 80, 8], r=5, center=true);
        }
        for(y=[-18, 18])
            translate([10, y, -2]) cylinder(d=5.5, h=15, center=true);
        translate([-93.3, 0, 51.5]) rotate([0, 22, 0])
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
        difference() {
            sphere(d=14);
            rotate([0, 90, 0]) cylinder(d=5.5, h=25, center=true);
        }
    }
}
