include <master_dims.scad>

$fn = 64;

// Color Palette
color_frame = [0.1, 0.2, 0.4];
color_subframe = [0.05, 0.1, 0.2];
color_moving = [0.2, 0.4, 0.8];
color_fixed = [0.3, 0.3, 0.3];
color_critical = [0.7, 0.1, 0.1];
color_fastener = [0.8, 0.8, 0.8];
color_tire = [0.12, 0.12, 0.12];
color_brass = [0.8, 0.6, 0.2];
color_wood = [0.6, 0.4, 0.2];

// Utility: Rounded Box
module rounded_box(size, r, center=true) {
    minkowski() {
        cube(size - [2*r, 2*r, 2*r], center=center);
        sphere(r=r);
    }
}

module car_tire_13in() {
    color(color_tire)
    rotate([90, 0, 0])
    union() {
        // Main Torus
        rotate_extrude()
        translate([front_rim_dia/2, 0, 0])
        hull() {
            circle(d=40);
            translate([(front_tire_od - front_rim_dia)/2, 0, 0])
            square([10, front_tire_width], center=true);
        }
        // Tread Detail
        for(a=[0:10:359]) rotate([0, 0, a]) {
            translate([front_tire_od/2 - 2, 0, 0])
            cube([6, front_tire_width - 15, 12], center=true);
            // Side Tread
            for(s=[-1, 1]) translate([front_tire_od/2 - 10, s * (front_tire_width/2 - 5), 0])
            rotate([0, s*15, 0]) cube([15, 8, 10], center=true);
        }
        // Valve Stem
        rotate([0, 0, 45]) translate([front_rim_dia/2 + 25, 0, 15])
        color("black") cylinder(d=8, h=25);
    }
}

module car_rim_half() {
    rotate([90, 0, 0])
    rotate_extrude()
    difference() {
        union() {
            // Bead Seat
            translate([front_rim_dia/2 + 5, 0, 0]) square([20, 15]);
            // Main Wall
            translate([front_rim_dia/2, 0, 0]) square([15, front_tire_width/2 - 10]);
            // Flange Interface
            translate([front_rim_dia/2 - 120, 0, 0]) square([125, rim_flange_t]);
        }
        // Weight reduction holes (visual)
        for(r=[front_rim_dia/2 - 80]) translate([r, 30, 0]) circle(d=10);
    }
}

module car_rim_13in_split() {
    color(color_fastener) {
        car_rim_half();
        mirror([0, 1, 0]) car_rim_half();
    }
}

module industrial_bolt(d=8, l=50, hex_d=13) {
    color(color_fixed) {
        translate([0, 0, l/2]) rotate([0, 0, 30]) cylinder(d=hex_d, h=5, $fn=6);
        cylinder(d=d, h=l, center=true);
        translate([0, 0, -l/2 - 5]) rotate([0, 0, 30]) cylinder(d=hex_d, h=5, $fn=6);
    }
}

module rim_fastener_pattern() {
    for(a=[0:60:359]) rotate([0, a, 0]) translate([rim_bolt_pcd/2, 0, 0]) rotate([90, 0, 0]) industrial_bolt(8, 50);
}

module hub_motor_dd() {
    // Stator Housing
    color(color_fixed)
    rotate([90, 0, 0])
    union() {
        cylinder(d=240, h=70, center=true);
        // Cooling Fins
        for(a=[0:4:359]) rotate([0, 0, a]) translate([120, 0, 0]) cube([15, 1.5, 65], center=true);
    }

    // Side Covers
    for(s=[-1, 1]) translate([0, s * 40, 0]) rotate([90, 0, 0]) color(color_fixed) {
        cylinder(d=245, h=10, center=true);
        // Perimeter Bolts
        for(a=[0:30:359]) rotate([0,0,a]) translate([115, 0, 5.5]) color(color_fastener) cylinder(d=5, h=4);
    }

