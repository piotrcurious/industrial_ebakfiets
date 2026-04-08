// Industrial Parts Library for E-Bakfiets
// Coordinate System: X=Length(Forward), Y=Width(Right), Z=Height(Up)

$fn = 64;

// Rectangular tube
module rect_tube(width, height, length, thickness=2.5) {
    difference() {
        cube([length, width, height], center=true);
        cube([length + 2, width - 2*thickness, height - 2*thickness], center=true);
    }
}

// Pipe/Cylinder
module pipe(od, id, h) {
    difference() {
        cylinder(d=od, h=h, center=true);
        cylinder(d=id, h=h+2, center=true);
    }
}

// 7202 Bearing (15x35x11)
module bearing_7202() {
    color("blue")
    difference() {
        cylinder(d=35, h=11, center=true);
        cylinder(d=15, h=12, center=true);
    }
}

// 13-inch Car Tire (155/70 R13)
// Rim dia: 13" (330mm), Tire OD: 548mm, Width: 155mm
module car_tire_13in() {
    color([0.2, 0.2, 0.2])
    rotate([90, 0, 0])
    rotate_extrude()
    translate([165 + 54, 0, 0]) // Rim radius + tire sidewall center
    circle(d=108.5); // 70% of 155 = 108.5
}

// 16-inch Moped Wheel
module moped_wheel_16in() {
    color([0.1, 0.1, 0.1])
    rotate([90, 0, 0])
    rotate_extrude()
    translate([150 + 55, 0, 0])
    circle(d=110);
}

// 19mm Hex Head (Drive)
module hex_head(d=19, h=10) {
    cylinder(d=d/cos(30), h=h, $fn=6, center=true);
}
