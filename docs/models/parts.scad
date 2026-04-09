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
// Split Rim: Two halves bolted together
// ---------------------------------------------------------
module car_rim_half() {
    rotate([90, 0, 0])
    rotate_extrude()
    difference() {
        union() {
            // Main bead seat and flange
            translate([front_rim_dia/2 - 10, 0, 0])
            square([20, front_tire_width/2 - 5], center=false);

            // Mating flange for splitting (10mm thick)
            translate([front_rim_dia/2 - 100, 0, 0])
            square([100, 10], center=false);
        }
        // Bead seat profile
        translate([front_rim_dia/2, front_tire_width/2 - 5, 0])
        circle(d=10);
    }
}

module car_rim_13in_split() {
    color(color_fastener) {
        // Left half (Meets at y=0, Outer at y=10)
        translate([0, 0, 0])
        car_rim_half();

        // Right half (Meets at y=0, Outer at y=-10)
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
    // Motor body
    color(color_fixed)
    rotate([90, 0, 0])
    cylinder(d=220, h=front_hub_dropout - 40, center=true);

    // Wire Exit Detail
    translate([30, 0, 0])
    rotate([90, 0, 0])
    color("black")
    cylinder(d=12, h=front_hub_dropout + 50, center=true);

    // Mounting Flanges (Sandwich the rim halves)
    // Outer faces of rim are at +/- 10.
    // Flanges should be at +/- 15 (centered on 10mm width)
    // so inner faces are at +/- 10.
    // Flange diameter 290mm to capture the 270mm PCD bolt pattern.
    for(s=[-1, 1]) translate([0, s * 15, 0])
    rotate([90, 0, 0])
    color(color_subframe) {
        cylinder(d=290, h=10, center=true);
        // Bolt head detailing for the 6-bolt pattern
        for(a=[0:60:359]) rotate([0, 0, a]) translate([135, 0, 5*s])
        cylinder(d=13, h=5, $fn=6, center=false);
    }

    // AXLE (The physical connection to the Fork)
    color("black")
    rotate([90, 0, 0])
    cylinder(d=front_axle_dia, h=front_hub_dropout + 40, center=true);
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
