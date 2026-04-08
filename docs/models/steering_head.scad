include <parts.scad>

module steering_head() {
    // 1-1/4" Sch 40 Pipe (OD 42.16, ID 35.05)
    color("gray", 0.5)
    pipe(42.16, 35.05, 200);

    // Internal Stopping Elements (35mm OD)
    color("silver") {
        translate([0, 0, 80]) pipe(35, 16, 8);
        translate([0, 0, -80]) pipe(35, 16, 8);
    }

    // 7202 Bearings (15x35x11)
    color("blue") {
        translate([0, 0, 70.5]) bearing_7202();
        translate([0, 0, -70.5]) bearing_7202();
    }

    // 15mm Steering Shaft
    color("dim gray")
    cylinder(d=15, h=300, center=true);
}

steering_head();
