include <parts.scad>

module wheel_assy() {
    // 13" Car Tire
    car_tire_13in();

    // Hub Motor Body
    color("gray")
    rotate([90,0,0]) cylinder(d=100, h=170, center=true, $fn=64);

    // Axle (M14)
    color("black")
    rotate([90,0,0]) cylinder(d=14, h=250, center=true, $fn=32);

    // Motor Flange Plates (Adapting to split rim)
    color("silver") {
        translate([0, 85, 0]) rotate([90,0,0]) cylinder(d=150, h=5, center=true, $fn=64);
        translate([0, -85, 0]) rotate([90,0,0]) cylinder(d=150, h=5, center=true, $fn=64);
    }

    // Brake Rotor (203mm)
    color("red", 0.5)
    translate([0, 95, 0]) rotate([90,0,0]) cylinder(d=203, h=2, center=true, $fn=64);
}

wheel_assy();
