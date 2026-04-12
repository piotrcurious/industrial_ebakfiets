include <master_dims.scad>

$fn = 64;

color_frame = "darkblue";
color_subframe = "midnightblue";
color_moving = "royalblue";
color_fixed = "dimgray";
color_critical = "firebrick";
color_fastener = "silver";
color_tire = [0.15, 0.15, 0.15];

module car_tire_13in() {
    color(color_tire)
    rotate([90, 0, 0])
    union() {
        rotate_extrude()
        translate([front_rim_dia/2, 0, 0])
        hull() {
            circle(d=40);
            translate([(front_tire_od - front_rim_dia)/2, 0, 0])
            square([10, front_tire_width], center=true);
        }
        for(a=[0:10:359]) rotate([0, 0, a])
        translate([front_tire_od/2, 0, 0])
        cube([5, front_tire_width - 10, 20], center=true);
        rotate([0, 0, 45]) translate([front_rim_dia/2 + 20, 0, 20])
        color("black") cylinder(d=8, h=30);
    }
}

module car_rim_half() {
    rotate([90, 0, 0])
    rotate_extrude()
    difference() {
        union() {
            translate([front_rim_dia/2 + 15, 0, 0]) square([10, 20]);
            translate([front_rim_dia/2, 0, 0]) square([15, front_tire_width/2 - 20]);
            translate([front_rim_dia/2 - 30, front_tire_width/2 - 25, 0]) square([30, 10]);
            translate([front_rim_dia/2 - 120, 0, 0]) square([120, rim_flange_t]);
        }
        translate([front_rim_dia/2 + 25, 20, 0]) circle(r=5);
        translate([front_rim_dia/2, front_tire_width/2 - 20, 0]) circle(r=5);
    }
}

module car_rim_13in_split() {
    color(color_fastener) {
        car_rim_half();
        mirror([0, 1, 0]) car_rim_half();
    }
}

module m8_bolt_nut(length=50) {
    translate([0, 0, length/2]) color(color_fixed) cylinder(d=13, h=5, $fn=6);
    color(color_fastener) cylinder(d=8, h=length, center=true);
    translate([0, 0, -length/2 - 5]) color(color_fixed) cylinder(d=13, h=5, $fn=6);
}

module rim_fastener_pattern() {
    pcd = front_rim_dia - 60;
    for(a=[0:60:359]) rotate([0, a, 0]) translate([pcd/2, 0, 0]) rotate([90, 0, 0]) m8_bolt_nut(50);
}

module hub_motor_dd() {
    color(color_fixed)
    rotate([90, 0, 0])
    union() {
        cylinder(d=240, h=80, center=true);
        for(a=[0:5:359]) rotate([0, 0, a]) translate([120, 0, 0]) cube([10, 2, 70], center=true);
    }
    for(s=[-1, 1]) translate([0, s * 45, 0]) rotate([90, 0, 0]) color(color_fixed) {
        cylinder(d=240, h=10, center=true);
        for(a=[0:45:359]) rotate([0,0,a]) translate([110, 0, 5]) color(color_fastener) cylinder(d=6, h=5);
    }
    for(s=[-1, 1]) translate([0, s * (rim_flange_t + motor_flange_t / 2), 0]) rotate([90, 0, 0]) color(color_subframe) {
        cylinder(d=motor_flange_od, h=motor_flange_t, center=true);
        for(a=[0:60:359]) rotate([0, 0, a]) translate([rim_bolt_pcd/2, 0, motor_flange_t/2*s]) color(color_fastener) cylinder(d=13, h=6, $fn=6);
    }
    color("black") rotate([90, 0, 0]) difference() {
        union() {
            cylinder(d=front_axle_dia, h=front_hub_dropout + 40, center=true);
            translate([0, 0, -front_hub_dropout/2 - 25]) cylinder(d=25, h=10, center=true);
        }
        for(s=[-1, 1]) translate([0, 0, s * (front_hub_dropout/2 + 10)]) for(side=[-1, 1]) translate([side * 10, 0, 0]) cube([10, 30, 30], center=true);
        cylinder(d=8, h=front_hub_dropout + 100, center=true);
    }
    translate([0, 45, 0]) rotate([90, 0, 0]) color("silver") difference() {
        cylinder(d=brake_rotor_dia, h=2, center=true);
        for(a=[0:60:359]) rotate([0, 0, a]) translate([22, 0, 0]) cylinder(d=5, h=10, center=true);
        cylinder(d=44, h=10, center=true);
    }
}

module torque_arm() {
    color(color_fixed)
    difference() {
        hull() {
            cylinder(d=40, h=torque_arm_t);
            translate([60, 0, 0]) cylinder(d=20, h=torque_arm_t);
        }
        cube([10.2, 14.5, 20], center=true);
        translate([60, 0, 0]) cylinder(d=6.5, h=20, center=true);
    }
}

module disc_caliper() {
    color("firebrick")
    difference() {
        union() {
            cube([60, 40, 40], center=true);
            translate([0, 0, 25]) cube([80, 10, 10], center=true);
        }
        cube([10, 30, 50], center=true);
        for(s=[-1, 1]) translate([s * 25.5, 0, 25]) rotate([90, 0, 0]) cylinder(d=6, h=20, center=true);
    }
}

module steering_arm(l=steering_arm_len) {
    color(color_fixed)
    difference() {
        hull() {
            cylinder(d=30, h=10);
            translate([l, 0, 0]) cylinder(d=20, h=10);
        }
        cylinder(d=15.2, h=20, center=true);
        translate([l, 0, 0]) cylinder(d=8.2, h=20, center=true);
    }
}

