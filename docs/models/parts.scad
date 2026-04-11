include <master_dims.scad>

$fn = 64;

// ---------------------------------------------------------
// COLOR STANDARDS (For Audit Consistency)
// ---------------------------------------------------------
color_frame = "darkblue";
color_subframe = "midnightblue";
color_moving = "royalblue";
color_fixed = "dimgray";
color_critical = "firebrick";
color_fastener = "silver";
color_tire = [0.15, 0.15, 0.15];

// ---------------------------------------------------------
// 1. FRONT TIRE (Root Anchor)
// 155/70 R13
// Oriented along Y-axis (rotating axis)
// ---------------------------------------------------------
module car_tire_13in() {
    color(color_tire)
    rotate([90, 0, 0])
    union() {
        rotate_extrude()
        translate([front_rim_dia/2, 0, 0])
        hull() {
            // Sidewall inner
            circle(d=40);
            // Tread outer (flattened)
            translate([(front_tire_od - front_rim_dia)/2, 0, 0])
            square([10, front_tire_width], center=true);
        }

        // Detailed Tread blocks (Simplified)
        for(a=[0:10:359]) rotate([0, 0, a])
        translate([front_tire_od/2, 0, 0])
        cube([5, front_tire_width - 10, 20], center=true);

        // Schrader Valve
        rotate([0, 0, 45]) translate([front_rim_dia/2 + 20, 0, 20])
        color("black") cylinder(d=8, h=30);
    }
}

// ---------------------------------------------------------
// 2. FRONT RIM (Mates to Tire)
// Split Rim: Two halves bolted together.
// Industrial type with safety hump and deep bead seat.
// ---------------------------------------------------------
module car_rim_half() {
    rotate([90, 0, 0])
    rotate_extrude()
    difference() {
        union() {
            // 1. Bead Flange (Vertical lip)
            translate([front_rim_dia/2 + 15, 0, 0])
            square([10, 20]);

            // 2. Bead Seat (Horizontal)
            translate([front_rim_dia/2, 0, 0])
            square([15, front_tire_width/2 - 20]);

            // 3. Transition / Drop Well (Safety Hump)
            translate([front_rim_dia/2 - 30, front_tire_width/2 - 25, 0])
            square([30, 10]);

            // 4. Main Mating Flange (8mm thick industrial plate)
            // Stretches inward to meet the motor flange
            translate([front_rim_dia/2 - 120, 0, 0])
            square([120, 8]);
        }
        // Chamfers and fillets for tire mounting safety
        translate([front_rim_dia/2 + 25, 20, 0]) circle(r=5);
        translate([front_rim_dia/2, front_tire_width/2 - 20, 0]) circle(r=5);
    }
}

module car_rim_13in_split() {
    color(color_fastener) {
        // Half 1: Mates at Y=0 (Start of 16mm sandwich)
        translate([0, 0, 0])
        car_rim_half();

        // Half 2: Mates at Y=0
        translate([0, 0, 0])
        mirror([0, 1, 0])
        car_rim_half();
    }
}

// ---------------------------------------------------------
// 3. FASTENERS
// ---------------------------------------------------------
module m8_bolt_nut(length=50) {
    // Bolt head
    translate([0, 0, length/2])
    color(color_fixed)
    cylinder(d=13, h=5, $fn=6, center=false);

    // Shaft
    color(color_fastener)
    cylinder(d=8, h=length, center=true);

    // Nut
    translate([0, 0, -length/2 - 5])
    color(color_fixed)
    cylinder(d=13, h=5, $fn=6, center=false);
}

module rim_fastener_pattern() {
    pcd = front_rim_dia - 60;
    for(a=[0:60:359]) {
        rotate([0, a, 0])
        translate([pcd/2, 0, 0]) // Centered at y=0
        rotate([90, 0, 0])
        m8_bolt_nut(50);
    }
}

// ---------------------------------------------------------
// 4. HUB MOTOR (Mates to Rim)
// ---------------------------------------------------------
module hub_motor_dd() {
    // 1. MAIN STATOR HOUSING
    color(color_fixed)
    rotate([90, 0, 0])
    cylinder(d=240, h=80, center=true);