    // Main Flanges (Car Rim Mounts)
    for(s=[-1, 1]) translate([0, s * (rim_flange_t + motor_flange_t / 2), 0]) rotate([90, 0, 0]) color(color_subframe) {
        difference() {
            cylinder(d=motor_flange_od, h=motor_flange_t, center=true);
            // Center axle clearance
            cylinder(d=50, h=motor_flange_t+1, center=true);
        }
        // Heavy Duty Bolts
        for(a=[0:60:359]) rotate([0, 0, a]) translate([rim_bolt_pcd/2, 0, motor_flange_t/2*s])
        rotate([0, 0, 30]) color(color_fastener) cylinder(d=15, h=6, $fn=6);
    }

    // Axle
    color("gray") rotate([90, 0, 0]) difference() {
        union() {
            // Main M14 Axle
            cylinder(d=front_axle_dia, h=front_hub_dropout + 60, center=true);
            // Shoulder
            translate([0, 0, -front_hub_dropout/2 - 20]) cylinder(d=25, h=15, center=true);
            // Wire exit slot
            translate([0, 0, front_hub_dropout/2 + 15]) cube([4, 10, 20], center=true);
        }
        // Flattened sides for dropout
        for(s=[-1, 1]) translate([0, 0, s * (front_hub_dropout/2 + 10)]) {
            for(side=[-1, 1]) translate([side * 10, 0, 0]) cube([10, 30, 30], center=true);
        }
    }

    // Brake Rotor (203mm)
    translate([0, 48, 0]) rotate([90, 0, 0]) color("silver") difference() {
        union() {
            cylinder(d=203, h=2, center=true);
            // Hub interface
            cylinder(d=60, h=4, center=true);
        }
        // 6-bolt ISO pattern
        for(a=[0:60:359]) rotate([0, 0, a]) translate([22, 0, 0]) cylinder(d=5.5, h=10, center=true);
        cylinder(d=44, h=10, center=true);
        // Venting holes
        for(r=[70, 85]) for(a=[0:15:359]) rotate([0,0,a]) translate([r, 0, 0]) cylinder(d=4, h=5, center=true);
    }
}

module torque_arm() {
    color(color_fixed)
    difference() {
        union() {
            hull() {
                cylinder(d=45, h=torque_arm_t);
                translate([70, 0, 0]) cylinder(d=25, h=torque_arm_t);
            }
            // Reinforcement rib
            translate([35, 0, torque_arm_t]) cube([40, 10, 4], center=true);
        }
        // Axle slot (10x14)
        cube([10.2, 14.2, 20], center=true);
        // Bolt hole
        translate([70, 0, 0]) cylinder(d=6.5, h=20, center=true);
    }
}

module disc_caliper() {
    color(color_critical)
    union() {
        difference() {
            union() {
                rounded_box([70, 45, 40], r=5, center=true);
                // Mounting ears
                translate([0, 0, 25]) rounded_box([90, 15, 12], r=3, center=true);
            }
            // Rotor slot
            translate([0, 0, -10]) cube([12, 50, 60], center=true);
            // Pistons (visual)
            for(s=[-1, 1]) translate([15*s, 0, 0]) rotate([0, 90, 0]) cylinder(d=25, h=50, center=true);
            // Mounting holes
            for(s=[-1, 1]) translate([s * 25.5, 0, 25]) rotate([90, 0, 0]) cylinder(d=6.2, h=30, center=true);
        }
        // Hydraulic line fitting
        translate([25, 15, 15]) color(color_brass) cylinder(d=8, h=10);
    }
}

module steering_arm(l=steering_arm_len) {
    color(color_fixed)
    difference() {
        union() {
            hull() {
                cylinder(d=40, h=10);
                translate([l, 0, 0]) cylinder(d=25, h=10);
            }
            // Reinforcement
            translate([l/2, 0, 5]) cube([l-20, 15, 12], center=true);
        }
        // Shaft hole
        cylinder(d=15.1, h=30, center=true);
        // Rod end hole
        translate([l, 0, 0]) cylinder(d=10.2, h=30, center=true);
    }
}

module rod_end_m8() {
    color(color_fastener)
    union() {
        difference() {
            sphere(d=24);
            rotate([0, 90, 0]) cylinder(d=14, h=30, center=true);
            translate([0, 0, 10]) cube([40, 40, 10], center=true);
            translate([0, 0, -20]) cube([40, 40, 10], center=true);
        }
        // Brass/Bronze race
        color(color_brass) rotate([0, 90, 0]) difference() {
            cylinder(d=13.8, h=10.5, center=true);
            cylinder(d=8.1, h=25, center=true);
        }
        // Threaded shank
        translate([0, 0, -25]) {
            cylinder(d=10, h=25);
            translate([0, 0, 20]) rotate([0, 0, 30]) cylinder(d=17, h=6, $fn=6);
        }
    }
}

