include <master_dims.scad>

$fn = 32; // Reduced global resolution for better performance

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

// Utility: Efficient Rounded Box
module rounded_box(size, r, center=true) {
    if (r <= 0) {
        cube(size, center=center);
    } else {
        x = size[0]; y = size[1]; z = size[2];
        translate(center ? [0,0,0] : [x/2, y/2, z/2])
        hull() {
            for (ix = [-1, 1], iy = [-1, 1], iz = [-1, 1]) {
                translate([ix * (x/2 - r), iy * (y/2 - r), iz * (z/2 - r)])
                sphere(r = r, $fn=16);
            }
        }
    }
}

module car_tire_13in() {
    color(color_tire)
    rotate([90, 0, 0])
    union() {
        // Tire Body
        rotate_extrude($fn=64)
        translate([front_rim_dia/2, 0, 0])
        union() {
            // Beads (Dual bead for split rim)
            for(s=[-1, 1]) translate([0, s * 45, 0]) circle(d=22);

            // Sidewall and Tread Structure
            hull() {
                for(s=[-1, 1]) translate([0, s * 45, 0]) circle(d=22);
                translate([(front_tire_od - front_rim_dia)/2 - 20, 0, 0])
                square([40, front_tire_width], center=true);
            }
        }
        // Tread blocks
        for(a=[0:10:359]) rotate([0, 0, a]) {
            translate([front_tire_od/2 - 4, 0, 0])
            rounded_box([12, front_tire_width - 30, 20], r=4, center=true);
        }
    }
}

module car_rim_half() {
    rotate([90, 0, 0])
    rotate_extrude($fn=64)
    union() {
        // Bead Seat (Aligned with front_rim_dia)
        translate([front_rim_dia/2 - 15, -12, 0]) square([20, 24]);
        // Bead Flange
        translate([front_rim_dia/2 + 5, -12, 0]) square([8, 35]);
        // Center Dish (Mating surface)
        translate([front_rim_dia/2 - 140, -rim_flange_t, 0]) square([130, rim_flange_t]);
        // Web (Support)
        translate([front_rim_dia/2 - 20, -12, 0]) square([10, 50]);
    }
}

module car_rim_13in_split() {
    color(color_fastener) {
        // Space them to sandwich the tire beads (~90mm spacing)
        translate([0, 45, 0]) car_rim_half();
        translate([0, -45, 0]) mirror([0, 1, 0]) car_rim_half();
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
    for(a=[0:60:359]) rotate([0, a, 0]) translate([rim_bolt_pcd/2, 0, 0]) rotate([90, 0, 0]) industrial_bolt(8, 110);
}

module hub_motor_dd() {
    // Housing
    color(color_fixed)
    rotate([90, 0, 0])
    union() {
        cylinder(d=240, h=80, center=true);
        for(a=[0:10:359]) rotate([0, 0, a]) translate([120, 0, 0]) cube([15, 3, 75], center=true);
    }

    // Flanges
    for(s=[-1, 1]) translate([0, s * 60, 0]) rotate([90, 0, 0]) color(color_subframe) {
        difference() {
            cylinder(d=motor_flange_od, h=motor_flange_t, center=true);
            cylinder(d=50, h=motor_flange_t+1, center=true);
        }
    }

    // Axle
    color("gray") rotate([90, 0, 0]) difference() {
        union() {
            cylinder(d=front_axle_dia, h=front_hub_dropout + 60, center=true);
            translate([0, 0, -front_hub_dropout/2 - 15]) cylinder(d=25, h=20, center=true);
        }
        for(s=[-1, 1]) translate([0, 0, s * (front_hub_dropout/2 + 10)]) {
            for(side=[-1, 1]) translate([side * 10, 0, 0]) cube([10, 30, 30], center=true);
        }
    }