module rod_end_m8() {
    color("silver")
    union() {
        difference() {
            sphere(d=22);
            rotate([0, 90, 0]) cylinder(d=12, h=30, center=true);
            translate([0, 0, 8]) cube([30, 30, 10], center=true);
            translate([0, 0, -18]) cube([30, 30, 10], center=true);
        }
        color("dimgray") rotate([0, 90, 0]) difference() {
            sphere(d=11.8);
            cylinder(d=8.1, h=25, center=true);
        }
        translate([0, 0, -20]) cylinder(d=10, h=20);
    }
}

module battery_pack() {
    color("darkgreen")
    union() {
        cube([battery_box_l, battery_box_w, battery_box_h], center=true);
        for(x=[-100, 100]) translate([x, 0, 0]) color("black") cube([10, battery_box_w + 5, battery_box_h + 5], center=true);
    }
}

module motor_controller() {
    color("silver")
    difference() {
        cube([controller_box_size, controller_box_size, controller_box_size/2], center=true);
        for(x=[-50:10:50]) translate([x, 0, controller_box_size/4]) cube([2, controller_box_size, 5], center=true);
    }
}

module rect_tube(w, h, l, t=tube_wall_t) {
    difference() {
        cube([l, w, h], center=true);
        cube([l+0.1, w-2*t, h-2*t], center=true);
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
        color([0.2, 0.2, 0.2]) hull() {
            translate([-100, 0, 0]) sphere(d=40);
            translate([150, 0, 0]) sphere(d=60);
        }
        color(color_fixed) for(s=[-1, 1]) translate([20, s * 20, -15]) rotate([0, 90, 0]) cylinder(d=7, h=100, center=true);
    }
}

module handlebars() {
    color(color_fixed) cylinder(d=stem_dia, h=150);
    translate([0, 0, 150]) {
        color("black") rotate([0, 90, 0]) cylinder(d=handlebar_dia, h=700, center=true);
        for(s=[-1, 1]) translate([0, s * 300, 0]) rotate([0, 90, 0]) color([0.1, 0.1, 0.1]) cylinder(d=30, h=130, center=true);
    }
}

module drivetrain_assy() {
    color("silver") rotate([90, 0, 0]) cylinder(d=180, h=2, center=true);
    for(a=[0, 180]) rotate([0, a, 0]) translate([crank_length/2, 0, 0]) {
        color(color_fixed) cube([crank_length, 10, 30], center=true);
        translate([crank_length/2, 10 * (a==0 ? 1 : -1), 0]) color([0.3, 0.3, 0.3]) cube([80, 100, 20], center=true);
    }
}

module rear_hub_motor_geared() {
    color(color_fixed) rotate([90, 0, 0]) cylinder(d=140, h=135, center=true);
    color("black") rotate([90, 0, 0]) cylinder(d=12, h=200, center=true);
}

module bipod_kickstand(deployed=false) {
    angle = deployed ? 25 : -10;
    color(color_subframe) union() {
        rotate([0, 90, 0]) pipe(40, 20, 120);
        for(s=[-1, 1]) rotate([angle, 0, 0]) {
            translate([0, s * 40, 0]) rotate([0, 0, s * 12]) union() {
                translate([0, 0, -kickstand_leg_len/2]) rotate([0, 90, 0]) rect_tube(30, 30, kickstand_leg_len);
                translate([0, 0, -kickstand_leg_len]) cube([80, 80, 12], center=true);
            }
        }
    }
}

module cargo_box_assy() {
    internal_l = bed_length - 2 * box_wall_t;
    internal_w = bed_width - 2 * box_wall_t;
    color("burlywood") translate([bed_length/2, 0, box_wall_t/2]) cube([bed_length, bed_width, box_wall_t], center=true);
    color("lightgray", 0.8) difference() {
        union() {
            for(x=[box_wall_t/2, bed_length - box_wall_t/2]) translate([x, 0, box_height/2 + box_wall_t]) cube([box_wall_t, bed_width, box_height], center=true);
            for(s=[-1, 1]) translate([bed_length/2, s * (bed_width/2 - box_wall_t/2), box_height/2 + box_wall_t]) cube([bed_length, box_wall_t, box_height], center=true);
        }
        translate([bed_length/2, 0, box_height + box_wall_t + 10]) cube([bed_length + 100, bed_width + 100, 20], center=true);
    }
    color("dimgray") for(s=[-1, 1]) {
        for(z=[150, 450]) translate([bed_length/2, s * (internal_w/2 - 5), z + box_wall_t]) rotate([0, 90, 0]) difference() {
            cube([10, etrack_width, internal_l], center=true);
            for(x=[-(internal_l/2 - 50) : 100 : (internal_l/2 - 50)]) translate([0, 0, x]) cube([20, 15, 60], center=true);
        }
    }
    color("dimgray") for(s=[-1, 1]) {
        for(z=[box_wall_t, box_height + box_wall_t]) translate([bed_length/2, s * (bed_width/2), z]) rotate([0, 90, 0]) difference() {
            cube([steel_angle_size, steel_angle_size, bed_length], center=true);
            translate([3, 3, 0]) cube([steel_angle_size, steel_angle_size, bed_length + 2], center=true);
        }
    }
}

module mudguard(dia, width, angle_start=0, angle_end=180) {
    color([0.1, 0.1, 0.1]) rotate([90, 0, 0]) rotate([0, 0, angle_start]) difference() {
        rotate_extrude(angle = angle_end - angle_start) translate([dia/2 + mudguard_clearance, 0, 0]) difference() {
            circle(d=width);
            circle(d=width-4);
            translate([-width/2, 0, 0]) square([width, width], center=true);
        }
    }
}