module battery_pack() {
    // Battery Housing
    color("darkslategray")
    union() {
        rounded_box([battery_box_l, battery_box_w, battery_box_h], r=10, center=true);
        // Handles/Brackets
        for(x=[-120, 120]) translate([x, 0, 40]) cube([20, 60, 10], center=true);
    }
    // Retention Straps
    for(x=[-80, 80]) translate([x, 0, 0]) color("black") {
        difference() {
            cube([20, battery_box_w + 10, battery_box_h + 10], center=true);
            cube([battery_box_l + 1, battery_box_w - 5, battery_box_h - 5], center=true);
        }
        // T-bolt tensioners
        translate([0, 0, battery_box_h/2 + 10]) industrial_bolt(6, 20, 10);
    }
    // Connector (Anderson/XT90 style)
    translate([battery_box_l/2 - 20, 0, 0]) color("gold") cube([15, 40, 30], center=true);
}

module motor_controller() {
    color("silver")
    union() {
        difference() {
            rounded_box([controller_box_size, controller_box_size, controller_box_size/2.5], r=5, center=true);
            // Cooling Fins
            for(x=[-50:8:50]) translate([x, 0, controller_box_size/4.5]) cube([1.5, controller_box_size-10, 8], center=true);
        }
        // Mounting tabs
        for(s=[-1, 1]) translate([s * (controller_box_size/2 + 10), 0, -controller_box_size/6])
        cube([20, 40, 5], center=true);
        // Wire exit
        translate([0, controller_box_size/2, 0]) color("dimgray") cylinder(d=30, h=40, center=true);
    }
}

module rect_tube(w, h, l, t=tube_wall_t) {
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
            cylinder(d=12, h=5, center=true);
            translate([0, -6, 0]) cube([5, 12, 5], center=true);
        }
        cylinder(d=7, h=10, center=true);
    }
}

module saddle() {
    // Seatpost
    color(color_fastener) cylinder(d=seat_post_dia, h=350);
    translate([0, 0, 350]) {
        // Rail System
        color(color_fixed) for(s=[-1, 1]) translate([0, s * 20, -15]) rotate([0, 90, 0]) cylinder(d=7, h=250, center=true);
        // Saddle Body
        color([0.15, 0.15, 0.15])
        hull() {
            translate([-120, 0, 10]) sphere(d=60);
            translate([0, 0, 20]) sphere(d=100);
            translate([180, 0, 10]) sphere(d=30);
        }
        // Underside springs
        for(s=[-1, 1]) translate([-80, s * 50, -20]) color("silver") cylinder(d=40, h=40, center=true);
    }
}

module handlebars() {
    // Stem
    color(color_fixed) {
        cylinder(d=stem_dia + 10, h=50);
        translate([40, 0, 70]) rotate([0, 60, 0]) cylinder(d=40, h=100, center=true);
    }
    // Bars
    translate([80, 0, 100]) {
        color("black") rotate([90, 0, 0]) {
            cylinder(d=31.8, h=150, center=true);
            for(s=[-1, 1]) rotate([s*5, 0, 0]) translate([0, 0, s*200]) {
                cylinder(d=22.2, h=400, center=true);
                // Grips
                translate([0, 0, s*280]) color([0.1, 0.1, 0.1]) cylinder(d=32, h=130, center=true);
            }
        }
    }
}

module drivetrain_assy() {
    // Chainring
    color("silver") rotate([90, 0, 0]) {
        difference() {
            cylinder(d=190, h=3, center=true);
            // Spiders
            for(a=[0:72:359]) rotate([0,0,a]) translate([50, 0, 0]) rounded_box([60, 30, 10], r=5, center=true);
        }
    }
    // Cranks
    for(a=[0, 180]) rotate([0, a, 0]) translate([crank_length/2, 0, (a==0 ? 12 : -12)]) {
        color(color_fixed) rounded_box([crank_length + 30, 15, 35], r=5, center=true);
        // Pedals
        translate([crank_length/2, 15 * (a==0 ? 1 : -1), 0]) color([0.2, 0.2, 0.2]) {
             rounded_box([90, 100, 25], r=5, center=true);
             // Reflectors
             translate([0, 51 * (a==0 ? 1 : -1), 0]) color("orange") cube([60, 5, 15], center=true);
        }
    }
}