    // 2. SIDE COVERS (Bolt-on)
    for(s=[-1, 1]) translate([0, s * 45, 0])
    rotate([90, 0, 0])
    color(color_fixed) {
        cylinder(d=240, h=10, center=true);
        // Perimeter cover bolts
        for(a=[0:45:359]) rotate([0,0,a]) translate([110, 0, 5])
        color(color_fastener) cylinder(d=6, h=5, center=false);
    }

    // 3. INTEGRATED MOUNTING FLANGES (Heavy Duty)
    // Inner faces at +/- 8mm to sandwich the 16mm rim.
    // Flange centers at +/- 13mm. Flange thickness 10mm.
    for(s=[-1, 1]) translate([0, s * (rim_sandwich_t/4 + 5), 0])
    rotate([90, 0, 0])
    color(color_subframe) {
        cylinder(d=310, h=10, center=true);
        // 6-Bolt M8 Pattern
        for(a=[0:60:359]) rotate([0, 0, a]) translate([rim_bolt_pcd/2, 0, 5*s])
        color(color_fastener) cylinder(d=13, h=6, $fn=6, center=false);
    }

    // 4. AXLE (M14 Steel with 10mm flats)
    color("black")
    rotate([90, 0, 0])
    difference() {
        cylinder(d=front_axle_dia, h=front_hub_dropout + 40, center=true);
        // Axle flats for torque retention (Vertical orientation in dropout)
        // We translate in X before the rotate([90,0,0]) to get Y-aligned flats
        for(s=[-1, 1]) translate([0, 0, s * (front_hub_dropout/2 + 10)])
        for(side=[-1, 1]) translate([side * 10, 0, 0])
        cube([10, 30, 30], center=true);
    }

    // 5. DISC BRAKE ROTOR (180mm)
    translate([0, 45, 0]) // Mounted on left-side motor flange
    rotate([90, 0, 0])
    color("silver")
    difference() {
        cylinder(d=180, h=2, center=true);
        // 6-bolt ISO mount
        for(a=[0:60:359]) rotate([0, 0, a]) translate([22, 0, 0])
        cylinder(d=5, h=10, center=true);
        cylinder(d=44, h=10, center=true);
    }
}

// 10. TORQUE ARM (6mm Steel Plate)
module torque_arm() {
    color(color_fixed)
    difference() {
        hull() {
            cylinder(d=40, h=torque_arm_t);
            translate([60, 0, 0]) cylinder(d=20, h=torque_arm_t);
        }
        // Axle flat cutout (10mm)
        cube([10.2, 14.5, 20], center=true);
        // Fork mounting slot
        translate([60, 0, 0]) cylinder(d=6.5, h=20, center=true);
    }
}

// ---------------------------------------------------------
// 11. DISC BRAKE CALIPER (Mechanical)
// ---------------------------------------------------------
module disc_caliper() {
    color("firebrick")
    difference() {
        union() {
            // Main Body
            cube([60, 40, 40], center=true);
            // Mounting Tabs (IS Standard)
            translate([0, 0, 25]) cube([80, 10, 10], center=true);
        }
        // Rotor Slot
        cube([10, 30, 50], center=true);
        // Mounting Holes
        for(s=[-1, 1]) translate([s * 25.5, 0, 25]) rotate([90, 0, 0]) cylinder(d=6, h=20, center=true);
    }
}

// ---------------------------------------------------------
// 12. STEERING ARMS (Bell Cranks)
// ---------------------------------------------------------
module steering_arm() {
    color(color_fixed)
    difference() {
        hull() {
            cylinder(d=30, h=10);
            translate([steering_arm_len, 0, 0]) cylinder(d=20, h=10);
        }
        // Center Shaft Hole
        cylinder(d=15.2, h=20, center=true);
        // Tie-rod Mounting Hole
        translate([steering_arm_len, 0, 0]) cylinder(d=8.2, h=20, center=true);
    }
}

