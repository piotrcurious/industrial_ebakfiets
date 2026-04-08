include <master_dims.scad>

$fn = 64;

// Surface-to-Surface logic: each part has a local origin
// and defines its "mating" surfaces.

// ---------------------------------------------------------
// TIRE (The Root Anchor)
// ---------------------------------------------------------
module car_tire_13in() {
    color([0.2, 0.2, 0.2])
    rotate_extrude()
    translate([front_tire_od/2 - front_tire_width/4, 0, 0])
    circle(d=front_tire_width/2);

    // RIM (Simplified)
    color("silver")
    rotate_extrude()
    translate([front_rim_dia/2, 0, 0])
    square([20, front_tire_width-20], center=true);
}

// ---------------------------------------------------------
// FRONT HUB (Mates to Tire Center)
// ---------------------------------------------------------
module front_hub_motor() {
    // Body
    color("dimgray")
    rotate([90, 0, 0])
    cylinder(d=180, h=front_hub_dropout - 20, center=true);

    // Axle Protrusions (Mating Surfaces for Fork Dropouts)
    color("black")
    rotate([90, 0, 0])
    cylinder(d=front_axle_dia, h=front_hub_dropout + 40, center=true);

    // Flanges
    for(s=[-1, 1]) translate([0, s*(front_hub_dropout/2 - 10), 0])
    rotate([90, 0, 0])
    color("gray") cylinder(d=200, h=5, center=true);
}

// ---------------------------------------------------------
// RECTANGULAR TUBE (Utility)
// ---------------------------------------------------------
module rect_tube(w, h, l, t=2.5) {
    difference() {
        cube([l, w, h], center=true);
        cube([l+2, w-2*t, h-2*t], center=true);
    }
}

// ---------------------------------------------------------
// PIPE (Utility)
// ---------------------------------------------------------
module pipe(od, id, h) {
    difference() {
        cylinder(d=od, h=h, center=true);
        cylinder(d=id, h=h+2, center=true);
    }
}