module rear_hub_motor_geared() {
    // Motor Casing
    color(color_fixed) rotate([90, 0, 0]) {
        cylinder(d=155, h=135, center=true);
        // Cooling ribs
        for(a=[0:10:359]) rotate([0,0,a]) translate([78, 0, 0]) cube([5, 2, 130], center=true);
    }
    // Axle & Hardware
    color("black") rotate([90, 0, 0]) {
        cylinder(d=14, h=220, center=true);
        for(s=[-1, 1]) translate([0, 0, s*80]) cylinder(d=25, h=10, center=true);
    }
}

module bipod_kickstand(deployed=false) {
    angle = deployed ? 25 : -10;
    color(color_subframe) union() {
        // Pivot
        rotate([90, 0, 0]) pipe(45, 12, 140);
        // Legs
        for(s=[-1, 1]) rotate([0, 0, 0]) {
            translate([0, s * 50, 0]) rotate([angle, 0, s * 10]) union() {
                translate([0, 0, -kickstand_leg_len/2]) rect_tube(30, 30, kickstand_leg_len);
                // Feet
                translate([0, 0, -kickstand_leg_len]) rounded_box([80, 100, 15], r=5, center=true);
            }
        }
        // Spring attachment
        translate([-30, 0, 0]) cube([40, 20, 10], center=true);
    }
}

module cargo_box_assy() {
    internal_l = bed_internal_length;
    internal_w = bed_internal_width;

    // Floor
    color(color_wood) translate([bed_length/2, 0, box_wall_t/2])
    cube([bed_length, bed_width, box_wall_t], center=true);

    // Side Walls
    color("ghostwhite", 0.9) {
        for(x=[box_wall_t/2, bed_length - box_wall_t/2])
        translate([x, 0, box_height/2 + box_wall_t]) cube([box_wall_t, bed_width, box_height], center=true);

        for(s=[-1, 1])
        translate([bed_length/2, s * (bed_width/2 - box_wall_t/2), box_height/2 + box_wall_t])
        cube([bed_length, box_wall_t, box_height], center=true);
    }

    // E-track Rails
    color("silver") for(s=[-1, 1]) {
        for(z=[200, 450]) translate([bed_length/2, s * (internal_w/2 - 2), z + box_wall_t]) rotate([0, 90, 0])
        difference() {
            cube([6, etrack_width, internal_l], center=true);
            for(x=[-(internal_l/2 - 50) : 100 : (internal_l/2 - 50)]) translate([0, 0, x]) cube([10, 20, 60], center=true);
        }
    }

    // Edge Protection (Steel Angle)
    color("dimgray") for(s=[-1, 1]) {
        for(z=[box_wall_t, box_height + box_wall_t]) translate([bed_length/2, s * (bed_width/2), z])
        rotate([0, 90, 0]) difference() {
            cube([steel_angle_size, steel_angle_size, bed_length+2], center=true);
            translate([3, 3, 0]) cube([steel_angle_size, steel_angle_size, bed_length + 4], center=true);
        }
    }
}

module mudguard(dia, width, clearance, angle_span) {
    color([0.15, 0.15, 0.15]) rotate([90, 0, 0]) rotate([0, 0, -angle_span/2])
    rotate_extrude(angle = angle_span) translate([dia/2 + clearance, 0, 0])
    difference() {
        circle(d=width);
        circle(d=width-3);
        translate([-width/2, 0, 0]) square([width, width], center=true);
    }
    // Stays
    color("silver") for(a=[-angle_span/2 + 30, angle_span/2 - 30]) rotate([90, 0, 0]) rotate([0, 0, a])
    translate([dia/2 + clearance, 0, 0]) for(s=[-1, 1]) translate([0, s * (width/2 - 5), 0])
    rotate([0, 90, 0]) cylinder(d=4, h=100);
}
