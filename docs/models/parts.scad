include <master_dims.scad>

$fn = 64;

// ---------------------------------------------------------
// 1. FRONT TIRE (Root Anchor)
// 155/70 R13
// ---------------------------------------------------------
module car_tire_13in() {
    color([0.15, 0.15, 0.15])
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
// ---------------------------------------------------------
module car_rim_13in() {
    color("silver")
    rotate_extrude()
    difference() {
        // Main flange
        translate([front_rim_dia/2 - 10, 0, 0])
        square([20, front_tire_width - 40], center=true);
        // Bead seat
        translate([front_rim_dia/2, 0, 0])
        circle(d=10);
    }

    // Web/Spokes connection surface
    color("gray")
    cylinder(d=front_rim_dia, h=5, center=true);
}

// ---------------------------------------------------------
// 3. HUB MOTOR (Mates to Rim)
// ---------------------------------------------------------
module hub_motor_dd() {
    // Motor body
    color("dimgray")
    rotate([90, 0, 0])
    cylinder(d=220, h=front_hub_dropout - 40, center=true);

    // Mounting Flanges (Mated to Rim center)
    for(s=[-1, 1]) translate([0, s * (front_hub_dropout/2 - 15), 0])
    rotate([90, 0, 0])
    color("gray") cylinder(d=240, h=10, center=true);

    // AXLE (The physical connection to the Fork)
    color("black")
    rotate([90, 0, 0])
    cylinder(d=front_axle_dia, h=front_hub_dropout + 60, center=true);
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