// Rod-end (Heim Joint) for Steering Linkage
module rod_end_m8() {
    color("silver")
    union() {
        difference() {
            // Housing
            sphere(d=22);
            // Ball pivot hole
            rotate([0, 90, 0]) cylinder(d=12, h=30, center=true);
            // Necking for clearance
            translate([0, 0, 8]) cube([30, 30, 10], center=true);
            translate([0, 0, -18]) cube([30, 30, 10], center=true);
        }
        // The Ball
        color("dimgray")
        rotate([0, 90, 0])
        difference() {
            sphere(d=11.8);
            cylinder(d=8.1, h=25, center=true);
        }
        // Shank
        translate([0, 0, -20]) cylinder(d=10, h=20);
    }
}

// ---------------------------------------------------------
// 13. ELECTRONICS PACKAGING
// ---------------------------------------------------------
module battery_pack() {
    color("darkgreen")
    union() {
        cube([battery_box_l, battery_box_w, battery_box_h], center=true);
        // Straps
        for(x=[-100, 100]) translate([x, 0, 0]) color("black") cube([10, battery_box_w + 5, battery_box_h + 5], center=true);
    }
}

module motor_controller() {
    color("silver")
    difference() {
        cube([controller_box_size, controller_box_size, controller_box_size/2], center=true);
        // Cooling Fins
        for(x=[-50:10:50]) translate([x, 0, controller_box_size/4]) cube([2, controller_box_size, 5], center=true);
    }
}

// ---------------------------------------------------------
// UTILITY SHAPES
// ---------------------------------------------------------
module rect_tube(w, h, l, t=2.5) {
    difference() {
        cube([l, w, h], center=true);
        cube([l+2, w-2*t, h-2*t], center=true);
    }
}

module pipe(od, id, h) {
    difference() {
        cylinder(d=od, h=h, center=true);
        cylinder(d=id, h=h+2, center=true);
    }
}

// 5. CABLE GUIDE EYELET
module cable_guide() {
    color("black")
    rotate([0, 90, 0])
    difference() {
        union() {
            cylinder(d=10, h=4, center=true);
            translate([0, -5, 0]) cube([4, 10, 4], center=true);
        }
        cylinder(d=6, h=6, center=true);
    }
}

// ---------------------------------------------------------
// 6. SADDLE & POST
// ---------------------------------------------------------
module saddle() {
    // Post
    color(color_fastener)
    cylinder(d=seat_post_dia, h=300);

    // Saddle Body
    translate([0, 0, 300]) {
        color([0.2, 0.2, 0.2])
        hull() {
            translate([-100, 0, 0]) sphere(d=40);
            translate([150, 0, 0]) sphere(d=60);
        }
        // Rails
        color(color_fixed)
        for(s=[-1, 1]) translate([20, s * 20, -15])
        rotate([0, 90, 0]) cylinder(d=7, h=100, center=true);
    }
}

// ---------------------------------------------------------
// 7. HANDLEBAR & STEERING COLUMN
// ---------------------------------------------------------
module handlebars() {
    // Stem
    color(color_fixed)
    cylinder(d=stem_dia, h=150);

    // Bars
    translate([0, 0, 150]) {
        color("black")
        rotate([0, 90, 0])
        cylinder(d=handlebar_dia, h=700, center=true);

        // Grips
        for(s=[-1, 1]) translate([0, s * 300, 0])
        rotate([0, 90, 0])
        color([0.1, 0.1, 0.1]) cylinder(d=30, h=130, center=true);
    }
}

// ---------------------------------------------------------
// 8. DRIVETRAIN (Crankset & Pedals)
// ---------------------------------------------------------
module drivetrain_assy() {
    // Chainring
    color("silver")
    rotate([90, 0, 0])
    cylinder(d=180, h=2, center=true);

    // Cranks
    for(a=[0, 180])
    rotate([0, a, 0])
    translate([crank_length/2, 0, 0]) {
        color(color_fixed)
        cube([crank_length, 10, 30], center=true);

        // Pedals
        translate([crank_length/2, 10 * (a==0 ? 1 : -1), 0])
        color([0.3, 0.3, 0.3])
        cube([80, 100, 20], center=true);
    }
}

// ---------------------------------------------------------
// 9. REAR GEARED HUB MOTOR (16" Wheel)
// ---------------------------------------------------------
module rear_hub_motor_geared() {
    color(color_fixed)
    rotate([90, 0, 0])
    cylinder(d=140, h=135, center=true); // Compact geared motor

