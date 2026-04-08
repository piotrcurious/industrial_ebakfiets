// Standard Industrial Parts Library for E-Bakfiets

// Rectangular tube defined by Width, Height, Length and wall thickness
module rect_tube(width, height, length, thickness=2) {
    difference() {
        cube([length, width, height], center=true);
        cube([length+2, width-2*thickness, height-2*thickness], center=true);
    }
}

// Cylindrical pipe/tube defined by OD, ID and Height
module pipe(od, id, h) {
    difference() {
        cylinder(d=od, h=h, center=true, $fn=64);
        cylinder(d=id, h=h+2, center=true, $fn=64);
    }
}

// 7202 Angular Contact Bearing (15x35x11mm)
module bearing_7202() {
    color("blue")
    difference() {
        cylinder(d=35, h=11, center=true, $fn=64);
        cylinder(d=15, h=12, center=true, $fn=64);
    }
}

// 13-inch Car Tire (155/70 R13) - OD: 548mm, Width: 155mm
module car_tire_13in() {
    color([0.2, 0.2, 0.2])
    rotate_extrude($fn=64)
    translate([165, 0, 0]) // 13" rim radius approx 165mm
    circle(d=155);
}

// 16-inch Moped Wheel (MZ ETZ) - OD: ~410mm
module moped_wheel_16in() {
    color([0.1, 0.1, 0.1])
    rotate_extrude($fn=64)
    translate([150, 0, 0])
    circle(d=110); // 110mm tire width
}

// Two-piece clamping shaft collar
module shaft_collar(id, od, h) {
    color("silver")
    difference() {
        cylinder(d=od, h=h, center=true, $fn=64);
        cylinder(d=id, h=h+2, center=true, $fn=64);
        // Slit
        cube([od+2, 2, h+2], center=true);
    }
}

module bolt_hex(d, l) {
    cylinder(d=d, h=l, $fn=16);
    translate([0,0, -d/2]) cylinder(d=d*1.8, h=d/2, $fn=6);
}
