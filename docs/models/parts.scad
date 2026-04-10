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
    rotate_extrude()
    translate([front_rim_dia/2, 0, 0])
    hull() {
        // Sidewall inner
        circle(d=40);
        // Tread outer (flattened)
        translate([(front_tire_od - front_rim_dia)/2, 0, 0])
        square([10, front_tire_width], center=true);
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
    for(s=[-1, 1]) translate([0, s * 13, 0])
    rotate([90, 0, 0])
    color(color_subframe) {
        cylinder(d=310, h=10, center=true);
        // 6-Bolt M8 Pattern PCD 270 (as per front_wheel.md)
        for(a=[0:60:359]) rotate([0, 0, a]) translate([135, 0, 5*s])
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