    // Rotor
    translate([0, 70, 0]) rotate([90, 0, 0]) color("silver") difference() {
        cylinder(d=203, h=2, center=true);
        for(a=[0:60:359]) rotate([0, 0, a]) translate([22, 0, 0]) cylinder(d=5.5, h=10, center=true);
        cylinder(d=44, h=10, center=true);
    }
}

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

module disc_caliper() {
    color(color_critical)
    difference() {
        union() {
            rounded_box([70, 45, 40], r=5, center=true);
            translate([0, 0, 25]) rounded_box([90, 15, 12], r=3, center=true);
        }
        translate([0, 0, -10]) cube([12, 50, 60], center=true);
        for(s=[-1, 1]) translate([s * 25.5, 0, 25]) rotate([90, 0, 0]) cylinder(d=6.2, h=30, center=true);
    }
}

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

module rod_end_m8() {
    color(color_fastener)
    union() {
        difference() {
            sphere(d=22, $fn=16);
            rotate([0, 90, 0]) cylinder(d=14, h=30, center=true);
            translate([0, 0, 12]) cube([30, 30, 10], center=true);
            translate([0, 0, -12]) cube([30, 30, 10], center=true);
        }
        color(color_brass) rotate([0, 90, 0]) difference() {
            cylinder(d=13.8, h=10, center=true);
            cylinder(d=8.1, h=25, center=true);
        }
        translate([0, 0, -20]) cylinder(d=10, h=20);
    }
}

module battery_pack() {
    color("darkslategray")
    rounded_box([battery_box_l, battery_box_w, battery_box_h], r=5, center=true);
    for(x=[-100, 100]) translate([x, 0, 0]) color("black") {
        difference() {
            cube([20, battery_box_w + 5, battery_box_h + 5], center=true);
            cube([battery_box_l + 1, battery_box_w - 2, battery_box_h - 2], center=true);
        }
    }
}

module motor_controller() {
    color("silver")
    difference() {
        rounded_box([controller_box_size, controller_box_size, controller_box_size/3], r=3, center=true);
        for(x=[-50:10:50]) translate([x, 0, controller_box_size/6]) cube([2, controller_box_size-10, 5], center=true);
    }
}

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

module saddle() {
    color(color_fastener) cylinder(d=seat_post_dia, h=300);
    translate([0, 0, 300]) {
        color(color_fixed) for(s=[-1, 1]) translate([0, s * 20, -10]) rotate([0, 90, 0]) cylinder(d=6, h=200, center=true);
        color([0.15, 0.15, 0.15])
        hull() {
            translate([-100, 0, 5]) sphere(d=50, $fn=16);
            translate([0, 0, 15]) sphere(d=80, $fn=16);
            translate([150, 0, 5]) sphere(d=25, $fn=16);
        }
    }
}

module handlebars() {
    color(color_fixed) {
        cylinder(d=stem_dia + 5, h=40);
        translate([30, 0, 50]) rotate([0, 60, 0]) cylinder(d=35, h=80, center=true);
    }
    translate([65, 0, 75]) {
        color("black") rotate([90, 0, 0]) {
            cylinder(d=31.8, h=120, center=true);
            for(s=[-1, 1]) rotate([s*5, 0, 0]) translate([0, 0, s*180]) {
                cylinder(d=22.2, h=350, center=true);
                translate([0, 0, s*250]) color([0.1, 0.1, 0.1]) cylinder(d=30, h=120, center=true);
            }
        }
    }
}

module drivetrain_assy() {
    color("silver") rotate([90, 0, 0]) cylinder(d=180, h=2, center=true);
    for(a=[0, 180]) rotate([0, a, 0]) translate([crank_length/2, 0, (a==0 ? 10 : -10)]) {
        color(color_fixed) rounded_box([crank_length + 20, 12, 30], r=3, center=true);
        translate([crank_length/2, 12 * (a==0 ? 1 : -1), 0]) color([0.2, 0.2, 0.2]) {
             rounded_box([80, 90, 20], r=4, center=true);
        }
    }
}

module rear_hub_motor_geared() {
    color(color_fixed) rotate([90, 0, 0]) cylinder(d=150, h=135, center=true);
    color("black") rotate([90, 0, 0]) cylinder(d=14, h=200, center=true);
}

module bipod_kickstand(deployed=false) {
    angle = deployed ? 25 : -10;
    color(color_subframe) union() {
        rotate([90, 0, 0]) pipe(40, 12, 120);
        for(s=[-1, 1]) {
            translate([0, s * 45, 0]) rotate([angle, 0, s * 8]) union() {
                translate([0, 0, -kickstand_leg_len/2]) rect_tube(25, 25, kickstand_leg_len);
                translate([0, 0, -kickstand_leg_len]) rounded_box([60, 80, 12], r=4, center=true);
            }
        }
    }
}

module cargo_box_assy() {
    color(color_wood) translate([bed_length/2, 0, box_wall_t/2]) cube([bed_length, bed_width, box_wall_t], center=true);
    color("ghostwhite", 0.8) {
        for(x=[box_wall_t/2, bed_length - box_wall_t/2]) translate([x, 0, box_height/2 + box_wall_t]) cube([box_wall_t, bed_width, box_height], center=true);
        for(s=[-1, 1]) translate([bed_length/2, s * (bed_width/2 - box_wall_t/2), box_height/2 + box_wall_t]) cube([bed_length, box_wall_t, box_height], center=true);
    }
}

module mudguard(dia, width, clearance, angle_span) {
    color([0.15, 0.15, 0.15]) rotate([90, 0, 0]) rotate([0, 0, -angle_span/2])
    rotate_extrude(angle = angle_span) translate([dia/2 + clearance, 0, 0])
    difference() {
        circle(d=width);
        circle(d=width-2);
        translate([-width/2, 0, 0]) square([width, width], center=true);
    }
}
