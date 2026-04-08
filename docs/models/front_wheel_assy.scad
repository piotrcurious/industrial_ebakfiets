include <parts.scad>

module wheel_assy() {
    // 1. CAR TIRE (13")
    car_tire_13in();

    // 2. HUB MOTOR (Internal Detail)
    // Stator/Body
    color("gray")
    cylinder(d=100, h=170, center=true, $fn=64);

    // Axle (14mm with 10mm flats)
    color("black")
    cylinder(d=14, h=250, center=true, $fn=32);

    // 3. FLANGE PLATES (Integration)
    color("silver") {
        // Left Flange
        translate([0, 85, 0]) rotate([90,0,0]) {
            difference() {
                cylinder(d=150, h=5, center=true, $fn=64);
                // Bolt patterns (simplified)
                for(a=[0:90:270]) rotate([0,0,a]) translate([50,0,0]) cylinder(d=12, h=10, center=true, $fn=16);
            }
        }
        // Right Flange
        translate([0, -85, 0]) rotate([90,0,0]) {
            difference() {
                cylinder(d=150, h=5, center=true, $fn=64);
                for(a=[0:90:270]) rotate([0,0,a]) translate([50,0,0]) cylinder(d=12, h=10, center=true, $fn=16);
            }
        }
    }

    // 4. SPLIT RIM CROSS-SECTION
    color("dim gray") {
       translate([0, 80, 0]) rotate([90,0,0]) pipe(330, 310, 10);
       translate([0, -80, 0]) rotate([90,0,0]) pipe(330, 310, 10);
    }
}

wheel_assy();