    // Axle
    color("black")
    rotate([90, 0, 0])
    cylinder(d=12, h=200, center=true);
}

// ---------------------------------------------------------
// 14. BIPOD KICKSTAND (Heavy Duty)
// ---------------------------------------------------------
module bipod_kickstand(deployed=false) {
    // Rotation around pivot axis (X-axis)
    // Deployed: tilted forward/down. Stowed: tucked under bed.
    angle = deployed ? 25 : -10;

    color(color_subframe)
    union() {
        // Pivot Housing (Main cross-bar)
        rotate([0, 90, 0]) pipe(40, 20, 120);

        // Legs
        for(s=[-1, 1]) rotate([angle, 0, 0]) {
            translate([0, s * 40, 0])
            rotate([0, 0, s * 12]) // Splay legs for stability
            union() {
                // Main leg tube (Verticalized rect_tube)
                translate([0, 0, -kickstand_leg_len/2])
                rotate([0, 90, 0])
                rect_tube(30, 30, kickstand_leg_len);

                // Feet (Swivel pads)
                translate([0, 0, -kickstand_leg_len])
                cube([80, 80, 12], center=true);
            }
        }
    }
}

// ---------------------------------------------------------
// 16. CARGO BOX (Internal Structure)
// ---------------------------------------------------------
module cargo_box_assy() {
    internal_l = bed_length - 2 * box_wall_t;
    internal_w = bed_width - 2 * box_wall_t;

    // 1. FLOOR (Plywood/Composite)
    color("burlywood")
    translate([bed_length/2, 0, box_wall_t/2])
    cube([bed_length, bed_width, box_wall_t], center=true);

    // 2. WALLS
    color("lightgray", 0.8)
    difference() {
        union() {
            // Front & Rear
            for(x=[box_wall_t/2, bed_length - box_wall_t/2]) translate([x, 0, box_height/2 + box_wall_t])
            cube([box_wall_t, bed_width, box_height], center=true);

            // Sides
            for(s=[-1, 1]) translate([bed_length/2, s * (bed_width/2 - box_wall_t/2), box_height/2 + box_wall_t])
            cube([bed_length, box_wall_t, box_height], center=true);
        }
        // Top Opening
        translate([bed_length/2, 0, box_height + box_wall_t + 10]) cube([bed_length + 100, bed_width + 100, 20], center=true);
    }

    // 3. INTERNAL MOUNTING RAILS (E-Track style)
    color("dimgray")
    for(s=[-1, 1]) {
        // High and Low Rails
        for(z=[150, 450]) translate([bed_length/2, s * (internal_w/2 - 5), z + box_wall_t])
        rotate([0, 90, 0])
        difference() {
            cube([10, 50, internal_l], center=true);
            // Tie-down slots (E-track pattern)
            for(x=[-(internal_l/2 - 50) : 100 : (internal_l/2 - 50)])
            translate([0, 0, x]) cube([20, 15, 60], center=true);
        }
    }

    // 4. STEEL CORNER ANGLES
    color("dimgray")
    for(s=[-1, 1]) {
        // Horizontal side angles
        for(z=[box_wall_t, box_height + box_wall_t])
        translate([bed_length/2, s * (bed_width/2), z])
        rotate([0, 90, 0])
        difference() {
            cube([25, 25, bed_length], center=true);
            translate([3, 3, 0]) cube([25, 25, bed_length + 2], center=true);
        }
    }
}

// ---------------------------------------------------------
// 15. MUDGUARDS (Fenders)
// ---------------------------------------------------------
module mudguard(dia, width, angle_start=0, angle_end=180) {
    color([0.1, 0.1, 0.1])
    rotate([90, 0, 0])
    rotate([0, 0, angle_start])
    difference() {
        rotate_extrude(angle = angle_end - angle_start)
        translate([dia/2 + mudguard_clearance, 0, 0])
        difference() {
            circle(d=width);
            circle(d=width-4);
            translate([-width/2, 0, 0]) square([width, width], center=true);
        }
    }
}
