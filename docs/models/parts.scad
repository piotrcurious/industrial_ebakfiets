include <master_dims.scad>

$fn = 64;

// Standard Industrial Parts Library - High Fidelity

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

module bearing_7202() {
    color("blue")
    difference() {
        cylinder(d=bearing_od, h=bearing_h, center=true);
        cylinder(d=bearing_id, h=bearing_h+2, center=true);
    }
}

// 13-inch Car Tire: 155/70 R13
// OD: 548mm, Rim: 330mm, Width: 155mm
module car_tire_13in() {
    color([0.2, 0.2, 0.2])
    rotate_extrude()
    translate([165, 0, 0])
    circle(d=front_tire_width);
}

// M8 Hex Bolt
module bolt_m8(l=30) {
    color("silver") {
        cylinder(d=8, h=l);
        translate([0,0,-4]) cylinder(d=13, h=4, $fn=6);
    }
}

// Shaft Collar 15mm
module shaft_collar_15() {
    color("dimgray")
    difference() {
        cylinder(d=30, h=10, center=true);
        cylinder(d=15.1, h=12, center=true);
        translate([15,0,0]) cube([10, 2, 12], center=true); // Slit
    }
}
