include <parts.scad>

module wheel_assy() {
    // 1. 13" Car Tire
    car_tire_13in();

    // 2. Hub Motor Body (175mm Dropout)
    color("gray")
    rotate([90, 0, 0]) cylinder(d=100, h=170, center=true);

    // 3. Motor Flanges
    color("silver") {
        translate([0, 85, 0]) rotate([90, 0, 0]) cylinder(d=150, h=5, center=true);
        translate([0, -85, 0]) rotate([90, 0, 0]) cylinder(d=150, h=5, center=true);
    }
}

wheel_assy();
