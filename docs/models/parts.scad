include <master_dims.scad>

// Standard Industrial Parts Library
$fn = 64;

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

module car_tire_13in() {
    color([0.2, 0.2, 0.2])
    rotate_extrude()
    translate([front_wheel_dia/2 - front_tire_width/2, 0, 0])
    circle(d=front_tire_width); // Simplified round profile
}

module moped_tire_16in() {
    color([0.1, 0.1, 0.1])
    rotate_extrude()
    translate([rear_wheel_dia/2 - 50, 0, 0])
    circle(d=100);
}
