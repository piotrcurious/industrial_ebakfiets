include <parts.scad>

module wheel_assy() {
    // 13" Car Tire
    car_tire_13in();

    // Hub Motor (175mm wide)
    color("gray")
    cylinder(d=100, h=175, center=true, $fn=64);

    // Flange Plates
    color("silver") {
        translate([0, 87.5, 0]) rotate([90,0,0]) cylinder(d=150, h=5, center=true, $fn=64);
        translate([0, -87.5, 0]) rotate([90,0,0]) cylinder(d=150, h=5, center=true, $fn=64);
    }
}

wheel_assy();
