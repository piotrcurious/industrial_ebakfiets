// Standard Industrial Parts Library for E-Bakfiets

module rect_tube(w, h, l, t=2) {
    difference() {
        cube([l, w, h], center=true);
        cube([l+2, w-2*t, h-2*t], center=true);
    }
}

module pipe(od, id, h) {
    difference() {
        cylinder(d=od, h=h, center=true, $fn=64);
        cylinder(d=id, h=h+2, center=true, $fn=64);
    }
}

module bearing_7202() {
    color("blue")
    difference() {
        cylinder(d=35, h=11, center=true, $fn=64);
        cylinder(d=15, h=12, center=true, $fn=64);
    }
}

module car_tire_13in() {
    color([0.2, 0.2, 0.2])
    rotate([90,0,0])
    rotate_extrude($fn=64)
    translate([274-77.5, 0, 0])
    circle(d=155);
}

module bolt_m8(l=30) {
    cylinder(d=8, h=l, $fn=32);
}
